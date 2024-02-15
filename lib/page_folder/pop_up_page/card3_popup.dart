import 'package:flutter/material.dart';

class Card3PopUp extends StatelessWidget {
  const Card3PopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 357,
      height: 613,
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Expanded(child: Text('')),
                SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/cancel.png')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Image.asset('assets/card3popup.png'),
        ],
      ),
    );
  }
}
