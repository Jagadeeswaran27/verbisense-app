import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/themes/colors.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 15.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: null,
                  cursorHeight: 20,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: Strings.askAQuestion,
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: ThemeColors.chatInput,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: screenWidth * 0.15,
              child: ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: ThemeColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
