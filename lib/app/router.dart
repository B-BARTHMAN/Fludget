import 'package:fludget/app/routes.dart';
import 'package:fludget/editor/workspace/workspace_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: Routes.workspace,
      builder: (context, state) => const WorkspaceScreen(),
    ),
  ],
);
