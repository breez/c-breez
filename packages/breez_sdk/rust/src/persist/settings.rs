use super::db::SqliteStorage;
use rusqlite::Result;

pub struct SettingItem {
    key: String,
    value: String,
}

impl SqliteStorage {
    pub fn update_setting(&mut self, key: String, value: String) -> Result<()> {
        self.conn.execute(
            "INSERT OR REPLACE INTO settings (key, value) VALUES (?1,?2)",
            (key, value),
        )?;
        Ok(())
    }

    pub fn delete_setting(&mut self, key: String) -> Result<()> {
        self.conn
            .execute("DELETE FROM settings WHERE key = ?1", [key])?;
        Ok(())
    }

    pub fn list_settings(&mut self) -> Result<Vec<SettingItem>> {
        let mut stmt = self.conn.prepare("SELECT * FROM settings ORDER BY key")?;
        let vec = stmt
            .query_map([], |row| {
                Ok(SettingItem {
                    key: row.get(0)?,
                    value: row.get(1)?,
                })
            })?
            .map(|i| i.unwrap())
            .collect();

        Ok(vec)
    }
}

#[test]
fn test_settings() {
    use crate::persist::test_utils;

    let storage = &mut SqliteStorage::open(test_utils::create_test_sql_file()).unwrap();
    storage
        .update_setting("key1".to_string(), "val1".to_string())
        .unwrap();
    storage
        .update_setting("key2".to_string(), "val2".to_string())
        .unwrap();
    storage
        .update_setting("key2".to_string(), "val3".to_string())
        .unwrap();
    storage
        .update_setting("key4".to_string(), "val4".to_string())
        .unwrap();
    storage.delete_setting("key4".to_string()).unwrap();

    let settings = storage.list_settings().unwrap();
    assert_eq!(settings.len(), 2);
    assert_eq!(settings[0].key, "key1");
    assert_eq!(settings[0].value, "val1");
    assert_eq!(settings[1].key, "key2");
    assert_eq!(settings[1].value, "val3");
}
