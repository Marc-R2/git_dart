import 'package:git/git.dart';
import 'package:git/src/bot.dart';
import 'package:git/src/util.dart';
import 'package:git/src/working_tree/commit.dart';

/// Represents a Git commit object.
class Commit {
  static CommitObject parse(String content, GitDir git) {
    final stringLineReader = StringLineReader(content);
    return _parse(stringLineReader, false, git);
  }

  static List<CommitObject> parseRawRevList(String content, GitDir git) {
    final slr = StringLineReader(content);

    final commits = <CommitObject>[];

    while (slr.position != null && slr.position! < content.length) {
      commits.add(_parse(slr, true, git));
    }

    return commits;
  }

  static void checkHashes(CommitObject commit) {
    final shas = [commit.treeSha, ...commit.parentShas];
    if (shas.any((sha) => !isValidSha(sha))) {
      throw StateError('Invalid SHA found in commit: $commit');
    }
  }

  static CommitObject _parse(
    StringLineReader slr,
    bool isRevParse,
    GitDir git,
  ) {
    assert(slr.position != null);

    final headers = <String, List<String>>{};

    final startSpot = slr.position!;
    var lastLine = slr.readNextLine();

    while (lastLine != null && lastLine.isNotEmpty) {
      final allHeaderMatches = headerRegExp.allMatches(lastLine);
      if (allHeaderMatches.isNotEmpty) {
        final match = allHeaderMatches.single;
        assert(match.groupCount == 2);
        final header = match.group(1)!;
        final value = match.group(2)!;

        headers.putIfAbsent(header, () => <String>[]).add(value);
      }

      lastLine = slr.readNextLine();
    }

    assert(lastLine!.isEmpty);

    String message;

    if (isRevParse) {
      final msgLines = <String>[];
      lastLine = slr.readNextLine();

      const revParseMessagePrefix = '    ';
      while (lastLine != null && lastLine.startsWith(revParseMessagePrefix)) {
        msgLines.add(lastLine.substring(revParseMessagePrefix.length));
        lastLine = slr.readNextLine();
      }

      message = msgLines.join('\n');
    } else {
      message = slr.readToEnd()!;
      assert(message.endsWith('\n'));
      final originalMessageLength = message.length;
      message = message.trim();
      // message should be trimmed by git, so the only diff after trim
      // should be 1 character - the removed new line
      assert(message.length + 1 == originalMessageLength);
    }

    final treeSha = headers['tree']!.single;
    final author = headers['author']!.single;
    final committer = headers['committer']!.single;
    final commitSha = headers['commit']?.single;

    final parents = headers['parent'] ?? [];

    final endSpot = slr.position;

    final content = slr.source.substring(startSpot, endSpot);

    final commit = CommitObject(
      git: git,
      commitSha: commitSha,
      treeSha: treeSha,
      author: author,
      committer: committer,
      content: content,
      message: message,
      parentShas: parents,
    );
    checkHashes(commit);
    return commit;
  }
}
