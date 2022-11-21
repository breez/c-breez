use anyhow::Result;
use core::time;
use std::sync::{Arc, Mutex};
use tokio::sync::mpsc;

use crate::chain::MempoolSpace;

/// ChainNotifier is responsible for monitoring the chain and notify chain events
/// to its listeners.
pub(crate) struct ChainNotifier {
    chain_service: Arc<MempoolSpace>,
    listeners: Mutex<Vec<Arc<dyn Listener>>>,
}

impl ChainNotifier {
    pub(crate) fn new(chain_service: Arc<MempoolSpace>) -> Self {
        Self {
            listeners: Mutex::new(vec![]),
            chain_service,
        }
    }

    pub(crate) async fn poll_tip(&self, last_block: u32) -> Result<u32> {
        let tip = self.chain_service.current_tip().await?;
        if tip > last_block {
            self.notify(ChainEvent::NewBlock(tip)).await;
        }
        debug!("current tip = {} last_block = {}", tip, last_block);
        Ok(tip)
    }

    pub(crate) fn add_listener(&mut self, listener: Arc<dyn Listener>) {
        let mut listeners = self.listeners.lock().unwrap();
        listeners.push(listener);
    }

    async fn notify(&self, event: ChainEvent) {
        let listeners = self.listeners.lock().unwrap();
        for listener in listeners.iter() {
            let res = listener.on_event(event.clone()).await;
            match res {
                Ok(()) => {}
                Err(e) => {
                    error!("failed to notify chain listener {}", e);
                }
            };
        }
    }
}

#[tonic::async_trait]
pub(crate) trait Listener: Send + Sync {
    async fn on_event(&self, e: ChainEvent) -> Result<()>;
}

#[derive(Clone, Debug)]
pub(crate) enum ChainEvent {
    NewBlock(u32),
}

/// starts a background thread monitor the chain periodically.
pub(crate) fn start(monitor: Arc<ChainNotifier>, shutdown: mpsc::Receiver<()>) {
    std::thread::spawn(move || {
        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async move {
                poll(monitor, shutdown).await;
            })
    });
}

async fn poll(monitor: Arc<ChainNotifier>, mut shutdown: mpsc::Receiver<()>) {
    let mut interval = tokio::time::interval(time::Duration::from_secs(30));
    let mut current_block = 0;
    loop {
        tokio::select! {
         _ = interval.tick() => async {
          let tip_res = monitor.poll_tip(current_block).await;
          match tip_res {
           Ok(next_block) => {
            current_block = next_block
           },
           Err(e) => {
            error!("failed to fetch next block {}", e)
           }
          }
         },
         _ = shutdown.recv() => {
           debug!("Received the signal to exit the chain monitoring loop");
           break;
         }
        }
        .await;
    }
}
