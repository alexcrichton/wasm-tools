#![no_main]

use libfuzzer_sys::*;

fuzz_target!(|data: &[u8]| {
    if data.len() == 4 {
        panic!()
    }
});

