import 'package:git/git.dart';
import 'package:git/src/working_tree/tree.dart';
import 'package:git/src/working_tree/working_tree_entry.dart';

class CommitObject extends GitObject {
  const CommitObject({
    required super.git,
    required super.sha,
    required this.author,
    required this.committer,
    required this.content,
    required this.message,
    List<String>? parentShas,
  }) : _parentShas = parentShas ?? const [];

  final String author;
  final String committer;
  final String content;
  final String message;
  final List<String> _parentShas;

  List<String> get parentShas => List.unmodifiable(_parentShas);

  TreeObject get tree =>
      TreeObject(git: git, sha: sha, mode: TreeEntryMode.none, name: 'root');
}
