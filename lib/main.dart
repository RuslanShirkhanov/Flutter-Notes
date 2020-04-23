import 'package:flutter/material.dart';

import './activites/NotesList.dart';

/*
  Честно говоря, не особо знаю, что комментировать
  Если есть какие-то вопросы, то можете мне написать
  Всегда отвечу и попробую помочь
  https://vk.com/revolution_incorp
*/

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Выставляем основные цвета
        // Да, персиковый! И что?!
        accentColor: Color(0xffffcca4),
        primaryColor: Color(0xffffcca4)
      ),
      // Главная страница приложения
      home: NotesList()
    );
  }
}

void main() => runApp(Application());
