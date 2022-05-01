use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn test(to: *const c_char) -> *mut c_char {
 let c_str = unsafe { CStr::from_ptr(to) };
 let recipient = match c_str.to_str() {
  Err(_) => "there",
  Ok(string) => string,
 };

 CString::new("Hello ".to_owned() + recipient)
  .unwrap()
  .into_raw()
}

#[no_mangle]
pub extern "C" fn test_cstr_free(s: *mut c_char) {
 unsafe {
  if s.is_null() {
   return;
  }
  CString::from_raw(s)
 };
}
