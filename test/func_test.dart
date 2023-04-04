import 'package:flutter_test/flutter_test.dart';
import 'package:meteo/main.dart';

void main() {
  test('StateCubit', () {
    var sc = StateCubit(State());
    // expect(sc.datetime, "2023040212");
    expect(sc.url,
        'https://meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2023040212&row=409&col=248&lang=en');
  });
  test('printDateTime', () {
    var sc = StateCubit(State());
    // print(sc.state.datetime().toString());
  });
}
