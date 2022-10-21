use rusqlite::{Connection, Result};
use rusqlite_migration::{Migrations, M};

pub struct SqliteStorage {
    pub(crate) conn: Connection,
}

impl SqliteStorage {
    pub fn open(file: String) -> Result<SqliteStorage> {
        let migrations = Migrations::new(vec![M::up(
            "create table if not exists ln_transactions (
               payment_type text not null check( payment_type in('sent', 'received')),
               payment_hash text not null primary key,
               payment_time integer not null,
               label text,
               destination_pubkey text not null,
               amount_msats integer not null,
               fee_msat integer not null,
               payment_preimage text,
               keysend integer not null,                    
               bolt11 text,
               pending integer not null,
               description text
             );  
             
             create table if not exists settings (
              key text not null primary key,
              value text not null
             );

             create table if not exists cached_items (
              key text not null primary key,
              value text not null
             );                
        ",
        )]);

        let mut conn = Connection::open(file)?;
        migrations.to_latest(&mut conn).unwrap();
        Ok(SqliteStorage { conn: conn })
    }
}
