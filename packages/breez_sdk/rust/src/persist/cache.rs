use super::db::SqliteStorage;
use rusqlite::Result;

impl SqliteStorage {
    pub fn get_cached_item(&mut self, key: String) -> Result<Option<String>> {
        let res = self.conn.query_row(
            "SELECT value FROM cached_items WHERE key = ?1",
            [key],
            |row| row.get(0),
        );
        Ok(res.ok())
    }

    pub fn update_cached_item(&mut self, key: String, value: String) -> Result<()> {
        self.conn.execute(
            "INSERT OR REPLACE INTO cached_items (key, value) values (?1,?2)",
            (key, value),
        )?;
        Ok(())
    }

    pub fn delete_cached_item(&mut self, key: String) -> Result<()> {
        self.conn
            .execute("DELETE FROM cached_items where key = ?1", [key])?;
        Ok(())
    }
}

#[test]
fn test_cached_items() {
    use crate::persist::test_utils;

    let storage = &mut SqliteStorage::open(test_utils::create_test_sql_file()).unwrap();
    storage
        .update_cached_item("key1".to_string(), "val1".to_string())
        .unwrap();
    let item_value = storage.get_cached_item("key1".to_string()).unwrap();
    assert_eq!(item_value, Some("val1".to_string()));

    storage.delete_cached_item("key1".to_string()).unwrap();
    let item_value = storage.get_cached_item("key1".to_string()).unwrap();
    assert_eq!(item_value, None);
}
