import 'package:mover/app/common/utils/remote_config.dart';
import 'package:graphql/client.dart';

class ModSearchEndpoint extends GraphqlInterfaceAbstract {
  ModSearchEndpoint(query, graphqlURI) : super(query, graphqlURI);

  @override
  List<dynamic> _getNodeData(Map<String, dynamic>? _data) {
    if (_data == null) return [];
    final List<dynamic> nodes = _data['moderators']['nodes'];
    return nodes;
  }
}

abstract class GraphqlInterfaceAbstract {
  GraphqlInterfaceAbstract(this.readRepositories, this.graphqlURL);

  late GraphQLClient _client;

  final String readRepositories;
  final String graphqlURL;

  Future<void> init() async {
    final store = await HiveStore.open(boxName: "$this");
    _client = GraphQLClient(
      cache: GraphQLCache(store: store),
      link: HttpLink(
        graphqlURL,
      ),
    );

    List<dynamic> _getNodeData(Map<String, dynamic>? _data) {
      if (_data == null) return [];
      final List<dynamic> nodes = _data['search']['nodes'];
      return nodes;
    }
  }

  Future<List<dynamic>> query(
      {final int nDaos = 0,
      final int nFirst = 100,
      final int nOffset = 0,
      final bool networkOnly = false}) async {
    print("$nFirst : $nOffset");
    final QueryOptions options = QueryOptions(
      document: gql(readRepositories),
      fetchPolicy: networkOnly ? FetchPolicy.networkOnly : null,
      variables: <String, dynamic>{
        'nFirst': nFirst,
        'nOffset': nOffset,
        'nDaos': nDaos,
      },
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
    }

    final List<dynamic> repositories = _getNodeData(result.data);

    return repositories;
  }

  List<dynamic> getCache({final int nFirst = 100, final int nOffset = 0}) {
    print("cache $nFirst : $nOffset");
    final QueryOptions options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'nFirst': nFirst,
        'nOffset': nOffset,
      },
    );

    final Map<String, dynamic> result = _client.readQuery(options.asRequest)!;

    final List<dynamic> repositories = _getNodeData(result);
    print(repositories.length);

    return repositories;
  }

  List<dynamic> _getNodeData(Map<String, dynamic>? _data);
}
