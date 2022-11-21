use super::db::SqliteStorage;
use anyhow::{anyhow, Result};

pub struct SettingItem {
    key: String,
    value: String,
}

impl SqliteStorage {
    pub fn update_setting(&self, key: String, value: String) -> Result<()> {
        self.get_connection()?.execute(
            "INSERT OR REPLACE INTO settings (key, value) VALUES (?1,?2)",
            (key, value),
        )?;
        Ok(())
    }

    pub fn get_setting(&self, key: String) -> Result<Option<String>> {
        let res = self.get_connection()?.query_row(
            "SELECT value FROM settings WHERE key = ?1",
            [key],
            |row| row.get(0),
        );
        Ok(res.ok())
    }

    pub fn delete_setting(&self, key: String) -> Result<()> {
        self.get_connection()?
            .execute("DELETE FROM settings WHERE key = ?1", [key])?;
        Ok(())
    }

    pub fn list_settings(&self) -> Result<Vec<SettingItem>> {
        let con = self.get_connection()?;
        let mut stmt = con.prepare("SELECT * FROM settings ORDER BY key")?;
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

    pub fn set_lsp_id(&self, lsp_id: String) -> Result<()> {
        self.update_setting("lsp".to_string(), lsp_id)?;
        Ok(())
    }

    pub fn get_lsp_id(&self) -> Result<Option<String>> {
        self.get_setting("lsp".to_string())
            .map_err(|err| anyhow!(err))
    }
}

#[test]
fn test_settings() {
    use crate::persist::test_utils;

    let storage =
        SqliteStorage::from_file(test_utils::create_test_sql_file("settings".to_string()));
    storage.init().unwrap();
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

    let setting_item = storage.get_setting("key1".to_string()).unwrap().unwrap();
    assert_eq!(setting_item, "val1");
    let settings = storage.list_settings().unwrap();
    assert_eq!(settings.len(), 2);
    assert_eq!(settings[0].key, "key1");
    assert_eq!(settings[0].value, "val1");
    assert_eq!(settings[1].key, "key2");
    assert_eq!(settings[1].value, "val3");
}
