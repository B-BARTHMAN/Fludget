import 'package:fludget/app/app_exit_guard.dart';
import 'package:fludget/app/theme.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/registry.dart';
import 'package:fludget/features/project/logic/project_file_service.dart';
import 'package:fludget/features/project/logic/project_repository.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/settings/state/settings_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/ui/screens/workspace_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Composition root. Builds the dependency chain once and provides it to the
/// tree: disk → repository → project. A single [WidgetSource] feeds three
/// consumers — the repository (normalizing on load), the workspace (seeding new
/// editors), and the tree/canvas (resolved from context).
class FludgetApp extends StatelessWidget {
  const FludgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    const source = RegistryWidgetSource();
    final repository = ProjectRepository(
      files: ProjectFileService(),
      source: source,
    );
    return RepositoryProvider<WidgetSource>.value(
      value: source,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SettingsCubit()),
          BlocProvider(create: (_) => ProjectCubit(repository)..bootstrap()),
          BlocProvider(
            lazy: false,
            create: (context) =>
                WorkspaceCubit(context.read<ProjectCubit>(), source),
          ),
        ],
        child: MaterialApp(
          title: 'Fludget',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const AppExitGuard(child: WorkspaceScreen(source: source)),
        ),
      ),
    );
  }
}
