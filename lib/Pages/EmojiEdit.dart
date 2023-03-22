import 'package:flutter/material.dart';
import 'package:myapp/Services/MyFAB.dart';
import 'package:myapp/Services/ColorPalette.dart';
import 'package:myapp/Services/EmojiChangeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class EmojiEdit extends StatefulWidget {
  const EmojiEdit({super.key});

  @override
  State<EmojiEdit> createState() => _EmojiEditState();
}

class _EmojiEditState extends State<EmojiEdit> {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<EmojiChangeNotifier>(context);
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: MyFAB(
          mainRedirect: MainRedirect.home,
          color: colorPalette[MyColors.hotPink],
          notifier: db,
          updateProvider: () {
            db.add(emoji: currentAddString);
          },
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[Color.fromARGB(255, 40, 0, 15), Color.fromARGB(255, 16, 0, 8)],
            stops: <double>[0.0, 0.5],
          )),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
                    child: SizedBox(
                      height: 150,
                      child: Text("Edit & \nRemove",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorPalette[MyColors.hotPink],
                            fontSize: 60,
                            shadows: const <Shadow>[
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 0,
                                color: Color.fromARGB(57, 255, 0, 111),
                              ),
                            ],
                          )),
                    )),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: SizedBox(
                      height: 615,
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: Color.fromARGB(255, 255, 0, 50),
                            child: MyListview()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class MyListview extends StatefulWidget {
  const MyListview({
    Key? key,
  }) : super(key: key);

  @override
  State<MyListview> createState() => _MyListviewState();
}

class _MyListviewState extends State<MyListview> {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<EmojiChangeNotifier>(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MyTile(
            emoji: db.data[index],
            myIndex: index,
          ),
        );
      },
      itemCount: db.data.length,
    );
  }
}

class MyTile extends StatefulWidget {
  final String emoji;
  final int myIndex;

  const MyTile({
    Key? key,
    required this.emoji,
    required this.myIndex,
  }) : super(key: key);

  @override
  State<MyTile> createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  int undoIndex = 0; //last removed position
  String undoEmoji = ""; //last removed contents

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<EmojiChangeNotifier>(context, listen: true);
    return ListTile(
        onTap: () {
          copy(widget.emoji);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              backgroundColor: colorPalette[MyColors.backgroundPink],
              content: Text(
                "Emoji Copied! :D",
                style: TextStyle(color: colorPalette[MyColors.hotPink], fontWeight: FontWeight.bold),
              ),
            ),
          );
        }, //copy
        minVerticalPadding: 10,
        trailing: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (0 <= widget.myIndex && widget.myIndex < db.data.length) {
                        undoIndex = widget.myIndex;
                        undoEmoji = db.data[undoIndex];
                        db.removeAt(index: widget.myIndex);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: colorPalette[MyColors.backgroundPink],
                        content: Text(
                          'Emoji Deleted :D',
                          style: TextStyle(color: colorPalette[MyColors.hotPink], fontWeight: FontWeight.bold),
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: colorPalette[MyColors.hotPink],
                          onPressed: () {
                            db.insert(emoji: undoEmoji, index: undoIndex);
                          },
                        ),
                      ),
                    );
                  }, //delete
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colorPalette[MyColors.hotPink],
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 200,
            height: 50,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.emoji,
                style: TextStyle(color: colorPalette[MyColors.hotPink], fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        tileColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            side: BorderSide(color: Color.fromARGB(255, 134, 6, 49), width: 1)));
  }
}

void copy(String emoji) {
  Clipboard.setData(ClipboardData(text: emoji));
}
