import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/models/commentator.dart';
import 'package:xcomments/src/models/reply_data.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/src/state/app_state.dart';
import 'package:xcomments/src/widgets/files/comment_image_widget.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget(
      {super.key, required this.xComment, this.isReply, this.commentator});
  final XComment xComment;
  final bool? isReply;
  final Commentator? commentator;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  AppState get _appState => context.read<AppState>();
  XComment get _comment => widget.xComment;
  bool get isMyComment => _comment.commentator?.id == _appState.user?.id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _appState.reply = ReplyData()
          ..name = _comment.commentator!.name
          ..id = _comment.id;
      },
      child: _comment.isImage
          ? CommentImageWidget(comment: _comment)
          : Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: isMyComment
                      ? Colors.blueAccent
                      : Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: isMyComment
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isMyComment) ...[
                    Text(_comment.commentator?.name ?? 'Usuario eliminado',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                  ],
                  if (widget.isReply ?? false) _replyCommentatorWidget,
                  Text(_comment.body),
                ],
              ),
            ),
    );
  }

  Widget get _replyCommentatorWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(.3),
            borderRadius: BorderRadius.circular(3)),
        child: Text(
          widget.commentator?.name ?? 'Deleted',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
}
