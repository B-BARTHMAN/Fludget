import 'package:fludget/app/router.dart';
import 'package:fludget/app/theme.dart';
import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:fludget/project/project_file_service.dart';
import 'package:fludget/project/project_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FludgetApp extends StatelessWidget {
  const FludgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ProjectRepository(fileService: ProjectFileService()),
      child: BlocProvider(
        create: (context) =>
            WorkspaceCubit(repository: context.read<ProjectRepository>())
              ..newDocument(),
        child: MaterialApp.router(
          title: 'Fludget',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
