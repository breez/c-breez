use crate::models::{SwapInfo, SwapStatus};

use super::db::SqliteStorage;
use anyhow::{anyhow, Result};
use rusqlite::{named_params, Connection, OptionalExtension};

impl SqliteStorage {
    pub fn insert_swap(&self, swap_info: SwapInfo) -> Result<()> {
        self.get_connection()?.execute(
         "INSERT INTO swaps (bitcoin_address, created_at, lock_height, payment_hash, preimage, private_key, public_key, swapper_public_key, bolt11, paid_sats, confirmed_sats, script, status)
          VALUES (:bitcoin_address, :created_at, :lock_height, :payment_hash, :preimage, :private_key, :public_key, :swapper_public_key, :bolt11, :paid_sats, :confirmed_sats,  :script, :status)",
         named_params! {
             ":bitcoin_address": swap_info.bitcoin_address,
             ":created_at": swap_info.created_at,
             ":lock_height": swap_info.lock_height,
             ":payment_hash": swap_info.payment_hash,
             ":preimage": swap_info.preimage,
             ":private_key": swap_info.private_key,
             ":public_key": swap_info.public_key,
             ":swapper_public_key": swap_info.swapper_public_key,
             ":paid_sats": swap_info.paid_sats,
             ":confirmed_sats": swap_info.confirmed_sats,
             ":script": swap_info.script,
             ":bolt11": None::<String>,
             ":status": swap_info.status as u32,
         },
        )?;

        Ok(())
    }

    pub fn update_swap_paid_amount(&self, bitcoin_address: String, paid_sats: u32) -> Result<()> {
        self.get_connection()?.execute(
            "UPDATE swaps SET paid_sats=:paid_sats where bitcoin_address=:bitcoin_address",
            named_params! {
             ":paid_sats": paid_sats,
             ":bitcoin_address": bitcoin_address,
            },
        )?;

        Ok(())
    }

    pub fn update_swap_bolt11(&self, bitcoin_address: String, bolt11: String) -> Result<()> {
        self.get_connection()?.execute(
            "UPDATE swaps SET bolt11=:bolt11 where bitcoin_address=:bitcoin_address",
            named_params! {
             ":bolt11": bolt11,
             ":bitcoin_address": bitcoin_address,
            },
        )?;

        Ok(())
    }

    pub fn update_swap_chain_info(
        &self,
        bitcoin_address: String,
        confirmed_sats: u32,
        status: SwapStatus,
    ) -> Result<SwapInfo> {
        self.get_connection()?.execute(
            "UPDATE swaps SET confirmed_sats=:confirmed_sats, status=:status where bitcoin_address=:bitcoin_address",
            named_params! {
             ":confirmed_sats": confirmed_sats,
             ":bitcoin_address": bitcoin_address,
             ":status": status as u32
            },
        )?;
        Ok(self.get_swap_info(bitcoin_address)?.unwrap())
    }

    pub fn get_swap_info(&self, address: String) -> Result<Option<SwapInfo>> {
        self.get_connection()?
            .query_row(
                "SELECT * FROM swaps where bitcoin_address= ?1",
                [address],
                |row| {
                    let status: i32 = row.get(12)?;
                    let status: SwapStatus = status.try_into().map_or(SwapStatus::Initial, |v| v);
                    Ok(SwapInfo {
                        bitcoin_address: row.get(0)?,
                        created_at: row.get(1)?,
                        lock_height: row.get(2)?,
                        payment_hash: row.get(3)?,
                        preimage: row.get(4)?,
                        private_key: row.get(5)?,
                        public_key: row.get(6)?,
                        swapper_public_key: row.get(7)?,
                        script: row.get(8)?,
                        bolt11: row.get(9)?,
                        paid_sats: row.get(10)?,
                        confirmed_sats: row.get(11)?,
                        status: status,
                    })
                },
            )
            .optional()
            .map_err(|e| anyhow!(e))
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
                let status: i32 = row.get(12)?;
                let status: SwapStatus = status.try_into().map_or(SwapStatus::Initial, |v| v);
                Ok(SwapInfo {
                    bitcoin_address: row.get(0)?,
                    created_at: row.get(1)?,
                    lock_height: row.get(2)?,
                    payment_hash: row.get(3)?,
                    preimage: row.get(4)?,
                    private_key: row.get(5)?,
                    public_key: row.get(6)?,
                    swapper_public_key: row.get(7)?,
                    script: row.get(8)?,
                    bolt11: row.get(9)?,
                    paid_sats: row.get(10)?,
                    confirmed_sats: row.get(11)?,
                    status: status,
                })
            })?
            .map(|i| i.unwrap())
            .collect();

        Ok(vec)
    }
}

#[test]
fn test_swaps() -> Result<(), Box<dyn std::error::Error>> {
    use crate::persist::test_utils;

    let storage = SqliteStorage::from_file(test_utils::create_test_sql_file("swap".to_string()));

    storage.init()?;
    let tested_swap_info = SwapInfo {
        bitcoin_address: String::from("1"),
        created_at: 0,
        lock_height: 100,
        payment_hash: vec![1],
        preimage: vec![2],
        private_key: vec![3],
        public_key: vec![4],
        swapper_public_key: vec![5],
        script: vec![5],
        bolt11: None,
        paid_sats: 0,
        confirmed_sats: 0,
        status: crate::models::SwapStatus::Initial,
    };
    storage.insert_swap(tested_swap_info.clone())?;
    let item_value = storage.get_swap_info("1".to_string())?.unwrap();
    assert_eq!(item_value, tested_swap_info);

    let non_existent_swap = storage.get_swap_info("non-existent".to_string())?;
    assert!(non_existent_swap.is_none());

    let swaps = storage.list_swaps()?;
    assert_eq!(swaps.len(), 1);

    let err = storage.insert_swap(tested_swap_info.clone());
    //assert_eq!(swaps.len(), 1);
    assert!(err.is_err());

    storage.update_swap_chain_info(
        tested_swap_info.bitcoin_address.clone(),
        20,
        SwapStatus::Expired,
    )?;

    storage.update_swap_paid_amount(tested_swap_info.bitcoin_address.clone(), 30)?;
    let updated_swap = storage
        .get_swap_info(tested_swap_info.bitcoin_address)?
        .unwrap();
    assert_eq!(updated_swap.paid_sats, 30);
    assert_eq!(updated_swap.confirmed_sats, 20);
    assert_eq!(updated_swap.status, SwapStatus::Expired);

    Ok(())
}
