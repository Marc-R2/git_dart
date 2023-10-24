import 'package:git/src/working_tree/blob.dart';
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

  Future<Map<List<String>, List<BlobObject>>> traverse() async {
    final map = <List<String>, List<BlobObject>>{};
    await _traverse(map, [], this);
    return map..removeWhere((key, value) => value.isEmpty);
  }

  Future<void> _traverse(
    Map<List<String>, List<BlobObject>> map,
    List<String> path,
    TreeObject object,
  ) async {
    final children = await object.getChildren();
    for (final child in children) {
      if (child is BlobObject) {
        (map[path] ??= []).add(child);
      } else if (child is TreeObject) {
        await _traverse(map, [...path, child.name], child);
      }
    }
  }
}
