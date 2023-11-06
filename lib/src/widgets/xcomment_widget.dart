import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/src/state/app_state.dart';
import 'package:xcomments/src/widgets/body_widget.dart';
import 'package:xcomments/src/widgets/xcomment_user_image.dart';

class XCommentWidget extends StatefulWidget {
  const XCommentWidget({super.key, required this.comment});
  final XComment comment;

  @override
  State<XCommentWidget> createState() => _XCommentWidgetState();
}

class _XCommentWidgetState extends State<XCommentWidget> {
  AppState get _appState => context.read<AppState>();

  XComment get _comment => widget.comment;
  bool get isMyComment => _comment.commentator?.id == _appState.user?.id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (!isMyComment) XCommentUserImage(comment: _comment),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: isMyComment
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    BodyWidget(xComment: _comment),
                    Row(
                      mainAxisAlignment: isMyComment
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(_comment.getDate,
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 3),
                        if (_comment.repliesCount > 0) _repliesCountWidget,
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        _repliesWidget
      ],
    );
  }

  Widget get _repliesWidget => Column(
      children: _comment.replies
          .map((e) => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: isMyComment
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!isMyComment) XCommentUserImage(comment: e),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyWidget(
                          xComment: e,
                          isReply: true,
                          commentator: _comment.commentator,
                        ),
                        Row(
                          children: [
                            Text(e.getDate,
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(width: 3),
                            if (e.repliesCount > 0) _repliesCountWidget,
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
          .toList());
  Widget get _repliesCountWidget => GestureDetector(
        onTap: () => _appState.geReplies(_comment.id),
        child: Text('replies ${_comment.repliesCount}',
            style: Theme.of(context).textTheme.bodySmall),
      );
}
