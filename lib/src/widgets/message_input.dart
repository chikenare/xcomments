import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/api/xcomments_api.dart';
import 'package:xcomments/src/models/xcomments_client.dart';
import 'package:xcomments/src/state/app_state.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key, required this.client});
  final XCommentsClient client;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  late TextEditingController _controller;
  bool _sending = false;
  AppState get _appState => context.read<AppState>();

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    _sending = true;
    setState(() {});

    try {
      await _appState.storeComment(_controller.text);
      _controller.clear();
      setState(() {
        _sending = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating, content: Text(e.toString())));
    }
  }

  void _uploadFile() async {
    try {
      final comment = await XCommentsApi(widget.client).uploadFile(
          _appState.reply?.id ?? widget.client.channel,
          isReply: _appState.reply != null);

      if (comment != null) _appState.addComment(comment);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating, content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Consumer<AppState>(builder: (context, value, child) {
            return value.reply == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      Text('Reply to ${value.reply?.name} · '),
                      GestureDetector(
                        onTap: () => value.reply = null,
                        child: const Text('Cancel'),
                      )
                    ],
                  );
          }),
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Comment',
                prefixIcon: IconButton(
                  onPressed: _uploadFile,
                  icon: const Icon(Icons.add_circle_outline),
                ),
                suffixIcon: IconButton(
                  icon: _sending
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : const Icon(Icons.send),
                  onPressed: _sendMessage,
                )),
          ),
        ],
      ),
    );
  }
}
