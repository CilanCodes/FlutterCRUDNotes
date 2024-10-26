import 'package:flutter/material.dart';
import 'package:flutter_crud_notes/models/note_model.dart';
import 'package:flutter_crud_notes/services/note_dao.dart';

class NoteScreen extends StatelessWidget {
  final Note? note;
  const NoteScreen({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if (note != null) {
      titleController.text = note!.title;
      descriptionController.text = note!.description;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          note == null ? 'Add a note' : 'Edit note',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                child: Text(
                  'What are you thinking about?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: titleController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusColor: Colors.black87,
                    filled: true,
                    fillColor: Color.fromARGB(255, 245, 245, 245),
                    hintText: 'Ideas',
                    hintStyle: TextStyle(color: Colors.black26),
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                border: InputBorder.none,
                focusColor: Colors.black87,
                filled: true,
                fillColor: Color.fromARGB(255, 245, 245, 245),
                hintText: '- Log my ideas here\n- Check it out',
                hintStyle: TextStyle(color: Colors.black26),
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
              keyboardType: TextInputType.multiline,
              onChanged: (str) {},
              maxLines: 5,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      final title = titleController.value.text;
                      final description = descriptionController.value.text;

                      if (title.isEmpty || description.isEmpty) {
                        return;
                      }

                      final Note model = Note(
                        title: title,
                        description: description,
                        id: note?.id,
                      );

                      final BuildContext currentContext = context;

                      if (note == null) {
                        await NoteDao().addNote(model);
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          SnackBar(
                            content: note == null
                                ? const Text("Note Created Succesfully")
                                : const Text("Note Updated Succesfully"),
                            backgroundColor:
                                const Color.fromARGB(255, 35, 35, 35),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 2000),
                          ),
                        );
                      } else {
                        await NoteDao().updateNote(model);
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          SnackBar(
                            content: note == null
                                ? const Text("Note Created Succesfully")
                                : const Text("Note Updated Succesfully"),
                            backgroundColor:
                                const Color.fromARGB(255, 35, 35, 35),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 2000),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                      ),
                    ),
                    child: Text(
                      note == null ? 'Save' : 'Edit',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
