import 'package:flutter/material.dart';
import 'package:verbisense/widgets/chat/custom_app_bar.dart';
import 'package:verbisense/widgets/chat/custom_drawer.dart';
import 'package:verbisense/widgets/chat/settings_drawer.dart';
import 'package:verbisense/widgets/chat/chat_input.dart';

class ChatScreenWidget extends StatefulWidget {
  const ChatScreenWidget({
    super.key,
    required this.logout,
  });

  final void Function() logout;

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  bool _isSettingsDrawerOpen = false;

  void _toggleSettingsDrawer() {
    setState(() {
      _isSettingsDrawerOpen = !_isSettingsDrawerOpen;
    });
  }

  void _closeSettingsDrawer() {
    setState(() {
      _isSettingsDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _closeSettingsDrawer();
      },
      child: Scaffold(
        drawer: const Drawer(
          child: CustomDrawer(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(toggleSettingsDrawer: _toggleSettingsDrawer),
                Flexible(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: screenSize.width,
                      child: Column(
                        children: List.generate(
                          100,
                          (index) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Chat Screen"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const ChatInput(),
              ],
            ),
            if (_isSettingsDrawerOpen)
              Positioned(
                top: kToolbarHeight + 30,
                right: 26,
                child: SettingsDrawer(
                  logout: widget.logout,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
