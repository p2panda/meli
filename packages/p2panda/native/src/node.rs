// SPDX-License-Identifier: AGPL-3.0-or-later

use std::thread;

use anyhow::Result;
use aquadoggo::{Configuration, Node};
use p2panda_rs::identity::KeyPair;
use tokio::runtime;
use tokio::sync::mpsc::{channel, Sender};

struct PanicDetector {}

impl Drop for PanicDetector {
    fn drop(&mut self) {
        if std::thread::panicking() {
            panic!("OUUUCH");
        }
    }
}

pub struct Manager {
    shutdown_signal: Sender<bool>,
}

impl Manager {
    pub fn new(key_pair: KeyPair, config: Configuration) -> Result<Self> {
        let (shutdown_signal, mut on_shutdown) = channel(4);

        thread::spawn(move || {
            let _ = PanicDetector {};

            let rt = runtime::Builder::new_current_thread()
                .enable_all()
                .build()
                .expect("Could not create async tokio runtime");

            rt.block_on(async move {
                let node = Node::start(key_pair, config).await;

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
