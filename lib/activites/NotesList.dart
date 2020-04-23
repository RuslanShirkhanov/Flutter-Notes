import 'package:flutter/material.dart';

import '../data/DataBase.dart';

import '../widgets/NoteWidget.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

// Класс состояния
class _NotesListState extends State<NotesList> {
  final _addingController = TextEditingController();
  final _editingController = TextEditingController();

  // Вызываем dispose у всех контроллеров
  @override
  void dispose() {
    _addingController.dispose();
    _editingController.dispose();
    super.dispose();
  }

  /*
    При изменении базы данных,
    вызываем пустой setState,
    чтобы произошла полная перерисовка
  */
  void _addNote(Note note) {
    DataBase.addNote(note);
    setState(() {});
  }
  void _editNote(Note note) {
    DataBase.editNote(note);
    setState(() {});
  }
  void _deleteNote(Note note) {
    DataBase.deleteNote(note);
    setState(() {});
  }

  void _showAddingDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: EdgeInsets.all(10),
        children: [
          TextField(
            controller: _addingController,
            autofocus: true,
            /*
              При нажатии "enter" вызываем addNote
              и очищаем текстовое поле,затем закрываем
              диалоговое окно
            */
            onSubmitted: (value) {
              _addNote(Note(title: value));
              _addingController.clear();
              Navigator.pop(context);
            }
          )
        ]
      )
    );
  }
  void _showEditingDialog(Note note) async {
    return await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: EdgeInsets.all(10),
        children: [
          TextField(
            // Блок кода, который сразу будет выполнен
            controller: () {
              // Передаем предыдущее значение для удобства
              _editingController.text = note.title;
              return _editingController;
            }(),
            autofocus: true,
            onSubmitted: (value) {
              _editNote(Note(id: note.id, title: value));
              _editingController.clear();
              Navigator.pop(context);
            }
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Максимально простой AppBar
      appBar: AppBar(
        title: Text('Notes',
          style: TextStyle(color: Color(0xff7f6652))
        ),
        centerTitle: true
      ),

      // Кнопка "добавить"
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 32, color: Color(0xff806552)),
        tooltip: 'Add new note',
        onPressed: () => _showAddingDialog()
      ),

      body: FutureBuilder(
        future: DataBase.notes(),
        builder: (_, snapshot) {
          // Если данных пока нет, то рисуем спиннер
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator()
            );
          }

          final data = snapshot.data;

          // Если список пуст, то сообщаем об этом
          if (data.length == 0) {
            return Center(
              child: Text('No notes',
                style: TextStyle(
                  color: Colors.grey, fontSize: 20
                )
              )
            );
          }

          return ListView.separated(
            // Отступы у элементов списка
            padding: const EdgeInsets.all(10),
            // Количество элементов
            itemCount: data.length,
            // Генерируем заметк по образцу NoteWidget
            itemBuilder: (_, index) {
              // Конкретная заметка Note
              final note = data[index];

              return NoteWidget(
                title: note.title,
                /*
                  Передаем анонимные функции с методами,
                  которым, в свою очередь, передаем
                  экземпляр конкретной заметки Note
                */
                edit: () {
                  _showEditingDialog(note);
                },
                delete: () {
                  _deleteNote(note);
                }
              );
            },
            // Разделительная полоса
            separatorBuilder: (_, index) => Divider()
          );
        }
      )
    );
  }
}
