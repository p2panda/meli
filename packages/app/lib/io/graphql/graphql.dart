import 'package:graphql/client.dart';

/// GraphQL endpoint URL.
const String HTTP_ENDPOINT = 'http://localhost:2020/graphql';

/// GraphQL client making requests against our locally hosted node API.
final GraphQLClient client =
    GraphQLClient(link: HttpLink(HTTP_ENDPOINT), cache: GraphQLCache());
