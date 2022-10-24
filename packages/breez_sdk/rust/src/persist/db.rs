use rusqlite::{Connection, Result};
use rusqlite_migration::{Migrations, M};

pub struct SqliteStorage {
    pub(crate) conn: Connection,
}

impl SqliteStorage {
    pub fn open(file: String) -> Result<SqliteStorage> {
        let migrations = Migrations::new(vec![M::up(
            "CREATE TABLE IF NOT EXISTS ln_transactions (
               payment_type TEXT NOT NULL check( payment_type in('sent', 'received')),
               payment_hash TEXT NOT NULL PRIMARY KEY,
               payment_time INTEGER NOT NULL,
               label TEXT,
               destination_pubkey TEXT NOT NULL,
               amount_msats INTEGER NOT NULL,
               fee_msat INTEGER NOT NULL,
               payment_preimage TEXT,
               keysend INTEGER NOT NULL,                  
               bolt11 TEXT,
               pending INTEGER NOT NULL,
               description TEXT
             ) STRICT;  
             
             CREATE TABLE IF NOT EXISTS settings (
              key TEXT NOT NULL PRIMARY KEY,
              value TEXT NOT NULL
             ) STRICT;

             CREATE TABLE IF NOT EXISTS cached_items (
              key TEXT NOT NULL PRIMARY KEY,
              value TEXT NOT NULL
             ) STRICT;                
        ",
        )]);

        let mut conn = Connection::open(file)?;
        migrations.to_latest(&mut conn).unwrap();
        Ok(SqliteStorage { conn: conn })
    }
}
