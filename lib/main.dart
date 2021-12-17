import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:scratcher/widgets.dart';

import 'initial_view_model.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(initialViewModelProvider);
    // final key = GlobalKey<ScratcherState>();
    useEffect(() {
      // 初期表示時にデータのロードを実行
      viewModel.loadData();
      // 関数(Function())を返却しておくと、Widgetのライフサイクルに合わせてWidgetのdisposeのタイミングで関数を実行してくれます（不要であればnullでOK）
      return null;
    }, const []);
    return Scaffold(
      appBar: AppBar(
        title: Text("みんなの抽選機くん１号機"),
        actions: [
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              viewModel.stopStar();
              //viewModel.reset();
              //viewmodekey.currentState?.reset(duration: Duration(milliseconds: 1000));
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              viewModel.star();
              //viewModel.reset();
              //viewmodekey.currentState?.reset(duration: Duration(milliseconds: 1000));
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              viewModel.reset();
              //viewmodekey.currentState?.reset(duration: Duration(milliseconds: 1000));
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: viewModel.controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              //createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
          Column(
            children: [
              Text("現在時刻"),
              Gap(4),
              Text(viewModel.time.toString()),
              Gap(4),
              RaisedButton(
                  child: Text("シード値を取得する"),
                  onPressed: () {
                    viewModel.getSeed();
                  }),
              Gap(4),
              Text("シード値"),
              Gap(4),
              Text(viewModel.seed.toString()),
              Gap(4),
              Text("当選者は…"),
              Gap(4),
              Scratcher(
                key: viewModel.key,
                //enabled: true,
                brushSize: 30,
                threshold: 10,
                color: Colors.grey,
                onChange: (value) => print("Scratch progress: $value%"),
                onThreshold: () => print("Threshold reached, you won!"),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 500,
                  child: Text(viewModel.tousensha),
                ),
              ),
              Text("さんです！おめでとうございます！"),
              Gap(4),
              Text("参加者"),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      child: NameCard(
                        index: index,
                        name: viewModel.sankasha[index],
                        viewModel: viewModel,
                      ),
                    );
                  },
                  itemCount: viewModel.sankasha.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 300,
                      child: TextField(
                        controller: viewModel.controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      viewModel.add();
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  NameCard({
    Key? key,
    required int index,
    required String name,
    required InitialViewModel viewModel,
  }) {
    this.index = index;
    this.name = name;
    this.viewModel = viewModel;
  }
  late int index;
  late String name;
  late InitialViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green, // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
          title: Text(name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: viewModel.isSellected[index],
                onChanged: (bool? value) {
                  viewModel.check(index, value!);
                },
              ),
              IconButton(
                onPressed: () {
                  viewModel.delete(index);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
