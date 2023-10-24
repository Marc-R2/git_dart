import 'package:git/src/working_tree/working_tree_entry.dart';

class BlobObject extends WorkingTreeObject {
  const BlobObject({
    required super.git,
    required super.sha,
    required super.mode,
    required super.name,
  });

  @override
  String toString() {
    return 'BlobObject{name: $name, mode: $mode, sha: ${sha.substring(0, 6)}}';
  }
}
