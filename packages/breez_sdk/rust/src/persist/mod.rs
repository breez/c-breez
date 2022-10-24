pub(crate) mod cache;
pub(crate) mod db;
pub(crate) mod settings;
pub(crate) mod transactions;

mod test_utils {
    pub fn create_test_sql_file() -> String {
        let mut tmp_file = std::env::temp_dir();
        tmp_file.push("test.sql");
        let path = tmp_file.as_path();
        if path.exists() {
            std::fs::remove_file(path).unwrap();
        }
        let s = path.to_str().unwrap();
        String::from(s)
    }
}
