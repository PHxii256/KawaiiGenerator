import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Services/MyFAB.dart';
import 'package:myapp/Services/ColorPalette.dart';
import 'package:myapp/Services/EmojiChangeNotifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int emojiCount = 15; //last index in data
  int currentIndex = 0;
  String currentEmoji = "";
  List<String> tooltips = [
    "click me to copy to clipboard >.< !",
    "emoji copied :D"
  ];

  int tooltipState = 0;
  int nCopies = 0;

  double _bloom = 200;
  double _fontSize = 80;
  int _alpha = 256;
  bool _isPlaying = false;
  Curve _curve = Curves.elasticOut;
  int _milliseconds = 300;

  final isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<EmojiChangeNotifier>(context);
    if (currentEmoji == "") currentEmoji = db.data[0];

    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            floatingActionButton: Align(
              alignment: Alignment.bottomRight,
              child: MyFAB(
                  mainRedirect: MainRedirect.edit,
                  color: colorPalette[MyColors.pink],
                  notifier: db,
                  updateProvider: () {
                    db.add(emoji: currentAddString);
                  }),
            ),
            backgroundColor: colorPalette[MyColors.backgroundPink],
            appBar: AppBar(
              title: Text(
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorPalette[MyColors.lightPink],
                      shadows: const <Shadow>[
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 30.0,
                          color: Color.fromARGB(141, 255, 0, 140),
                        ),
                      ],
                      fontSize: 21),
                  'Kawaii generator 🌸'),
              backgroundColor: Colors.transparent,
              elevation: 25,
            ),
            body: Center(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: TextButton(
                                  style: const ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(
                                          Color.fromARGB(63, 0, 0, 0))),
                                  onPressed: () => setState(() {
                                        //animation
                                        _fontSize = 40;
                                        _bloom = 100;
                                        _alpha = 255;
                                        _curve = Curves.elasticOut;
                                        _milliseconds = 300;
                                        //copy
                                        if (!_isPlaying) copy(currentEmoji);
                                        if (tooltipState == 0) tooltipState = 1;
                                        tooltips[tooltipState];
                                        nCopies++;
                                      }),
                                  child: AnimatedDefaultTextStyle(
                                      curve: _curve,
                                      duration:
                                          Duration(milliseconds: _milliseconds),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _fontSize,
                                          color: Colors.white,
                                          shadows: <Shadow>[
                                            const Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 60,
                                              color: Color.fromARGB(
                                                  200, 254, 102, 160),
                                            ),
                                            Shadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: _bloom,
                                                color: Color.fromARGB(
                                                    _alpha, 255, 102, 160)),
                                            Shadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: _bloom,
                                                color: Color.fromARGB(
                                                    _alpha, 255, 102, 160)),
                                            Shadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: _bloom,
                                                color: Color.fromARGB(
                                                    _alpha, 255, 102, 160)),
                                          ]),
                                      onEnd: () => setState(() {
                                            _fontSize = 80;
                                            _bloom = 60;
                                            _alpha = 0;
                                            _isPlaying = false;
                                            _curve = Curves.easeInBack;
                                            _milliseconds = 200;
                                          }),
                                      child: Text(
                                        currentEmoji,
                                      )))),
                        ),
                        Text(
                          nCopies > 1
                              ? "${tooltips[tooltipState]} x$nCopies!!!"
                              : tooltips[tooltipState],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromARGB(255, 254, 225, 237)),
                        )
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 100,
                          height: 40,
                          child: OutlinedButton(
                              onPressed: () => setState(() {
                                    if (tooltipState == 1) tooltipState = 0;
                                    currentIndex >= db.data.length - 1
                                        ? currentIndex = 0
                                        : currentIndex++;
                                    currentEmoji = db.data[currentIndex];
                                    nCopies = 0;
                                  }),
                              style: OutlinedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor:
                                      colorPalette[MyColors.backgroundPink],
                                  foregroundColor: colorPalette[MyColors.pink],
                                  shape: const StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.0,
                                      color: colorPalette[MyColors.darkPink])),
                              child: Text(
                                'Generate!',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorPalette[MyColors.pink]),
                              )),
                        ),
                      )),
                ],
              ),
            )),
      ),
    );
  }
}

void copy(String emoji) {
  Clipboard.setData(ClipboardData(text: emoji));
}
