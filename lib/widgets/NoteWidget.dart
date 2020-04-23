import 'package:flutter/material.dart';

class NoteWidget extends StatelessWidget {
  final String title;
  // Тип функции, возвращающей void
  final void Function() edit;
  final void Function() delete;

  /*
    Из-за нисходящего потока данных принимаем
    методы удаления и редактирования заметки
  */
  /*
    @required говорит о том,
    что параметр обязателен,
    даже, если является именованным
  */
  const NoteWidget({
    @required this.title,
    @required this.edit,
    @required this.delete
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Текст тайла
      title: Center(
        child: Text(title)
      ),
      // Левая часть тайла
      leading: Tooltip(
        message: 'Edit note',
        child: FlatButton(
          child: Icon(Icons.edit, color: Color(0xff806552)),
          onPressed: edit
        )
      ),
      // Правая часть тайла
      trailing: Tooltip(
        message: 'Delete note',
        child: FlatButton(
          child: Icon(Icons.delete, color: Color(0xff806552)),
          onPressed: delete
        )
      )
    );
  }
}
