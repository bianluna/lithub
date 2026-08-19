import 'package:flutter/foundation.dart';
import 'package:litapp/models/lit_models.dart';
import 'package:litapp/services/mock_lit_data.dart';

abstract class LitRepository {
  AppUser get currentUser;
  List<AppUser> get users;
  List<Book> get books;
  List<Club> get clubs;
  List<Reading> get readings;
  List<Achievement> get achievements;
  List<RewardItem> get rewards;
  List<Challenge> get challenges;
  List<EventItem> get events;
  List<NotificationItem> get notifications;
  List<RankingEntry> get rankingsMonth;
  List<RankingEntry> get rankingsYear;
  List<RankingEntry> get rankingsAllTime;
  List<CommentItem> commentsForBook(String bookId);
  BookSelectionSession? selectionForClub(String clubId);

  Book? bookById(String id);
  Club? clubById(String id);
  Reading? readingByBookId(String bookId);
  Reading? readingByClubId(String clubId);

  void signIn();
  void signOut();
  void updateReadingProgress(String readingId, {required int page, required int percent});
  void completeReading(String readingId);
  void toggleClubJoin(String clubId);
  void voteForBook(String clubId, String bookId);
  void redeemReward(String rewardId);
  void markAllNotificationsRead();
  void unlockAchievement(String achievementId);
  void executeDraw(String clubId);
}

class MockLitRepository extends ChangeNotifier implements LitRepository {
  MockLitRepository();

  bool _signedIn = true;
  final AppUser _currentUser = MockLitData.currentUser;
  final List<AppUser> _users = MockLitData.users;
  final List<Book> _books = MockLitData.books;
  final List<Club> _clubs = MockLitData.clubs;
  final List<Reading> _readings = MockLitData.readings;
  final List<Achievement> _achievements = MockLitData.achievements;
  final List<RewardItem> _rewards = MockLitData.rewards;
  final List<Challenge> _challenges = MockLitData.challenges;
  final List<EventItem> _events = MockLitData.events;
  final List<NotificationItem> _notifications = MockLitData.notifications;
  final List<RankingEntry> _rankingsMonth = MockLitData.rankingsMonth;
  final List<RankingEntry> _rankingsYear = MockLitData.rankingsYear;
  final List<RankingEntry> _rankingsAllTime = MockLitData.rankingsAllTime;
  final Map<String, List<CommentItem>> _comments = MockLitData.comments;
  final List<BookSelectionSession> _selections = MockLitData.selectionSessions;

  bool get signedIn => _signedIn;

  @override
  AppUser get currentUser => _currentUser;

  @override
  List<AppUser> get users => List.unmodifiable(_users);

  @override
  List<Book> get books => List.unmodifiable(_books);

  @override
  List<Club> get clubs => List.unmodifiable(_clubs);

  @override
  List<Reading> get readings => List.unmodifiable(_readings);

  @override
  List<Achievement> get achievements => List.unmodifiable(_achievements);

  @override
  List<RewardItem> get rewards => List.unmodifiable(_rewards);

  @override
  List<Challenge> get challenges => List.unmodifiable(_challenges);

  @override
  List<EventItem> get events => List.unmodifiable(_events);

  @override
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  @override
  List<RankingEntry> get rankingsMonth => List.unmodifiable(_rankingsMonth);

  @override
  List<RankingEntry> get rankingsYear => List.unmodifiable(_rankingsYear);

  @override
  List<RankingEntry> get rankingsAllTime => List.unmodifiable(_rankingsAllTime);

  @override
  List<CommentItem> commentsForBook(String bookId) => List.unmodifiable(_comments[bookId] ?? const <CommentItem>[]);

  @override
  BookSelectionSession? selectionForClub(String clubId) {
    for (final session in _selections) {
      if (session.clubId == clubId) {
        return session;
      }
    }
    return null;
  }

  @override
  Book? bookById(String id) {
    for (final book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }

  @override
  Club? clubById(String id) {
    for (final club in _clubs) {
      if (club.id == id) return club;
    }
    return null;
  }

  @override
  Reading? readingByBookId(String bookId) {
    for (final reading in _readings) {
      if (reading.bookId == bookId) return reading;
    }
    return null;
  }

  @override
  Reading? readingByClubId(String clubId) {
    for (final reading in _readings) {
      if (reading.clubId == clubId) return reading;
    }
    return null;
  }

  @override
  void signIn() {
    _signedIn = true;
    notifyListeners();
  }

  @override
  void signOut() {
    _signedIn = false;
    notifyListeners();
  }

  @override
  void updateReadingProgress(String readingId, {required int page, required int percent}) {
    final reading = _readings.firstWhere((item) => item.id == readingId);
    final wasCompleted = reading.status == ReadingStatus.finished;
    if (wasCompleted && percent >= 100) {
      return;
    }
    reading.currentPage = page.clamp(0, reading.totalPages).toInt();
    reading.progressPercent = percent.clamp(0, 100).toInt();
    reading.status = reading.progressPercent >= 100 ? ReadingStatus.finished : ReadingStatus.reading;
    reading.milestones.where((milestone) => reading.currentPage >= milestone.page).forEach((milestone) => milestone.reached = true);
    if (reading.progressPercent >= 100) {
      if (!wasCompleted) {
        _currentUser.xp += 50;
        _currentUser.points += 100;
        _currentUser.booksRead += 1;
        unlockAchievement('a5');
      }
      _notifications.insert(
        0,
        NotificationItem(
          id: 'n${DateTime.now().millisecondsSinceEpoch}',
          type: NotificationType.achievement,
          title: 'Book completed',
          body: 'You completed ${bookById(reading.bookId)?.title ?? 'a book'}.',
          dateTime: DateTime.now(),
          unread: true,
        ),
      );
    } else {
      _currentUser.xp += 25;
      _currentUser.points += 20;
      _notifications.insert(
        0,
        NotificationItem(
          id: 'n${DateTime.now().millisecondsSinceEpoch}',
          type: NotificationType.deadline,
          title: 'Reading progress updated',
          body: 'Your progress is now $percent%.',
          dateTime: DateTime.now(),
          unread: true,
        ),
      );
    }
    notifyListeners();
  }

  @override
  void completeReading(String readingId) {
    final reading = _readings.firstWhere((item) => item.id == readingId);
    if (reading.status == ReadingStatus.finished) {
      return;
    }
    reading.progressPercent = 100;
    reading.currentPage = reading.totalPages;
    reading.status = ReadingStatus.finished;
    _currentUser.xp += 50;
    _currentUser.points += 100;
    unlockAchievement('a5');
    _notifications.insert(
      0,
      NotificationItem(
        id: 'n${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.achievement,
        title: 'Book completed',
        body: 'You completed ${bookById(reading.bookId)?.title ?? 'a book'}.',
        dateTime: DateTime.now(),
        unread: true,
      ),
    );
    notifyListeners();
  }

  @override
  void toggleClubJoin(String clubId) {
    final club = clubById(clubId);
    if (club == null) return;
    club.isJoined = !club.isJoined;
    club.memberCount += club.isJoined ? 1 : -1;
    _currentUser.clubsJoined += club.isJoined ? 1 : -1;
    notifyListeners();
  }

  @override
  void voteForBook(String clubId, String bookId) {
    final session = selectionForClub(clubId);
    if (session == null || session.mode != BookSelectionMode.voting) return;
    for (final option in session.options) {
      if (option.bookId == bookId) {
        option.votes += 1;
      }
    }
    _currentUser.points += 5;
    notifyListeners();
  }

  @override
  void redeemReward(String rewardId) {
    final reward = _rewards.firstWhere((item) => item.id == rewardId);
    if (reward.availability == RewardAvailability.soldOut || _currentUser.points < reward.cost) return;
    _currentUser.points -= reward.cost;
    _notifications.insert(
      0,
      NotificationItem(
        id: 'n${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.event,
        title: 'Reward redeemed',
        body: 'You redeemed ${reward.name}.',
        dateTime: DateTime.now(),
        unread: true,
      ),
    );
    unlockAchievement('a10');
    notifyListeners();
  }

  @override
  void markAllNotificationsRead() {
    for (final notification in _notifications) {
      notification.unread = false;
    }
    notifyListeners();
  }

  @override
  void unlockAchievement(String achievementId) {
    final achievement = _achievements.firstWhere((item) => item.id == achievementId);
    if (!achievement.unlocked) {
      achievement.unlocked = true;
      _currentUser.points += achievement.points;
      _currentUser.xp += achievement.xp;
    }
  }

  @override
  void executeDraw(String clubId) {
    final session = selectionForClub(clubId);
    if (session == null || session.mode != BookSelectionMode.draw) return;
    if (session.options.isEmpty) return;
    final selected = session.options.first.bookId;
    session.selectedBookId = selected;
    _notifications.insert(
      0,
      NotificationItem(
        id: 'n${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.book,
        title: 'Draw completed',
        body: 'The selected book is ${bookById(selected)?.title ?? 'unknown'}.',
        dateTime: DateTime.now(),
        unread: true,
      ),
    );
    notifyListeners();
  }
}
