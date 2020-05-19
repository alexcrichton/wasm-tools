#![no_main]

use libfuzzer_sys::*;

fuzz_target!(|data: &[u8]| {
    drop(data);
});


