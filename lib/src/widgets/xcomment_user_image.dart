import 'package:flutter/material.dart';
import 'package:xcomments/src/models/xcomment.dart';

class XCommentUserImage extends StatefulWidget {
  const XCommentUserImage({super.key, required this.comment});
  final XComment comment;

  @override
  State<XCommentUserImage> createState() => _XCommentUserImageState();
}

class _XCommentUserImageState extends State<XCommentUserImage> {
  XComment get _comment => widget.comment;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: _comment.commentator == null
          ? const Icon(Icons.image)
          : Image.network(
              _comment.commentator?.avatar ?? _comment.commentator!.getAvatar(),
              fit: BoxFit.cover,
              width: 30,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.image),
              ),
            ),
    );
  }
}
