// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:graphql/client.dart';

/// GraphQL endpoint URL.
const String HTTP_ENDPOINT = 'http://localhost:2020/graphql';

final policies = Policies(
  fetch: FetchPolicy.networkOnly,
);

/// GraphQL client making requests against our locally hosted node API.
final GraphQLClient client = GraphQLClient(
  link: HttpLink(HTTP_ENDPOINT),
  cache: GraphQLCache(),
  // Disable caching by overriding default policies. See:
  // https://github.com/zino-hofmann/graphql-flutter/issues/692
  defaultPolicies: DefaultPolicies(
    watchQuery: policies,
    query: policies,
    mutate: policies,
  ),
);
