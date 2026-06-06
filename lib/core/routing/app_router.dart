import 'package:fludget/core/routing/routes.dart';
import 'package:fludget/features/workspace/ui/screens/workspace_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: Routes.workspace,
      builder: (context, state) => const WorkspaceScreen(),
    ),
  ],
);
