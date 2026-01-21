import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:basics/dice_roller.dart';

const startAlignment = Alignment.topLeft;
const endAlignmnet = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.color1, this.color2, {super.key});

  const GradientContainer.purple({super.key})
    : color1 = Colors.deepPurpleAccent,
      color2 = Colors.indigoAccent;

  final Color color1;
  final Color color2;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignmnet,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
          const Expanded(child: Center(child: DiceRoller())),
        ],
      ),
    );
  }
}
