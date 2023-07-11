// SPDX-License-Identifier: AGPL-3.0-or-later

use anyhow::Result;
use aquadoggo::{Configuration, Node};
use p2panda_rs::identity::KeyPair;
use tokio::runtime::Runtime;
use tokio::sync::mpsc::{channel, Sender};

pub struct Manager {
    shutdown_signal: Sender<bool>,
}

impl Manager {
    pub fn new(key_pair: KeyPair, config: Configuration) -> Result<Self> {
        let (shutdown_signal, mut on_shutdown) = channel(16);

        let rt = Runtime::new()?;

        rt.block_on(async move {
            let node = Node::start(key_pair, config).await;

            tokio::select! {
                _ = on_shutdown.recv() => (),
                _ = node.on_exit() => (),
            }

            node.shutdown().await;
        });

        Ok(Manager { shutdown_signal })
    }

    pub fn shutdown(&self) {
        if self.shutdown_signal.try_send(true).is_err() {
            // Ignore if signal was not received
        }
    }
}
