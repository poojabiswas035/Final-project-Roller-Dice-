import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {
  final randomizer = Random();
  var currentDiceRoll = 2;

  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void rollDice() {
    setState(() {
      currentDiceRoll = randomizer.nextInt(6) + 1;
    });
  }

  // ================= CRUD =================

  Future<void> fetchNotes() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    setState(() {
      notes = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addNote(String content) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase.from('notes').insert({
      'content': content,
      'user_id': userId,
    });

    fetchNotes();
  }

  Future<void> deleteNote(String id) async {
    await supabase.from('notes').delete().eq('id', id);
    fetchNotes();
  }

  // ================= UI =================

  void showAddNoteDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter note'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              addNote(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/D$currentDiceRoll.png', width: 200),
          const SizedBox(height: 20),
          TextButton(
            onPressed: rollDice,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 28),
            ),
            child: const Text('Roll Dice'),
          ),
          const SizedBox(height: 20),

          // ================= NOTES LIST =================
          const Text(
            'Your Notes',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note['content']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteNote(note['id']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
