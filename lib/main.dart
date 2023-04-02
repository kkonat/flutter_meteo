import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const appName = "meteo";
void main() {
  runApp(const App());
}

class State {
  int count;
  State([this.count = 0]);
  get datetime {
    var now = DateTime.now();
    now = now.subtract(const Duration(hours: 6));
    var datetime = now.year * 1000000 +
        now.month * 10000 +
        now.day * 100 +
        now.hour ~/ 6 * 6;
    return datetime;
  }
}

class StateCubit extends Cubit<State> {
  StateCubit(super.initialState);
  download() {
    emit(State(state.count + 1));
  }

  get url =>
      'https://meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=${state.datetime}&row=409&col=248&lang=en';
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  build(context) => MaterialApp(
      title: appName,
      home: Scaffold(
          appBar: AppBar(title: Text(appName)),
          body: BlocProvider(
              create: (_) => StateCubit(State()),
              child: BlocBuilder<StateCubit, State>(
                builder: (ctx, _) =>
                    buildContent(BlocProvider.of<StateCubit>(ctx)),
              ))));
}

buildContent(StateCubit c) => Center(
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          children: [
            Text("Meteogram for${c.state.datetime}"),
            Image.network(c.url),
            button("Refresh", () => c.download()),
          ],
        ),
      ),
    );

button(txt, func) => ElevatedButton(
      onPressed: func,
      child: Text(txt),
    );
