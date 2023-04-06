import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const appName = "meteo";
void main() {
  runApp(const App());
}

class State {
  int count;
  State([this.count = 0]);
}

class StateCubit extends Cubit<State> {
  StateCubit(super.initialState);
  download() {
    emit(State(state.count + 1));
  }
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  build(context) => MaterialApp(
      title: appName,
      home: Scaffold(
          appBar: AppBar(title: Text("$appName for ${getDatetime()}")),
          body: BlocProvider(
              create: (_) => StateCubit(State()),
              child: BlocBuilder<StateCubit, State>(
                builder: (ctx, _) =>
                    buildContent(BlocProvider.of<StateCubit>(ctx)),
              ))));
  getDatetime() {
    var now = DateTime.now();
    now = now.subtract(const Duration(hours: 6));
    var datetime = now.year * 1000000 +
        now.month * 10000 +
        now.day * 100 +
        now.hour ~/ 6 * 6;
    return datetime;
  }

  get url =>
      'https://meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=${getDatetime()}&row=409&col=248&lang=en';

  buildContent(StateCubit c) {
    return Center(
      child: Column(
        children: [
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 3.0,
            child: Image.network(url),
          ),
          button("Refresh", () => c.download()),
        ],
      ),
    );
  }
}

button(txt, func) => ElevatedButton(
      onPressed: func,
      child: Text(txt),
    );
