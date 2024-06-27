// SPDX-License-Identifier: AGPL-3.0-or-later

use std::thread;

use anyhow::Result;
use aquadoggo::{Configuration, Node};
use log::info;
use p2panda_rs::identity::KeyPair;
use tokio::runtime;
use tokio::sync::mpsc::{channel, Sender};

use crate::api::{NodeEvent, NODE_EVENTS_SINK};

pub struct Manager {
    shutdown_signal: Sender<bool>,
}

impl Manager {
    pub fn new(key_pair: KeyPair, config: Configuration) -> Result<Self> {
        let (shutdown_signal, mut on_shutdown) = channel(4);

        thread::spawn(move || {
            let rt = runtime::Builder::new_current_thread()
                .enable_all()
                .build()
                .expect("Could not create async tokio runtime");

            rt.block_on(async move {
                let node = Node::start(key_pair, config).await;
                let mut tx = node.subscribe().await;

                tokio::task::spawn(async move {
                    // Stream node events further into Dart world
                    loop {
                        while let Some(event) = tx.recv().await {
                            let node_event = match event {
                                aquadoggo::NodeEvent::PeerConnected => NodeEvent::PeerConnected,
                                aquadoggo::NodeEvent::PeerDisconnected => {
                                    NodeEvent::PeerDisconnected
                                }
                            };

                            info!("{:?}", event);

                            NODE_EVENTS_SINK.get().map(|sink| {
                                let sent = sink.add(node_event);
                                info!("{:?}", sent);
                            });
                        }
                    }
                });

                tokio::select! {
                    _ = on_shutdown.recv() => (),
                    _ = node.on_exit() => (),
                }

                node.shutdown().await;
            });
        });

        Ok(Manager { shutdown_signal })
    }

    pub fn shutdown(&self) {
        if self.shutdown_signal.try_send(true).is_err() {
            // Ignore if signal was not received
        }
    }
}
