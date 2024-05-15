import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Web Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var controller = TextEditingController();
  late Uri wsUrl;
  late WebSocketChannel channel;

  List<String> messages = [];

  Future<void> _init() async {
    print("Init called");
    wsUrl = Uri.parse('ws://localhost:8080');
    channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;

    // channel.stream.listen((message) {
    //   print("message---- $message");
    //   // messages.add(messages)
    //   // channel.sink.add('received!');
    //   // channel.sink.close(status.goingAway);
    // });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _onSendClicked(String value) {
    print("on Send clicked");
    channel.sink.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration:
                        InputDecoration(enabledBorder: OutlineInputBorder()),
                    controller: controller,
                    onFieldSubmitted: _onSendClicked,
                  ),
                ),
                IconButton(
                    onPressed: () => _onSendClicked(controller.text),
                    icon: Icon(Icons.send))
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messages.add(snapshot.data);
                  }
                  print("snapshot data ${snapshot.data}");
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
