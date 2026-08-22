import 'package:flutter/material.dart';

enum ClubPrivacy { public, private, inviteOnly }
enum ReadingStatus { notStarted, reading, finished, abandoned }
enum RewardAvailability { available, limited, soldOut }
enum ChallengeStatus { active, completed, upcoming }
enum NotificationType { meeting, book, deadline, challenge, levelUp, achievement, invite, request, event }
enum EventType { meeting, deadline, milestone, event, challenge }
enum BookSelectionMode { voting, draw }

extension ClubPrivacyX on ClubPrivacy {
  String get label => switch (this) {
        ClubPrivacy.public => 'PUBLIC',
        ClubPrivacy.private => 'PRIVATE',
        ClubPrivacy.inviteOnly => 'INVITE ONLY',
      };
}

extension ReadingStatusX on ReadingStatus {
  String get label => switch (this) {
        ReadingStatus.notStarted => 'Not Started',
        ReadingStatus.reading => 'Reading',
        ReadingStatus.finished => 'Finished',
        ReadingStatus.abandoned => 'Abandoned',
      };
}

class AppUser {
  AppUser({
    required this.email,
    required this.password,
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarSeed,
    required this.bio,
    required this.level,
    required this.xp,
    required this.nextLevelXp,
    required this.points,
    required this.booksRead,
    required this.pagesRead,
    required this.averageRating,
    required this.favoriteGenres,
    required this.clubsJoined,
    required this.isAdmin,
    required this.streakDays,
  });

  final String id;
  final String email;
  final String password;
  final String name;
  final String handle;
  final String avatarSeed;
  final String bio;
  int level;
  int xp;
  int nextLevelXp;
  int points;
  int booksRead;
  int pagesRead;
  double averageRating;
  List<String> favoriteGenres;
  int clubsJoined;
  bool isAdmin;
  int streakDays;
}

class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.synopsis,
    required this.pages,
    required this.averageRating,
    required this.genre,
    required this.coverSeed,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String author;
  final String synopsis;
  final int pages;
  final double averageRating;
  final String genre;
  final String coverSeed;
  final Color accentColor;
}

class ReadingMilestone {
  ReadingMilestone({required this.title, required this.page, this.reached = false});

  final String title;
  final int page;
  bool reached;
}

class Reading {
  Reading({
    required this.id,
    required this.bookId,
    required this.clubId,
    required this.startDate,
    required this.endDate,
    required this.currentPage,
    required this.totalPages,
    required this.progressPercent,
    required this.status,
    required this.membersReading,
    required this.membersFinished,
    required this.averageClubProgress,
    required this.milestones,
  });

  final String id;
  final String bookId;
  final String clubId;
  final DateTime startDate;
  final DateTime endDate;
  int currentPage;
  final int totalPages;
  int progressPercent;
  ReadingStatus status;
  int membersReading;
  int membersFinished;
  int averageClubProgress;
  List<ReadingMilestone> milestones;
}

class Club {
  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.privacy,
    required this.memberCount,
    required this.currentBookId,
    required this.progress,
    required this.coverSeed,
    required this.profileSeed,
    required this.themeColor,
    required this.isJoined,
  });

  final String id;
  final String name;
  final String description;
  final ClubPrivacy privacy;
  int memberCount;
  final String currentBookId;
  int progress;
  final String coverSeed;
  final String profileSeed;
  final Color themeColor;
  bool isJoined;
}

class Achievement {
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.xp,
    required this.unlocked,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final int points;
  final int xp;
  bool unlocked;
}

class RewardItem {
  RewardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.icon,
    required this.availability,
  });

  final String id;
  final String name;
  final String description;
  final int cost;
  final String icon;
  final RewardAvailability availability;
}

class Challenge {
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.goal,
    required this.deadline,
    required this.rewardPoints,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  int progress;
  final int goal;
  final DateTime deadline;
  final int rewardPoints;
  final ChallengeStatus status;
}

class EventItem {
  EventItem({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.type,
    required this.color,
  });

  final String id;
  final String clubId;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final EventType type;
  final Color color;
}

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.unread,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime dateTime;
  bool unread;
}

class RankingEntry {
  RankingEntry({
    required this.userId,
    required this.name,
    required this.avatarSeed,
    required this.level,
    required this.points,
    required this.rank,
  });

  final String userId;
  final String name;
  final String avatarSeed;
  final int level;
  final int points;
  final int rank;
}

class CommentItem {
  CommentItem({
    required this.id,
    required this.userName,
    required this.userSeed,
    required this.body,
    required this.createdAt,
    required this.spoilerUpToPage,
  });

  final String id;
  final String userName;
  final String userSeed;
  final String body;
  final DateTime createdAt;
  final int? spoilerUpToPage;
}

class BookSelectionOption {
  BookSelectionOption({
    required this.bookId,
    required this.votes,
  });

  final String bookId;
  int votes;
}

class BookSelectionSession {
  BookSelectionSession({
    required this.clubId,
    required this.mode,
    required this.options,
    this.selectedBookId,
  });

  final String clubId;
  final BookSelectionMode mode;
  final List<BookSelectionOption> options;
  String? selectedBookId;
}
