// SPDX-License-Identifier: AGPL-3.0-or-later

use anyhow::Result;
use p2panda_rs::entry::encode::sign_and_encode_entry;
use p2panda_rs::entry::EntryBuilder;
use p2panda_rs::identity::KeyPair;
use p2panda_rs::operation::encode::encode_operation;
use p2panda_rs::operation::OperationBuilder;
use flutter_rust_bridge::frb;

#[frb(mirror(KeyPair))]
pub struct _KeyPair(KeyPair);

pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
