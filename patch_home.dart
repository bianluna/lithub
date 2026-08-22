import 'dart:io';

void main() {
  final file = File('lib/features/home/home_screen.dart');
  var content = file.readAsStringSync();
  
  // Remove single reading assignments
  content = content.replaceAll(
    'final currentReading = repo.readings.first;\n    final currentBook = repo.bookById(currentReading.bookId)!;\n    final currentClub = repo.clubById(currentReading.clubId)!;',
    'final activeReadings = repo.readings.where((r) {\n      final c = repo.clubById(r.clubId);\n      return c != null && c.isJoined && r.status == ReadingStatus.reading;\n    }).toList();'
  );

  final injectionPointStr = "              children: [\\n                SizedBox\\(width: wide \\? constraints.maxWidth \\* .58 : constraints.maxWidth, child: _CurrentReadingCard\\(repo: repo, book: currentBook, reading: currentReading, club: currentClub\\)\\),\\n";

  // Note: we can use a simpler replacement text.
  content = content.replaceFirst(
    '''
              children: [
                SizedBox(width: wide ? constraints.maxWidth * .58 : constraints.maxWidth, child: _CurrentReadingCard(repo: repo, book: currentBook, reading: currentReading, club: currentClub)),
''',
    '''
              children: [
                ...activeReadings.map((reading) {
                   final book = repo.bookById(reading.bookId)!;
                   final club = repo.clubById(reading.clubId)!;
                   return SizedBox(width: wide ? constraints.maxWidth * .58 : constraints.maxWidth, child: _CurrentReadingCard(repo: repo, book: book, reading: reading, club: club));
                }),
'''
  );

  file.writeAsStringSync(content);
}
