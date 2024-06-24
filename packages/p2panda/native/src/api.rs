// SPDX-License-Identifier: AGPL-3.0-or-later

use std::str::FromStr;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

use android_logger::{AndroidLogger, Config, FilterBuilder};
use anyhow::{anyhow, Result};
use aquadoggo::{AllowList, Configuration};
use ed25519_dalek::SecretKey;
use flutter_rust_bridge::{RustOpaque, StreamSink};
use log::{Level, LevelFilter, Log, Record};
use p2panda_rs::document::DocumentViewId;
use p2panda_rs::entry;
use p2panda_rs::entry::traits::{AsEncodedEntry, AsEntry};
use p2panda_rs::hash::Hash;
pub use p2panda_rs::identity::KeyPair as PandaKeyPair;
use p2panda_rs::operation;
use p2panda_rs::operation::traits::{Actionable, Schematic};
use p2panda_rs::operation::EncodedOperation;
use p2panda_rs::schema::SchemaId;
use tokio::sync::OnceCell;

use crate::node::Manager;

static NODE_INSTANCE: OnceCell<Manager> = OnceCell::const_new();

static STREAM_SINK: OnceCell<StreamSink<LogEntry>> = OnceCell::const_new();

static LOGGER: OnceCell<Logger> = OnceCell::const_new();

struct Logger {
    android_logger: AndroidLogger,
    max_level: LevelFilter,
}

impl Logger {
    fn new(max_level: LevelFilter) -> Logger {
        let android_config = Config::default().with_max_level(max_level).with_filter(
            FilterBuilder::new()
                .filter(Some("aquadoggo"), LevelFilter::Debug)
                .build(),
        );
        let android_logger = AndroidLogger::new(android_config);

        Logger {
            android_logger,
            max_level,
        }
    }

    fn record_to_entry(record: &Record) -> LogEntry {
        let timestamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_else(|_| Duration::from_secs(0))
            .as_millis() as u64;

        let level = match record.level() {
            Level::Trace => LogLevel::Trace,
            Level::Debug => LogLevel::Debug,
            Level::Info => LogLevel::Info,
            Level::Warn => LogLevel::Warn,
            Level::Error => LogLevel::Error,
        };

        let tag = record.file().unwrap_or_else(|| record.target()).to_owned();

        let msg = format!("{}", record.args());

        LogEntry {
            timestamp,
            level,
            tag,
            msg,
        }
    }
}

impl Log for Logger {
    fn enabled(&self, metadata: &log::Metadata) -> bool {
        metadata.level() <= self.max_level
    }

    fn log(&self, record: &log::Record) {
        match STREAM_SINK.get() {
            Some(sink) => {
                sink.add(Logger::record_to_entry(record));
            }
            None => (),
        }

        self.android_logger.log(record);
    }

    fn flush(&self) {}
}

pub fn subscribe_log_stream(sink: StreamSink<LogEntry>) {
    let _ = STREAM_SINK.set(sink);
}

pub enum LogLevel {
    Trace,
    Debug,
    Info,
    Warn,
    Error,
}

pub struct LogEntry {
    pub timestamp: u64,
    pub level: LogLevel,
    pub tag: String,
    pub msg: String,
}

pub type HexString = String;

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
///
/// Takes large u64 integers for log id and seq num as strings. If we would declare them as u64
/// here they will get converted to int which is not a real native u64 integer in Dart! We pass
/// them over as strings and then safely convert them to u64 internally.
pub fn sign_and_encode_entry(
    log_id: String,
    seq_num: String,
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
        &log_id.parse()?,
        &seq_num.parse()?,
        skiplink_hash.as_ref(),
        backlink_hash.as_ref(),
        &EncodedOperation::from_bytes(&payload),
        &key_pair.0,
    )?;

    Ok(encoded_entry.into_bytes())
}

/// Decodes a p2panda entry.
///
/// Returns large u64 integers for log id and seq num as strings. If we would declare them as u64
/// here they will get converted to int which is not a real native u64 integer in Dart! We pass
/// them over as strings and then safely convert them to `BigInt` in the Dart world.
pub fn decode_entry(
    entry: Vec<u8>,
) -> Result<(String, String, String, Option<String>, Option<String>)> {
    let encoded_entry = entry::EncodedEntry::from_bytes(&entry);
    let entry = entry::decode::decode_entry(&encoded_entry)?;

    Ok((
        entry.public_key().to_string(),
        format!("{}", entry.log_id().as_u64()),
        format!("{}", entry.seq_num().as_u64()),
        entry.backlink().map(|hash| hash.to_string()),
        entry.skiplink().map(|hash| hash.to_string()),
    ))
}

/// Operations are categorised by their action type.
///
/// An action defines the operation format and if this operation creates, updates or deletes a data
/// document.
pub enum OperationAction {
    /// Operation creates a new document.
    Create,

    /// Operation updates an existing document.
    Update,

    /// Operation deletes an existing document.
    Delete,
}

/// Enum of possible data types which can be added to the operations fields as values.
pub enum OperationValue {
    /// Boolean value.
    Boolean(bool),

    /// Floating point value.
    Float(f64),

    /// Signed integer value.
    Integer(i64),

    /// String value.
    String(String),

    /// Bytes value.
    Bytes(Vec<u8>),

    /// Reference to a document.
    Relation(HexString),

    /// Reference to a list of documents.
    RelationList(Vec<HexString>),

    /// Reference to a document view.
    ///
    /// Multiple operation ids are separated by an understore ('_').
    PinnedRelation(HexString),

    /// Reference to a list of document views.
    ///
    /// Multiple operation ids are separated by an understore ('_').
    PinnedRelationList(Vec<HexString>),
}

/// Encode a p2panda operation parsed from JSON input.
pub fn encode_operation(
    action: OperationAction,
    schema_id: String,
    previous: Option<String>,
    fields: Option<Vec<(String, OperationValue)>>,
) -> Result<Vec<u8>> {
    let schema_id: SchemaId = schema_id.parse()?;

    let mut builder = operation::OperationBuilder::new(&schema_id).action(action.into());

    if let Some(view_id_str) = previous {
        let view_id: DocumentViewId = view_id_str.parse()?;
        builder = builder.previous(&view_id);
    };

    if let Some(fields) = fields {
        let fields: Result<Vec<(String, operation::OperationValue)>> = fields
            .into_iter()
            .map(|(field_name, field_value)| {
                // Convert operation value from external FFI Dart type to internal Rust type
                let field_value: operation::OperationValue = field_value.try_into()?;
                Ok((field_name, field_value))
            })
            .collect();

        builder = builder.fields(fields?.as_ref());
    }

    let operation = builder.build()?;

    let encoded_operation = operation::encode::encode_operation(&operation)?;
    Ok(encoded_operation.into_bytes())
}

/// Decodes an p2panda operation, returning it's action and schema id.
pub fn decode_operation(operation: Vec<u8>) -> Result<(OperationAction, String)> {
    let encoded_operation = EncodedOperation::from_bytes(&operation);
    let plain_operation = operation::decode::decode_operation(&encoded_operation)?;

    // @TODO: This does not return the operation fields yet
    Ok((
        plain_operation.action().into(),
        plain_operation.schema_id().to_string(),
    ))
}

/// Runs a p2panda node in a separate thread in the background.
///
/// Supports Android logging for logs coming from the node.
pub fn start_node(
    log_level: String,
    key_pair: KeyPair,
    database_url: String,
    blobs_base_path: String,
    relay_addresses: Vec<String>,
    allow_schema_ids: Vec<String>,
) -> Result<()> {
    let _ = LOGGER.set(Logger::new(
        LevelFilter::from_str(&log_level).expect("unknown log level"),
    ));

    // Set node configuration
    let mut config = Configuration::default();
    config.database_url = database_url;
    config.blobs_base_path = blobs_base_path.into();
    config.worker_pool_size = 1;
    config.database_max_connections = 16;
    let allow_schema_ids = allow_schema_ids
        .iter()
        .map(|id| SchemaId::new(id))
        .collect::<Result<Vec<SchemaId>, _>>()?;
    config.allow_schema_ids = AllowList::Set(allow_schema_ids);
    config.network.mdns = true;
    config.network.relay_addresses = relay_addresses
        .into_iter()
        .map(|address| address.into())
        .collect();

    // Convert key pair from external FFI type to internal one
    let secret_key: SecretKey = SecretKey::from_bytes(&key_pair.private_key())?;
    let key_pair = PandaKeyPair::from_private_key(&secret_key)?;

    // Spawn node
    let manager = Manager::new(key_pair, config)?;
    NODE_INSTANCE
        .set(manager)
        .map_err(|_| anyhow!("Node already initialised"))?;

    Ok(())
}

/// Turns off running node.
pub fn shutdown_node() {
    match NODE_INSTANCE.get() {
        Some(manager) => manager.shutdown(),
        None => {
            panic!("Node was not initialised")
        }
    }
}
