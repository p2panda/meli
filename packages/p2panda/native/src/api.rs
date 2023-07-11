// SPDX-License-Identifier: AGPL-3.0-or-later

use anyhow::Result;
use ed25519_dalek::SecretKey;
use flutter_rust_bridge::RustOpaque;
use p2panda_rs::entry;
use p2panda_rs::entry::traits::AsEncodedEntry;
use p2panda_rs::hash::Hash;
pub use p2panda_rs::identity::KeyPair as PandaKeyPair;
use p2panda_rs::operation;
use p2panda_rs::operation::EncodedOperation;

pub type HexString = String;
pub type JsonString = String;

/// Ed25519 key pair for authors to sign p2panda entries with.
pub struct KeyPair(pub RustOpaque<PandaKeyPair>);

impl KeyPair {
    /// Generates a new key pair using the systems random number generator (CSPRNG) as a seed.
    pub fn new() -> KeyPair {
        KeyPair(RustOpaque::new(PandaKeyPair::new()))
    }

    /// Derives a key pair from a private key.
    pub fn from_private_key(bytes: Vec<u8>) -> Result<KeyPair> {
        let secret_key: SecretKey = SecretKey::from_bytes(&bytes)?;
        let key_pair = PandaKeyPair::from_private_key(&secret_key)?;
        Ok(KeyPair(RustOpaque::new(key_pair)))
    }

    /// Returns the private half of the key pair.
    pub fn private_key(&self) -> Vec<u8> {
        self.0.private_key().to_bytes().to_vec()
    }

    /// Returns the public half of the key pair.
    pub fn public_key(&self) -> Vec<u8> {
        self.0.public_key().to_bytes().to_vec()
    }
}

/// Create, sign and encode a p2panda entry.
pub fn sign_and_encode_entry(
    log_id: u64,
    seq_num: u64,
    skiplink_hash: Option<HexString>,
    backlink_hash: Option<HexString>,
    payload: Vec<u8>,
    key_pair: KeyPair,
) -> Result<Vec<u8>> {
    let skiplink_hash: Option<Hash> = match skiplink_hash {
        Some(hash) => {
            let hash = hash.try_into()?;
            Some(hash)
        }
        None => None,
    };

    let backlink_hash: Option<Hash> = match backlink_hash {
        Some(hash) => {
            let hash = hash.try_into()?;
            Some(hash)
        }
        None => None,
    };

    let encoded_entry = entry::encode::sign_and_encode_entry(
        &log_id.into(),
        &seq_num.try_into()?,
        skiplink_hash.as_ref(),
        backlink_hash.as_ref(),
        &EncodedOperation::from_bytes(&payload),
        &key_pair.0,
    )?;

    Ok(encoded_entry.into_bytes())
}

/// Encode a p2panda operation parsed from JSON input.
pub fn encode_operation(json: JsonString) -> Result<Vec<u8>> {
    let plain_operation = serde_json::from_str(&json)?;
    let encoded_operation = operation::encode::encode_plain_operation(&plain_operation)?;
    Ok(encoded_operation.into_bytes())
}
