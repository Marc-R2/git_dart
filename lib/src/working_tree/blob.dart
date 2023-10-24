import 'package:git/src/working_tree/working_tree_entry.dart';

class BlobObject extends WorkingTreeObject {
  const BlobObject({
    required super.git,
    required super.sha,
    required super.mode,
    required super.name,
  });
}
