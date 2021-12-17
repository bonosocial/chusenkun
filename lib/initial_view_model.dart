import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scratcher/widgets.dart';

final initialViewModelProvider =
    ChangeNotifierProvider((ref) => InitialViewModel(ref.read));

class InitialViewModel extends ChangeNotifier {
  InitialViewModel(this._reader);

  final Reader _reader;

  final _key = GlobalKey<ScratcherState>();

  final _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 10));

  int _time = 0;

  int _seed = 0;

  String _tousensha = "";

  List<String> _sankasha = [];

  List<bool> _isSellected = [];

  TextEditingController _controller = TextEditingController();

  ConfettiController get controllerCenter => _controllerCenter;

  String get tousensha => _tousensha;

  int get time => _time;

  int get seed => _seed;

  GlobalKey<ScratcherState> get key => _key;

  List<String> get sankasha => _sankasha;

  TextEditingController get controller => _controller;

  List<bool> get isSellected => _isSellected;

  void add() {
    _sankasha.add(_controller.text);
    _isSellected.add(false);
    _controller.clear();
    notifyListeners();
  }

  void delete(int index) {
    _sankasha.removeAt(index);
    _isSellected.removeAt(index);
    notifyListeners();
  }

  void check(int index, bool value) {
    _isSellected[index] = value;
    notifyListeners();
  }

  void loadData() {
    //TODO: Implement
    Timer.periodic(Duration(microseconds: 1), onTimer);
  }

  void onTimer(Timer timer) {
    _time = DateTime.now().microsecondsSinceEpoch;
    notifyListeners();

    /// 繰り返し実行する処理
  }

  void getSeed() {
    _seed = _time;
    List<String> chusen = [];
    for (int i = 0; i < _isSellected.length; i++) {
      if (_isSellected[i]) {
        chusen.add(_sankasha[i]);
      }
    }
    int tousen = Random(seed).nextInt(chusen.length);
    _tousensha = chusen[tousen];
    notifyListeners();
  }

  void reset() {
    _key.currentState?.reset(duration: Duration(milliseconds: 1000));
  }

  void star() {
    _controllerCenter.play();
  }

  void stopStar() {
    _controllerCenter.stop();
  }
}
