import 'package:flutter/material.dart';
import '../extensions/color_absher.dart';

class TopNavigationBar extends StatelessWidget {
  final VoidCallback? onChatTapped;

  const TopNavigationBar({
    super.key,
    this.onChatTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side in RTL (notification bell)
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: AbsherColors.green, size: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: AbsherColors.green, size: 20),
              ),
              IconButton(
                onPressed: onChatTapped,
                icon: const Icon(Icons.chat_bubble, color: AbsherColors.green, size: 20),
              ),
            ],
          ),
          // Right side in RTL (Absher logo)
          const Text(
            'أبشر',
            style: TextStyle(
              color: AbsherColors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
