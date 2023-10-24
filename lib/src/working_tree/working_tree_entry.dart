import 'package:git/git.dart';

abstract class GitObject {
  const GitObject({required this.git});

  final GitDir git;
}

abstract class WorkingTreeObject extends GitObject {
  const WorkingTreeObject({
    required super.git,
    required this.sha,
    required this.mode,
    required this.name,
  });

  final String sha;

  final TreeEntryMode mode;

  final String name;
}
