import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xcomments/src/models/xcomments_client.dart';
import 'package:xcomments/src/state/app_state.dart';
import 'package:xcomments/src/widgets/xcomments_view_widget.dart';

class XComments extends StatelessWidget {
  const XComments({super.key, required this.client});
  final XCommentsClient client;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(client: client),
      child: const XCommentsViewWidget(),
    );
  }
}
