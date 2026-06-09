import 'package:fludget/app/routes.dart';
import 'package:fludget/editor/workspace/workspace_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: Routes.workspace,
      builder: (context, state) => const WorkspaceScreen(),
    ),
  ],
);
