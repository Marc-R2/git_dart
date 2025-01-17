import 'package:git/src/commit_reference.dart';

const _localBranchPrefix = 'refs/heads/';

class BranchReference extends CommitReference {
  factory BranchReference(String sha, String reference) {
    String branchName;
    if (reference == 'HEAD') {
      branchName = reference;
    } else {
      assert(reference.startsWith(_localBranchPrefix));

      branchName = reference.substring(_localBranchPrefix.length);
    }

    return BranchReference._internal(sha, reference, branchName);
  }

  BranchReference._internal(super.sha, super.reference, this.branchName);

  /// The name of the associated branch.
  ///
  /// When in the detached head state, the value may be "HEAD". In this case
  /// [isHead] is also `true`.
  final String branchName;

  /// Returns `true` if the current checked out commit is in a detached head
  /// state.
  ///
  /// See https://git-scm.com/docs/git-checkout#_detached_head
  bool get isHead => branchName == 'HEAD';

  @override
  String toString() => 'BranchReference: $branchName  $sha  ($reference)';
}
