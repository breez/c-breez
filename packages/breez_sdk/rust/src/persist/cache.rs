use super::db::SqliteStorage;
use rusqlite::Result;

impl SqliteStorage {
    pub fn get_cached_item(&mut self, key: String) -> Result<Option<String>> {
        let res = self.conn.query_row(
            "select value from cached_items where key = ?1",
            [key],
            |row| row.get(0),
        );
        Ok(res.ok())
    }

    pub fn update_cached_item(&mut self, key: String, value: String) -> Result<()> {
        self.conn.execute(
            "insert or replace into cached_items (key, value) values (?1,?2)",
            (key, value),
        )?;
        Ok(())
    }

    pub fn delete_cached_item(&mut self, key: String) -> Result<()> {
        self.conn
            .execute("delete from cached_items where key = ?1", [key])?;
        Ok(())
    }
}

#[test]
fn test_cached_items() {
    if std::path::Path::new("test.sql").exists() {
        std::fs::remove_file("test.sql").unwrap();
    }

    let storage = &mut SqliteStorage::open(String::from("test.sql")).unwrap();
    storage
        .update_cached_item("key1".to_string(), "val1".to_string())
        .unwrap();
    let item_value = storage.get_cached_item("key1".to_string()).unwrap();
    assert_eq!(item_value, Some("val1".to_string()));

    storage.delete_cached_item("key1".to_string()).unwrap();
    let item_value = storage.get_cached_item("key1".to_string()).unwrap();
    assert_eq!(item_value, None);
}
