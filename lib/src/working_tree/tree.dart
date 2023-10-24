import 'package:git/src/working_tree/working_tree_entry.dart';

class TreeObject extends WorkingTreeObject {
  const TreeObject({
    required super.git,
    required super.sha,
    required super.mode,
    required super.name,
  });

  Future<List<WorkingTreeObject>> getChildren() async {
    final tree = await git.lsTree(sha);
    return tree.map((e) => e.asWorkingTreeEntry(git)).toList();
  }
}
