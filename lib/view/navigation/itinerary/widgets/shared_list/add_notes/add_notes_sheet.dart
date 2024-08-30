import 'package:flutter/material.dart';

import '../../../../../../utils/common/config.dart';
import '../../../../../../utils/common/extensions.dart';

class AddNotesSheet extends StatelessWidget {
  const AddNotesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
              ),
              Text(
                'Add Note',
                style: TextStyle(
                  color: const Color(0xFF1A1B28),
                  fontSize: 20,
                  fontVariations: FVariations.w700,
                ),
              ),
              const SizedBox.square(dimension: 40)
            ],
          ),
        ),
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: TextFormField(
            maxLines: 4,
            decoration: const InputDecoration(hintText: "Add your note"),
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemBuilder: (context, index) {
              final user = Config.users[index];
              return Column(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: SizedBox.square(
                          dimension: 40,
                          child: Image.asset(user.image),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          user.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontVariations: FVariations.w700,
                          ),
                        ),
                      ),
                      const Text(
                        '2 days ago',
                        style: TextStyle(
                          color: Color(0xFF505050),
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
                    style: TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 12,
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 24.0);
            },
            itemCount: Config.users.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Add"),
          ),
        ),
      ],
    );
  }
}
