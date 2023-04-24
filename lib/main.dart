import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

const appName = "Meteo";

// coordinates for Warsaw
// check yours here: https://m.meteo.pl/
class Loc {
  static double x = 250.0, y = 410.0;
}

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  get mapUrl => 'https://m.meteo.pl/img/um_oreografia.png';
  @override
  build(context) => MaterialApp(
      title: appName,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text("$appName for $datetime"),
                bottom: const TabBar(tabs: [
                  Tab(text: "Meteo"),
                  Tab(text: "Location"),
                ])),
            body: TabBarView(
              children: [
                Center(
                    child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 3.0,
                  child: getMeteogram(),
                )),
                Center(
                    child: InteractiveViewer(
                  onInteractionUpdate: (v) {
                    Loc.x = v.localFocalPoint.dx;
                    Loc.y = v.localFocalPoint.dy;
                    // print(currentScale);
                    print(v.localFocalPoint.dx);
                    print(v.localFocalPoint.dy);
                  },
                  minScale: 1.0,
                  maxScale: 3.0,
                  child: Stack(children: [
                    getImage(mapUrl, BoxFit.none),
                    Positioned(
                      left: Loc.x.toDouble(),
                      top: Loc.y.toDouble(),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]),
                )),
              ],
            )),
      ));

  Image getMeteogram() {
    const url =
        'https://meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$datetime&col=${Loc.x}&row=${Loc.y}&lang=en';

    return getImage(url, BoxFit.contain);
  }

  Image getImage(imgurl, fit) {
    var NI = NetworkImage(imgurl);
    // check if image has loaded
    NI.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, call) {
              print('NetworkImage loaded: $imgurl');
            },
            onError: (exception, stackTrace) {
              print('NetworkImage failed to load: $imgurl');
              // print('$exception\n$stackTrace');
            },
          ),
        );

    return Image(
      fit: fit,
      // width: window.physicalSize.width,
      // height: window.physicalSize.height,
      image: NI,
    );
  }

  get datetime {
    var now = DateTime.now().subtract(const Duration(hours: 6));
    return now.year * 1000000 +
        now.month * 10000 +
        now.day * 100 +
        now.hour ~/ 6 * 6;
  }
}
