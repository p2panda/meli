// SPDX-License-Identifier: AGPL-3.0-or-later

use anyhow::{Error, Result};
use p2panda_rs::document::{DocumentId, DocumentViewId};
use p2panda_rs::operation::{self, PinnedRelation, PinnedRelationList, Relation, RelationList};

use crate::api::{OperationAction, OperationValue};

/// Convert operation actions from external FFI Dart type to internal Rust type.
impl From<OperationAction> for operation::OperationAction {
    fn from(value: OperationAction) -> operation::OperationAction {
        match value {
            OperationAction::Create => operation::OperationAction::Create,
            OperationAction::Update => operation::OperationAction::Update,
            OperationAction::Delete => operation::OperationAction::Delete,
        }
    }
}

/// Convert operation value from external FFI Dart type to internal Rust type.
impl TryFrom<OperationValue> for operation::OperationValue {
    type Error = Error;

    fn try_from(value: OperationValue) -> Result<operation::OperationValue> {
        match value {
            OperationValue::Boolean(value) => Ok(operation::OperationValue::Boolean(value)),
            OperationValue::Float(value) => Ok(operation::OperationValue::Float(value)),
            OperationValue::Integer(value) => Ok(operation::OperationValue::Integer(value)),
            OperationValue::String(value) => Ok(operation::OperationValue::String(value)),
            OperationValue::Relation(document_id_str) => {
                let document_id: DocumentId = document_id_str.parse()?;
                Ok(operation::OperationValue::Relation(Relation::new(
                    document_id,
                )))
            }
            OperationValue::RelationList(document_id_str_vec) => {
                let document_id_vec: Result<Vec<DocumentId>> = document_id_str_vec
                    .into_iter()
                    .map(|id_str| {
                        let document_id = id_str.parse()?;
                        Ok(document_id)
                    })
                    .collect();

                Ok(operation::OperationValue::RelationList(RelationList::new(
                    document_id_vec?,
                )))
            }
            OperationValue::PinnedRelation(view_id_str) => {
                let view_id: DocumentViewId = view_id_str.parse()?;
                Ok(operation::OperationValue::PinnedRelation(
                    PinnedRelation::new(view_id),
                ))
            }
            OperationValue::PinnedRelationList(view_id_str_vec) => {
                let view_id_vec: Result<Vec<DocumentViewId>> = view_id_str_vec
                    .into_iter()
                    .map(|view_id_str| {
                        let view_id = view_id_str.parse()?;
                        Ok(view_id)
                    })
                    .collect();

                Ok(operation::OperationValue::PinnedRelationList(
                    PinnedRelationList::new(view_id_vec?),
                ))
            }
        }
    }
}
