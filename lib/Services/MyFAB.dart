import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Pages/EmojiEdit.dart';
import 'package:myapp/Services/ColorPalette.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Services/EmojiChangeNotifier.dart';

String currentAddString = '';

class MyFAB extends StatefulWidget {
  final MainRedirect mainRedirect;
  final Color color;
  final Function updateProvider;
  final EmojiChangeNotifier notifier;

  const MyFAB({
    Key? key,
    required this.mainRedirect,
    required this.color,
    required this.notifier,
    required this.updateProvider,
  }) : super(key: key);

  @override
  State<MyFAB> createState() => MyFABState();
}

class MyFABState extends State<MyFAB> {
  String? mainRedirectText;
  IconData? mainRedirecIcon;
  String inputedEmoji = "";
  String valueText = "";

  String title = "";
  String hintText = "";
  String buttonText = "";
  String snackbarMsg = "";

  @override
  void initState() {
    if (widget.mainRedirect == MainRedirect.home) {
      mainRedirectText = "Home";
      mainRedirecIcon = Icons.home;
    } else if (widget.mainRedirect == MainRedirect.edit) {
      mainRedirectText = "Edit & Remove";
      mainRedirecIcon = Icons.edit_note_rounded;
    }
    super.initState();
  }

  final TextEditingController _textFieldController = TextEditingController();

  void paste() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null) {
      setState(() {
        _textFieldController.text = data.text ?? '';
      });
    }
  }

  void initalEditText(String emoji) {
    _textFieldController.text = emoji;
  }

  void setupDialogMode(DialogMode mode) {
    if (mode == DialogMode.add) {
      title = "Add Emoji";
      hintText = "Add you emoji here! :D";
      buttonText = "Add";
      snackbarMsg = "Emoji Added :D !";
    } else if (mode == DialogMode.edit) {
      title = "Edit Emoji";
      hintText = "";
      buttonText = "Edit";
      snackbarMsg = "Emoji Edited :D !";
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, DialogMode mode) async {
    setupDialogMode(mode);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: colorPalette[MyColors.backgroundPink],
            titleTextStyle: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            title: Text(title),
            content: TextField(
              style: TextStyle(color: widget.color),
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              cursorColor: widget.color,
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: widget.color),
                  hintText: hintText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.paste_outlined,
                      color: widget.color,
                    ),
                    onPressed: () {
                      paste();
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: widget.color,
                    width: 1,
                  )),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: widget.color,
                    width: 1,
                  ))),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              OutlinedButton(
                  onPressed: () => setState(() {
                        inputedEmoji = valueText;
                        if (inputedEmoji == '') {
                          snackbarMsg = 'Please enter a valid emoji ;(';
                        } else if (widget.notifier.data
                            .contains(inputedEmoji)) {
                          snackbarMsg = 'Emoji is already added ;O';
                        } else {
                          currentAddString = inputedEmoji;
                          widget.updateProvider();
                        }
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor:
                                colorPalette[MyColors.backgroundPink],
                            content: Text(
                              snackbarMsg,
                              style: TextStyle(
                                  color: widget.color,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                  style: OutlinedButton.styleFrom(
                      fixedSize: const Size(100, 30),
                      elevation: 10,
                      backgroundColor: colorPalette[MyColors.backgroundPink],
                      foregroundColor: widget.color,
                      shape: const StadiumBorder(),
                      side: BorderSide(
                          width: 1.0, color: widget.color.withAlpha(100))),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: widget.color),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spacing: 2,
      overlayColor: Colors.black,
      overlayOpacity: 0.6,
      foregroundColor: widget.color,
      backgroundColor: colorPalette[MyColors.backgroundPink],
      mini: false,
      shape: CircleBorder(
        side: BorderSide(
          width: 2.0,
          color: colorPalette[MyColors.backgroundPink],
        ),
      ),
      animatedIcon: AnimatedIcons.menu_close,
      childPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      childrenButtonSize: const Size(40, 40),
      buttonSize: const Size(40, 40),
      animatedIconTheme: const IconThemeData(size: 30),
      childMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      children: [
        SpeedDialChild(
          shape: const CircleBorder(
            side: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          backgroundColor: colorPalette[MyColors.backgroundPink],
          child: Icon(
            Icons.add_reaction_outlined,
            color: widget.color,
          ),
          label: "Add",
          labelShadow: <BoxShadow>[const BoxShadow(color: Colors.black)],
          labelBackgroundColor: colorPalette[MyColors.backgroundPink],
          labelStyle: TextStyle(
              color: widget.color, fontSize: 14, fontWeight: FontWeight.bold),
          onTap: () {
            _textFieldController.clear();
            _displayTextInputDialog(context, DialogMode.add);
          },
        ),
        SpeedDialChild(
          shape: const CircleBorder(
            side: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          backgroundColor: colorPalette[MyColors.backgroundPink],
          child: Icon(
            mainRedirecIcon,
            color: widget.color,
          ),
          label: mainRedirectText,
          labelShadow: <BoxShadow>[const BoxShadow(color: Colors.black)],
          labelBackgroundColor: colorPalette[MyColors.backgroundPink],
          labelStyle: TextStyle(
              color: widget.color, fontSize: 14, fontWeight: FontWeight.bold),
          onTap: () {
            widget.mainRedirect == MainRedirect.home
                ? Navigator.pop(context)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const EmojiEdit()));
          },
        ),
        SpeedDialChild(
          shape: const CircleBorder(
            side: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          backgroundColor: colorPalette[MyColors.backgroundPink],
          child: Icon(
            Icons.settings_suggest,
            color: widget.color,
          ),
          label: "Settings",
          labelShadow: <BoxShadow>[const BoxShadow(color: Colors.black)],
          labelBackgroundColor: colorPalette[MyColors.backgroundPink],
          labelStyle: TextStyle(
              color: widget.color, fontSize: 14, fontWeight: FontWeight.bold),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: colorPalette[MyColors.backgroundPink],
                content: Text(
                  "Settings page not yet implemented (idk what to put there lol)",
                  style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

enum MainRedirect { home, edit }

enum DialogMode { add, edit } //remove from here