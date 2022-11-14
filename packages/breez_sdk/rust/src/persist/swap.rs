use crate::models::SwapInfo;

use super::db::SqliteStorage;
use anyhow::Result;

impl SqliteStorage {
    pub fn save_swap_info(&self, swap_info: SwapInfo) -> Result<()> {
        self.get_connection()?.execute(
            "INSERT OR REPLACE INTO swaps (bitcoin_address, lock_height, payment_hash, preimage, private_key, public_key, paid_sats, confirmed_sats, script)
             VALUES (?1,?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)",
            (swap_info.bitcoin_address, swap_info.lock_height, swap_info.payment_hash, swap_info.preimage, swap_info.private_key, swap_info.public_key, 0, 0, swap_info.script),
        )?;
        Ok(())
    }
}
