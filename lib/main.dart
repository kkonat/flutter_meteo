import 'package:flutter/material.dart';

const appName = "Meteo";
void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  build(context) => MaterialApp(
      title: appName,
      home: Scaffold(
          appBar: AppBar(title: Text("$appName for $datetime")),
          body: Center(
              child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 3.0,
            child: Image.network(url),
          ))));

  get datetime {
    var now = DateTime.now().subtract(const Duration(hours: 6));
    return now.year * 1000000 +
        now.month * 10000 +
        now.day * 100 +
        now.hour ~/ 6 * 6;
  }

  get url =>
      'https://meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$datetime&row=409&col=248&lang=en';
}
