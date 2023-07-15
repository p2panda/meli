import 'package:graphql/client.dart';

import 'package:app/io/graphql/graphql.dart';

/// GraphQL mutation to publish entries and operations with.
const String PUBLISH_MUTATION = r'''
  mutation Publish($entry: String!, $operation: String!) {
    publish(entry: $entry, operation: $operation) {
      logId
      seqNum
      backlink
      skiplink
    }
  }
''';

/// GraphQL query to retrieve arguments which are required for the creation
/// of the next entry.
const String NEXT_ARGS_QUERY = r'''
  query NextArgs($publicKey: String!, $viewId: String!) {
    nextArgs(publicKey: $publicKey, viewId: $viewId) {
      logId
      seqNum
      backlink
      skiplink
    }
  }
''';

/// Arguments returned from node which are required for the creation of the
/// next entry.
class NextArgs {
  final BigInt logId;
  final BigInt seqNum;
  final String? backlink;
  final String? skiplink;

  NextArgs(
      {required this.logId,
      required this.seqNum,
      this.backlink,
      this.skiplink});
}

/// Helper method to convert GraphQL response to `NextArgs` instance.
NextArgs _toNextArgs(dynamic data) {
  // Large integers like `logId` and `seqNum` are coming as strings from the
  // GraphQL JSON response as u64 is not supported in JavaScript
  return NextArgs(
      logId: BigInt.parse(data['logId'] as String),
      seqNum: BigInt.parse(data['seqNum'] as String),
      backlink: data['backlink'] as String?,
      skiplink: data['skiplink'] as String?);
}

/// Sends a GraphQL `publish` mutation to the node.
Future<NextArgs> publish(String entry, String operation) async {
  final options = QueryOptions(document: gql(PUBLISH_MUTATION), variables: {
    'entry': entry,
    'operation': operation,
  });
  final result = await client.query(options);

  if (result.hasException) {
    throw Exception(result.exception);
  }

  return _toNextArgs(result.data?['publish']);
}

/// Sends a GraphQL `nextArgs` query to the node.
Future<NextArgs> nextArgs(String publicKey, String? viewId) async {
  final options = QueryOptions(document: gql(NEXT_ARGS_QUERY), variables: {
    'publicKey': publicKey,
    'viewId': viewId,
  });
  final result = await client.query(options);

  if (result.hasException) {
    throw Exception(result.exception);
  }

  return _toNextArgs(result.data?['nextArgs']);
}
