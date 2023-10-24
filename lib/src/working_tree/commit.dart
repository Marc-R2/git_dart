import 'package:git/git.dart';
import 'package:git/src/working_tree/tree.dart';
import 'package:git/src/working_tree/working_tree_entry.dart';

class CommitObject extends GitObject {
  const CommitObject({
    required super.git,
    required this.treeSha,
    required this.author,
    required this.committer,
    required this.content,
    required this.message,
    this.commitSha,
    List<String>? parentShas,
  }) : _parentShas = parentShas ?? const [];

  final String? commitSha;
  final String treeSha;
  final String author;
  final String committer;
  final String content;
  final String message;
  final List<String> _parentShas;

  List<String> get parentShas => List.unmodifiable(_parentShas);

  TreeObject get tree => TreeObject(
        git: git,
        sha: treeSha,
        mode: TreeEntryMode.none,
        name: 'root',
      );

  @override
  String toString() {
    return 'CommitObject{commitSha: $commitSha, treeSha: $treeSha, author: $author, committer: $committer, content: $content, message: $message, parentShas: $_parentShas}';
  }
}
