import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'FLutter GQL',
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        // ignore: unnecessary_cast
        link: httpLink as Link,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      ),
    );
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String getTasksQuery = """
query {
  continents {
    name
  }
}
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GraphQL Client"),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(documentNode: gql(getTasksQuery)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.data == null) {
            return Text("Boooooo!");
          }
          if (result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(result.data['continents']);
          return ListView.builder(
            itemCount: result.data['continents'].length,
            itemBuilder: (context, index) {
              return Text(result.data['continents'][index]['name']);
            },
          );
        },
      ),
    );
  }
}
