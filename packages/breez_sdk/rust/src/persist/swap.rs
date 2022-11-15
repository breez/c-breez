use crate::models::{Swap, SwapInfo, SwapStatus};

use super::db::SqliteStorage;
use anyhow::Result;

impl SqliteStorage {
    pub fn save_swap_info(&self, swap_info: SwapInfo) -> Result<()> {
        self.get_connection()?.execute(
            "INSERT OR REPLACE INTO swaps (bitcoin_address, created_at, lock_height, payment_hash, preimage, private_key, public_key, paid_sats, confirmed_sats, script, status)
             VALUES (?1,?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)",
            (swap_info.bitcoin_address, swap_info.created_at, swap_info.lock_height, swap_info.payment_hash, swap_info.preimage, swap_info.private_key, swap_info.public_key, swap_info.paid_sats, swap_info.confirmed_sat, swap_info.script, swap_info.status as u32),
        )?;
        Ok(())
    }

    pub fn get_swap_info(&self, address: String) -> Result<Option<SwapInfo>> {
        let res = self.get_connection()?.query_row(
            "SELECT * FROM swaps where bitcoin_address= ?1",
            [address],
            |row| {
                let status: i32 = row.get(10)?;
                let status: SwapStatus = status.try_into().map_or(SwapStatus::Initial, |v| v);
                Ok(SwapInfo {
                    bitcoin_address: row.get(0)?,
                    created_at: row.get(1)?,
                    lock_height: row.get(2)?,
                    payment_hash: row.get(3)?,
                    preimage: row.get(4)?,
                    private_key: row.get(5)?,
                    public_key: row.get(6)?,
                    paid_sats: row.get(7)?,
                    confirmed_sat: row.get(8)?,
                    script: row.get(9)?,
                    status: status,
                })
            },
        )?;
        Ok(Some(res))
    }

    pub fn list_swaps(&self) -> Result<Vec<SwapInfo>> {
        let con = self.get_connection()?;
        let mut stmt = con.prepare(
            format!(
                "
              SELECT * FROM swaps            
             "
            )
            .as_str(),
        )?;
        let vec: Vec<SwapInfo> = stmt
            .query_map([], |row| {
                let status: i32 = row.get(10)?;
                let status: SwapStatus = status.try_into().map_or(SwapStatus::Initial, |v| v);
                Ok(SwapInfo {
                    bitcoin_address: row.get(0)?,
                    created_at: row.get(1)?,
                    lock_height: row.get(2)?,
                    payment_hash: row.get(3)?,
                    preimage: row.get(4)?,
                    private_key: row.get(5)?,
                    public_key: row.get(6)?,
                    paid_sats: row.get(7)?,
                    confirmed_sat: row.get(8)?,
                    script: row.get(9)?,
                    status: status,
                })
            })?
            .map(|i| i.unwrap())
            .collect();

        Ok(vec)
    }
}

#[test]
fn test_swaps() {
    use crate::persist::test_utils;

    let storage = SqliteStorage::from_file(test_utils::create_test_sql_file("swap".to_string()));

    storage.init().unwrap();
    let tested_swap_info = SwapInfo {
        bitcoin_address: String::from("1"),
        created_at: 0,
        lock_height: 100,
        payment_hash: vec![1],
        preimage: vec![2],
        private_key: vec![3],
        public_key: vec![4],
        paid_sats: 100,
        confirmed_sat: 100,
        script: vec![5],
        status: crate::models::SwapStatus::Confirmed,
    };
    storage.save_swap_info(tested_swap_info.clone()).unwrap();
    let item_value = storage.get_swap_info("1".to_string()).unwrap().unwrap();
    assert_eq!(item_value, tested_swap_info);

    let swaps = storage.list_swaps().unwrap();
    assert_eq!(swaps.len(), 1);

    storage.save_swap_info(tested_swap_info.clone()).unwrap();
    assert_eq!(swaps.len(), 1)
}
