//! the rust wrapper of the C library of c/hello.c
use std::ffi::{c_char, CStr};

extern "C" {
    fn hello_c() -> *const c_char;
}

/// the string of the C library
pub fn hello() -> &'static str {
    // hello_c returns a static, NUL terminated string
    unsafe { CStr::from_ptr(hello_c()) }.to_str().unwrap()
}
