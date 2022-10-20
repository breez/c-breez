use anyhow::{anyhow, Result};
use ecies::{decrypt, encrypt};

pub fn _encrypt(key: Vec<u8>, msg: Vec<u8>) -> Result<Vec<u8>> {
 match encrypt(key.as_slice(), msg.as_slice()) {
  Ok(res) => Ok(res),
  Err(err) => Err(anyhow!(err)),
 }
}

pub fn _decrypt(key: Vec<u8>, msg: Vec<u8>) -> Result<Vec<u8>> {
 match decrypt(key.as_slice(), msg.as_slice()) {
  Ok(res) => Ok(res),
  Err(err) => Err(anyhow!(err)),
 }
}
