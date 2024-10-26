import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_crud_notes/services/note_dao.dart';
import 'package:flutter_crud_notes/widges/note_widget.dart';

import '../models/note_model.dart';
import 'note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Flutter CRUD Notes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          backgroundColor: Colors.black,
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NoteScreen()));
            setState(() {});
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 12),
          color: Colors.white54,
          child: FutureBuilder<List<Note>?>(
            future: NoteDao().getAllNotes(),
            builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemBuilder: (context, index) => NoteWidget(
                      note: snapshot.data![index],
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteScreen(
                                      note: snapshot.data![index],
                                    )));
                        setState(() {});
                      },
                      onLongPress: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                backgroundColor: Colors.white,
                                title: const Text(
                                    'Are you sure you want to delete this note?'),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Platform.isIOS
                                          ? Colors.transparent
                                          : Colors.red,
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      await NoteDao()
                                          .deleteNote(snapshot.data![index]);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Note Deleted Succesfully"),
                                          backgroundColor:
                                              Color.fromARGB(255, 35, 35, 35),
                                          behavior: SnackBarBehavior.floating,
                                          duration:
                                              Duration(milliseconds: 2000),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Platform.isIOS
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Platform.isIOS
                                          ? Colors.transparent
                                          : Colors.white,
                                      elevation: 0,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    itemCount: snapshot.data!.length,
                  );
                }
                return const Center(
                  child: Text(
                    'No notes yet',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ));
  }
}
