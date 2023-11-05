import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/src/state/app_state.dart';

class XCommentWidget extends StatefulWidget {
  const XCommentWidget({super.key, required this.comment});
  final XComment comment;

  @override
  State<XCommentWidget> createState() => _XCommentWidgetState();
}

class _XCommentWidgetState extends State<XCommentWidget> {
  String _getDate(String date) =>
      Jiffy.parseFromDateTime(DateTime.parse(date)).fromNow();
  AppState get _appState => context.read<AppState>();

  XComment get _comment => widget.comment;
  bool get isMyComment => _comment.commentator?.id == _appState.user?.id;

  void _showMenu(XComment comment, bool isMyComment) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Working :)'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMyComment ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyComment) _userImage,
          Flexible(child: _bodyWidget),
        ],
      ),
    );
  }

  Widget get _bodyWidget => GestureDetector(
        onLongPress: () => _showMenu(_comment, isMyComment),
        child: _comment.isImage
            ? _isImageWidget
            : Card(
                color: isMyComment ? Colors.blueAccent : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
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
                      Text(_comment.body),
                      Text(_getDate(_comment.createdAt),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              ),
      );

  Widget get _isImageWidget => Padding(
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
                        child: Text(_getDate(_comment.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 10))))
              ],
            ),
          ),
        ),
      );

  Widget get _userImage => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _comment.commentator == null
            ? const Icon(Icons.image)
            : Image.network(
                _comment.commentator?.avatar ??
                    _comment.commentator!.getAvatar(),
                fit: BoxFit.cover,
                width: 30,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.image),
                ),
              ),
      );
}
