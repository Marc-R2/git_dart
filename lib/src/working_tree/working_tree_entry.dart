import 'package:git/git.dart';

abstract class GitObject {
  const GitObject({
    required this.sha,
    required this.git,
  });

  final String sha;

  final GitDir git;
}

abstract class WorkingTreeObject extends GitObject {
  const WorkingTreeObject({
    required super.git,
    required super.sha,
    required this.mode,
    required this.name,
  });

  final TreeEntryMode mode;

  final String name;
}
