import 'dart:convert';

import 'package:git/src/bot.dart';
import 'package:git/src/git_dir.dart';
import 'package:git/src/util.dart';
import 'package:git/src/working_tree/blob.dart';
import 'package:git/src/working_tree/tree.dart';
import 'package:git/src/working_tree/working_tree_entry.dart';

const _lsTreeLine =
// ignore: prefer_interpolation_to_compose_strings
    '^([0-9]{6}) (blob|tree) (' + shaRegexPattern + ')\t(\\S.*\\S)\$';

enum TreeEntryType {
  blob('blob'),
  tree('tree'),
  commit('commit');

  const TreeEntryType(this.key);

  final String key;
}

enum TreeEntryMode {
  none('0'),
  directory('040000'),
  regular_non_executable_file('100644'),
  regular_non_executable_group_writeable_file('100664'),
  regular_executable_file('100755'),
  symbolic_link('120000'),
  gitlink('160000');

  const TreeEntryMode(this.key);

  final String key;
}

class TreeEntry {
  TreeEntry(String mode, String type, this.sha, this.name)
      // Try to get the mode and type enum values from the strings.
      // Throws a StateError("No element") if no match is found.
      : mode = TreeEntryMode.values.firstWhere((m) => m.key == mode),
        type = TreeEntryType.values.firstWhere((t) => t.key == type) {
    // TODO: how can we be more careful here? no paths? hmm...
    requireArgumentNotNullOrEmpty(name, 'name');
  }

  factory TreeEntry.fromLsTree(String value) {
    // TODO: should catch and re-throw a descriptive error
    final match = _lsTreeRegEx.allMatches(value).single;

    return TreeEntry(match[1]!, match[2]!, match[3]!, match[4]!);
  }

  static final _lsTreeRegEx = RegExp(_lsTreeLine);

  /// All numbers.
  ///
  /// See this this [post on stackoverflow](http://stackoverflow.com/questions/737673/how-to-read-the-mode-field-of-git-ls-trees-output)
  final TreeEntryMode mode;

  final TreeEntryType type;

  final String sha;
  final String name;

  @override
  String toString() => '$mode $type $sha\t$name';

  static List<TreeEntry> fromLsTreeOutput(String output) {
    final lines = const LineSplitter().convert(output);

    return lines.sublist(0, lines.length).map(TreeEntry.fromLsTree).toList();
  }

  WorkingTreeObject asWorkingTreeEntry(GitDir git) {
    switch (type) {
      case TreeEntryType.tree:
        return TreeObject(
          mode: mode,
          sha: sha,
          name: name,
          git: git,
        );
      case TreeEntryType.blob:
        return BlobObject(
          mode: mode,
          sha: sha,
          name: name,
          git: git,
        );
      case TreeEntryType.commit:
        throw StateError('Commit in not a valid option here');
    }
  }
}
