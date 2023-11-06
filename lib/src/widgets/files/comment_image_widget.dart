import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/src/state/app_state.dart';

class CommentImageWidget extends StatefulWidget {
  const CommentImageWidget({super.key, required this.comment});
  final XComment comment;

  @override
  State<CommentImageWidget> createState() => _CommentImageWidgetState();
}

class _CommentImageWidgetState extends State<CommentImageWidget> {
  AppState get _appState => context.read<AppState>();
  XComment get _comment => widget.comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (_) => PhotoView(
                  imageProvider: NetworkImage(
                    _comment.getFilePath(_appState.client.urlApi),
                  ),
                )),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                _comment.getFilePath(_appState.client.urlApi),
                width: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                  bottom: 3,
                  right: 3,
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(_comment.getDate,
                          style: Theme.of(context).textTheme.bodySmall)))
            ],
          ),
        ),
      ),
    );
  }
}
