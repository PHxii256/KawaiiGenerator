import 'package:flutter/material.dart';

class EmojiChangeNotifier extends ChangeNotifier {
  final List<String> data = [
    ">.<",
    "(✿◠‿◠)",
    "≧◡≦",
    "(▰˘◡˘▰)",
    "@(ᵕ.ᵕ)@",
    "(σ≧▽≦)σ",
    "xP",
    "(✿◠‿◠)",
    "ʚ(｡˃ ᵕ ˂ )ɞ",
    "^.^",
    "(〃＾▽＾〃)",
    "(๑˃ᴗ˂)ﻭ",
    "ヾ(＠⌒▽⌒＠)ﾉ",
    "(づ｡◕‿‿◕｡)づ",
    "( ͡° ͜ʖ ͡°)",
    "☆*:.｡.o(≧▽≦)o.｡.:*☆"
  ];

  add({required String emoji}) {
    data.add(emoji);
    notifyListeners();
  }

  insert({required String emoji, required int index}) {
    data.insert(index, emoji);
    notifyListeners();
  }

  remove({required String emoji}) {
    data.remove(emoji);
    notifyListeners();
  }

  removeAt({required int index}) {
    data.removeAt(index);
    notifyListeners();
  }

  replace({required String oldEmoji, required String newEmoji}) {
    remove(emoji: oldEmoji);
    add(emoji: newEmoji);
  }
}
