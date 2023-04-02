import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const appName = "meteo";
void main() {
  runApp(const App());
}

enum States { initial, loading, loaded, error }

class State {
  States current;
  State([this.current = States.initial]);
}

class StateCubit extends Cubit<State> {
  StateCubit(super.initialState);
  download() {
    state.current = States.loading;
    emit(state);
  }

  get currstate => state.current;
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
      child: Column(
        children: [
          Image.network(
              'https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png'),
          Text("The state is now: ${c.currstate}"),
          c.currstate == States.initial
              ? button("Download...", () => c.download())
              : Text("downloading..."),
        ],
      ),
    );

button(txt, func) => ElevatedButton(
      onPressed: func,
      child: Text(txt),
    );
