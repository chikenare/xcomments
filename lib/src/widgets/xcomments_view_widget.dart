import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/state/app_state.dart';
import 'package:xcomments/src/widgets/message_input.dart';
import 'package:xcomments/src/widgets/xcomment_widget.dart';

class XCommentsViewWidget extends StatefulWidget {
  const XCommentsViewWidget({super.key});

  @override
  State<XCommentsViewWidget> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<XCommentsViewWidget> {
  AppState get _appState => context.read<AppState>();
  late ScrollController _scrollController;

  void _listener() {
    // nextPageTrigger will have a value equivalent to 80% of the list size.
    final nextPageTrigger = 0.9 * _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels > nextPageTrigger) {
      _appState.getComments();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_listener);
    WidgetsBinding.instance.endOfFrame.then((value) {
      _appState.initComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, value, child) => value.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: value.comments.length,
                      itemBuilder: (context, index) => XCommentWidget(
                            comment: value.comments[index],
                          )),
                ),
                MessageInput(client: _appState.client),
              ],
            ),
    );
  }
}
