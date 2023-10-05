#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.1.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::rust2dart::IntoIntoDart;
use flutter_rust_bridge::*;
use std::ffi::c_void;
use std::sync::Arc;

// Section: imports

// Section: wire functions

fn wire_sign_and_encode_entry_impl(
    port_: MessagePort,
    log_id: impl Wire2Api<String> + UnwindSafe,
    seq_num: impl Wire2Api<String> + UnwindSafe,
    skiplink_hash: impl Wire2Api<Option<String>> + UnwindSafe,
    backlink_hash: impl Wire2Api<Option<String>> + UnwindSafe,
    payload: impl Wire2Api<Vec<u8>> + UnwindSafe,
    key_pair: impl Wire2Api<KeyPair> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<u8>, _>(
        WrapInfo {
            debug_name: "sign_and_encode_entry",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_log_id = log_id.wire2api();
            let api_seq_num = seq_num.wire2api();
            let api_skiplink_hash = skiplink_hash.wire2api();
            let api_backlink_hash = backlink_hash.wire2api();
            let api_payload = payload.wire2api();
            let api_key_pair = key_pair.wire2api();
            move |task_callback| {
                sign_and_encode_entry(
                    api_log_id,
                    api_seq_num,
                    api_skiplink_hash,
                    api_backlink_hash,
                    api_payload,
                    api_key_pair,
                )
            }
        },
    )
}
fn wire_decode_entry_impl(port_: MessagePort, entry: impl Wire2Api<Vec<u8>> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER
        .wrap::<_, _, _, (String, String, String, Option<String>, Option<String>), _>(
            WrapInfo {
                debug_name: "decode_entry",
                port: Some(port_),
                mode: FfiCallMode::Normal,
            },
            move || {
                let api_entry = entry.wire2api();
                move |task_callback| decode_entry(api_entry)
            },
        )
}
fn wire_encode_operation_impl(
    port_: MessagePort,
    action: impl Wire2Api<OperationAction> + UnwindSafe,
    schema_id: impl Wire2Api<String> + UnwindSafe,
    previous: impl Wire2Api<Option<String>> + UnwindSafe,
    fields: impl Wire2Api<Option<Vec<(String, OperationValue)>>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<u8>, _>(
        WrapInfo {
            debug_name: "encode_operation",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_action = action.wire2api();
            let api_schema_id = schema_id.wire2api();
            let api_previous = previous.wire2api();
            let api_fields = fields.wire2api();
            move |task_callback| {
                encode_operation(api_action, api_schema_id, api_previous, api_fields)
            }
        },
    )
}
fn wire_decode_operation_impl(port_: MessagePort, operation: impl Wire2Api<Vec<u8>> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, (OperationAction, String), _>(
        WrapInfo {
            debug_name: "decode_operation",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_operation = operation.wire2api();
            move |task_callback| decode_operation(api_operation)
        },
    )
}
fn wire_start_node_impl(
    port_: MessagePort,
    key_pair: impl Wire2Api<KeyPair> + UnwindSafe,
    database_url: impl Wire2Api<String> + UnwindSafe,
    blobs_base_path: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, (), _>(
        WrapInfo {
            debug_name: "start_node",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_key_pair = key_pair.wire2api();
            let api_database_url = database_url.wire2api();
            let api_blobs_base_path = blobs_base_path.wire2api();
            move |task_callback| start_node(api_key_pair, api_database_url, api_blobs_base_path)
        },
    )
}
fn wire_shutdown_node_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, (), _>(
        WrapInfo {
            debug_name: "shutdown_node",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Result::<_, ()>::Ok(shutdown_node()),
    )
}
fn wire_new__static_method__KeyPair_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, KeyPair, _>(
        WrapInfo {
            debug_name: "new__static_method__KeyPair",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Result::<_, ()>::Ok(KeyPair::new()),
    )
}
fn wire_from_private_key__static_method__KeyPair_impl(
    port_: MessagePort,
    bytes: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, KeyPair, _>(
        WrapInfo {
            debug_name: "from_private_key__static_method__KeyPair",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_bytes = bytes.wire2api();
            move |task_callback| KeyPair::from_private_key(api_bytes)
        },
    )
}
fn wire_private_key__method__KeyPair_impl(
    port_: MessagePort,
    that: impl Wire2Api<KeyPair> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<u8>, _>(
        WrapInfo {
            debug_name: "private_key__method__KeyPair",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_that = that.wire2api();
            move |task_callback| Result::<_, ()>::Ok(KeyPair::private_key(&api_that))
        },
    )
}
fn wire_public_key__method__KeyPair_impl(
    port_: MessagePort,
    that: impl Wire2Api<KeyPair> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<u8>, _>(
        WrapInfo {
            debug_name: "public_key__method__KeyPair",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_that = that.wire2api();
            move |task_callback| Result::<_, ()>::Ok(KeyPair::public_key(&api_that))
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<bool> for bool {
    fn wire2api(self) -> bool {
        self
    }
}

impl Wire2Api<f64> for f64 {
    fn wire2api(self) -> f64 {
        self
    }
}
impl Wire2Api<i32> for i32 {
    fn wire2api(self) -> i32 {
        self
    }
}
impl Wire2Api<i64> for i64 {
    fn wire2api(self) -> i64 {
        self
    }
}

impl Wire2Api<OperationAction> for i32 {
    fn wire2api(self) -> OperationAction {
        match self {
            0 => OperationAction::Create,
            1 => OperationAction::Update,
            2 => OperationAction::Delete,
            _ => unreachable!("Invalid variant for OperationAction: {}", self),
        }
    }
}

impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for KeyPair {
    fn into_dart(self) -> support::DartAbi {
        vec![self.0.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for KeyPair {}
impl rust2dart::IntoIntoDart<KeyPair> for KeyPair {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for OperationAction {
    fn into_dart(self) -> support::DartAbi {
        match self {
            Self::Create => 0,
            Self::Update => 1,
            Self::Delete => 2,
        }
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for OperationAction {}
impl rust2dart::IntoIntoDart<OperationAction> for OperationAction {
    fn into_into_dart(self) -> Self {
        self
    }
}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
mod io {
    use super::*;
    // Section: wire functions

    #[no_mangle]
    pub extern "C" fn wire_sign_and_encode_entry(
        port_: i64,
        log_id: *mut wire_uint_8_list,
        seq_num: *mut wire_uint_8_list,
        skiplink_hash: *mut wire_uint_8_list,
        backlink_hash: *mut wire_uint_8_list,
        payload: *mut wire_uint_8_list,
        key_pair: *mut wire_KeyPair,
    ) {
        wire_sign_and_encode_entry_impl(
            port_,
            log_id,
            seq_num,
            skiplink_hash,
            backlink_hash,
            payload,
            key_pair,
        )
    }

    #[no_mangle]
    pub extern "C" fn wire_decode_entry(port_: i64, entry: *mut wire_uint_8_list) {
        wire_decode_entry_impl(port_, entry)
    }

    #[no_mangle]
    pub extern "C" fn wire_encode_operation(
        port_: i64,
        action: i32,
        schema_id: *mut wire_uint_8_list,
        previous: *mut wire_uint_8_list,
        fields: *mut wire_list___record__String_operation_value,
    ) {
        wire_encode_operation_impl(port_, action, schema_id, previous, fields)
    }

    #[no_mangle]
    pub extern "C" fn wire_decode_operation(port_: i64, operation: *mut wire_uint_8_list) {
        wire_decode_operation_impl(port_, operation)
    }

    #[no_mangle]
    pub extern "C" fn wire_start_node(
        port_: i64,
        key_pair: *mut wire_KeyPair,
        database_url: *mut wire_uint_8_list,
        blobs_base_path: *mut wire_uint_8_list,
    ) {
        wire_start_node_impl(port_, key_pair, database_url, blobs_base_path)
    }

    #[no_mangle]
    pub extern "C" fn wire_shutdown_node(port_: i64) {
        wire_shutdown_node_impl(port_)
    }

    #[no_mangle]
    pub extern "C" fn wire_new__static_method__KeyPair(port_: i64) {
        wire_new__static_method__KeyPair_impl(port_)
    }

    #[no_mangle]
    pub extern "C" fn wire_from_private_key__static_method__KeyPair(
        port_: i64,
        bytes: *mut wire_uint_8_list,
    ) {
        wire_from_private_key__static_method__KeyPair_impl(port_, bytes)
    }

    #[no_mangle]
    pub extern "C" fn wire_private_key__method__KeyPair(port_: i64, that: *mut wire_KeyPair) {
        wire_private_key__method__KeyPair_impl(port_, that)
    }

    #[no_mangle]
    pub extern "C" fn wire_public_key__method__KeyPair(port_: i64, that: *mut wire_KeyPair) {
        wire_public_key__method__KeyPair_impl(port_, that)
    }

    // Section: allocate functions

    #[no_mangle]
    pub extern "C" fn new_PandaKeyPair() -> wire_PandaKeyPair {
        wire_PandaKeyPair::new_with_null_ptr()
    }

    #[no_mangle]
    pub extern "C" fn new_StringList_0(len: i32) -> *mut wire_StringList {
        let wrap = wire_StringList {
            ptr: support::new_leak_vec_ptr(<*mut wire_uint_8_list>::new_with_null_ptr(), len),
            len,
        };
        support::new_leak_box_ptr(wrap)
    }

    #[no_mangle]
    pub extern "C" fn new_box_autoadd_key_pair_0() -> *mut wire_KeyPair {
        support::new_leak_box_ptr(wire_KeyPair::new_with_null_ptr())
    }

    #[no_mangle]
    pub extern "C" fn new_list___record__String_operation_value_0(
        len: i32,
    ) -> *mut wire_list___record__String_operation_value {
        let wrap = wire_list___record__String_operation_value {
            ptr: support::new_leak_vec_ptr(
                <wire___record__String_operation_value>::new_with_null_ptr(),
                len,
            ),
            len,
        };
        support::new_leak_box_ptr(wrap)
    }

    #[no_mangle]
    pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
        let ans = wire_uint_8_list {
            ptr: support::new_leak_vec_ptr(Default::default(), len),
            len,
        };
        support::new_leak_box_ptr(ans)
    }

    // Section: related functions

    #[no_mangle]
    pub extern "C" fn drop_opaque_PandaKeyPair(ptr: *const c_void) {
        unsafe {
            Arc::<PandaKeyPair>::decrement_strong_count(ptr as _);
        }
    }

    #[no_mangle]
    pub extern "C" fn share_opaque_PandaKeyPair(ptr: *const c_void) -> *const c_void {
        unsafe {
            Arc::<PandaKeyPair>::increment_strong_count(ptr as _);
            ptr
        }
    }

    // Section: impl Wire2Api

    impl Wire2Api<RustOpaque<PandaKeyPair>> for wire_PandaKeyPair {
        fn wire2api(self) -> RustOpaque<PandaKeyPair> {
            unsafe { support::opaque_from_dart(self.ptr as _) }
        }
    }
    impl Wire2Api<String> for *mut wire_uint_8_list {
        fn wire2api(self) -> String {
            let vec: Vec<u8> = self.wire2api();
            String::from_utf8_lossy(&vec).into_owned()
        }
    }
    impl Wire2Api<Vec<String>> for *mut wire_StringList {
        fn wire2api(self) -> Vec<String> {
            let vec = unsafe {
                let wrap = support::box_from_leak_ptr(self);
                support::vec_from_leak_ptr(wrap.ptr, wrap.len)
            };
            vec.into_iter().map(Wire2Api::wire2api).collect()
        }
    }
    impl Wire2Api<(String, OperationValue)> for wire___record__String_operation_value {
        fn wire2api(self) -> (String, OperationValue) {
            (self.field0.wire2api(), self.field1.wire2api())
        }
    }

    impl Wire2Api<KeyPair> for *mut wire_KeyPair {
        fn wire2api(self) -> KeyPair {
            let wrap = unsafe { support::box_from_leak_ptr(self) };
            Wire2Api::<KeyPair>::wire2api(*wrap).into()
        }
    }

    impl Wire2Api<KeyPair> for wire_KeyPair {
        fn wire2api(self) -> KeyPair {
            KeyPair(self.field0.wire2api())
        }
    }
    impl Wire2Api<Vec<(String, OperationValue)>> for *mut wire_list___record__String_operation_value {
        fn wire2api(self) -> Vec<(String, OperationValue)> {
            let vec = unsafe {
                let wrap = support::box_from_leak_ptr(self);
                support::vec_from_leak_ptr(wrap.ptr, wrap.len)
            };
            vec.into_iter().map(Wire2Api::wire2api).collect()
        }
    }

    impl Wire2Api<OperationValue> for wire_OperationValue {
        fn wire2api(self) -> OperationValue {
            match self.tag {
                0 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.Boolean);
                    OperationValue::Boolean(ans.field0.wire2api())
                },
                1 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.Float);
                    OperationValue::Float(ans.field0.wire2api())
                },
                2 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.Integer);
                    OperationValue::Integer(ans.field0.wire2api())
                },
                3 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.String);
                    OperationValue::String(ans.field0.wire2api())
                },
                4 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.Bytes);
                    OperationValue::Bytes(ans.field0.wire2api())
                },
                5 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.Relation);
                    OperationValue::Relation(ans.field0.wire2api())
                },
                6 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.RelationList);
                    OperationValue::RelationList(ans.field0.wire2api())
                },
                7 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.PinnedRelation);
                    OperationValue::PinnedRelation(ans.field0.wire2api())
                },
                8 => unsafe {
                    let ans = support::box_from_leak_ptr(self.kind);
                    let ans = support::box_from_leak_ptr(ans.PinnedRelationList);
                    OperationValue::PinnedRelationList(ans.field0.wire2api())
                },
                _ => unreachable!(),
            }
        }
    }

    impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
        fn wire2api(self) -> Vec<u8> {
            unsafe {
                let wrap = support::box_from_leak_ptr(self);
                support::vec_from_leak_ptr(wrap.ptr, wrap.len)
            }
        }
    }
    // Section: wire structs

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_PandaKeyPair {
        ptr: *const core::ffi::c_void,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_StringList {
        ptr: *mut *mut wire_uint_8_list,
        len: i32,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire___record__String_operation_value {
        field0: *mut wire_uint_8_list,
        field1: wire_OperationValue,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_KeyPair {
        field0: wire_PandaKeyPair,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_list___record__String_operation_value {
        ptr: *mut wire___record__String_operation_value,
        len: i32,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_uint_8_list {
        ptr: *mut u8,
        len: i32,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue {
        tag: i32,
        kind: *mut OperationValueKind,
    }

    #[repr(C)]
    pub union OperationValueKind {
        Boolean: *mut wire_OperationValue_Boolean,
        Float: *mut wire_OperationValue_Float,
        Integer: *mut wire_OperationValue_Integer,
        String: *mut wire_OperationValue_String,
        Bytes: *mut wire_OperationValue_Bytes,
        Relation: *mut wire_OperationValue_Relation,
        RelationList: *mut wire_OperationValue_RelationList,
        PinnedRelation: *mut wire_OperationValue_PinnedRelation,
        PinnedRelationList: *mut wire_OperationValue_PinnedRelationList,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_Boolean {
        field0: bool,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_Float {
        field0: f64,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_Integer {
        field0: i64,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_String {
        field0: *mut wire_uint_8_list,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_Bytes {
        field0: *mut wire_uint_8_list,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_Relation {
        field0: *mut wire_uint_8_list,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_RelationList {
        field0: *mut wire_StringList,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_PinnedRelation {
        field0: *mut wire_uint_8_list,
    }

    #[repr(C)]
    #[derive(Clone)]
    pub struct wire_OperationValue_PinnedRelationList {
        field0: *mut wire_StringList,
    }

    // Section: impl NewWithNullPtr

    pub trait NewWithNullPtr {
        fn new_with_null_ptr() -> Self;
    }

    impl<T> NewWithNullPtr for *mut T {
        fn new_with_null_ptr() -> Self {
            std::ptr::null_mut()
        }
    }

    impl NewWithNullPtr for wire_PandaKeyPair {
        fn new_with_null_ptr() -> Self {
            Self {
                ptr: core::ptr::null(),
            }
        }
    }

    impl NewWithNullPtr for wire___record__String_operation_value {
        fn new_with_null_ptr() -> Self {
            Self {
                field0: core::ptr::null_mut(),
                field1: Default::default(),
            }
        }
    }

    impl Default for wire___record__String_operation_value {
        fn default() -> Self {
            Self::new_with_null_ptr()
        }
    }

    impl NewWithNullPtr for wire_KeyPair {
        fn new_with_null_ptr() -> Self {
            Self {
                field0: wire_PandaKeyPair::new_with_null_ptr(),
            }
        }
    }

    impl Default for wire_KeyPair {
        fn default() -> Self {
            Self::new_with_null_ptr()
        }
    }

    impl Default for wire_OperationValue {
        fn default() -> Self {
            Self::new_with_null_ptr()
        }
    }

    impl NewWithNullPtr for wire_OperationValue {
        fn new_with_null_ptr() -> Self {
            Self {
                tag: -1,
                kind: core::ptr::null_mut(),
            }
        }
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_Boolean() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            Boolean: support::new_leak_box_ptr(wire_OperationValue_Boolean {
                field0: Default::default(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_Float() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            Float: support::new_leak_box_ptr(wire_OperationValue_Float {
                field0: Default::default(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_Integer() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            Integer: support::new_leak_box_ptr(wire_OperationValue_Integer {
                field0: Default::default(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_String() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            String: support::new_leak_box_ptr(wire_OperationValue_String {
                field0: core::ptr::null_mut(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_Bytes() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            Bytes: support::new_leak_box_ptr(wire_OperationValue_Bytes {
                field0: core::ptr::null_mut(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_Relation() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            Relation: support::new_leak_box_ptr(wire_OperationValue_Relation {
                field0: core::ptr::null_mut(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_RelationList() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            RelationList: support::new_leak_box_ptr(wire_OperationValue_RelationList {
                field0: core::ptr::null_mut(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_PinnedRelation() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            PinnedRelation: support::new_leak_box_ptr(wire_OperationValue_PinnedRelation {
                field0: core::ptr::null_mut(),
            }),
        })
    }

    #[no_mangle]
    pub extern "C" fn inflate_OperationValue_PinnedRelationList() -> *mut OperationValueKind {
        support::new_leak_box_ptr(OperationValueKind {
            PinnedRelationList: support::new_leak_box_ptr(wire_OperationValue_PinnedRelationList {
                field0: core::ptr::null_mut(),
            }),
        })
    }

    // Section: sync execution mode utility

    #[no_mangle]
    pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
        unsafe {
            let _ = support::box_from_leak_ptr(ptr);
        };
    }
}
#[cfg(not(target_family = "wasm"))]
pub use io::*;
