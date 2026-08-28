import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:litapp/core/constants/app_breakpoints.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/services/lit_repository.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    if (!repo.signedIn) {
      return child;
    }

    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppBreakpoints.mobile;
    final isDesktop = width >= AppBreakpoints.desktop;
    final index = isMobile ? _mobileNavIndexForLocation(location) : _desktopNavIndexForLocation(location);

    if (isMobile) {
      return Scaffold(
        extendBody: true,
        body: SafeArea(bottom: false, child: child),
        bottomNavigationBar: SafeArea(
          child: LitBottomNavigation(
            selectedIndex: index,
            onDestinationSelected: (value) => context.go(_mobileNavPath(value)),
            destinations: const [
              LitBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
              LitBottomNavItem(icon: Icons.groups_rounded, label: 'Covens'),
              LitBottomNavItem(icon: Icons.menu_book_rounded, label: 'Reading'),
              LitBottomNavItem(icon: Icons.emoji_events_rounded, label: 'Rankings'),
              LitBottomNavItem(icon: Icons.person_rounded, label: 'Profile'),
            ],
          ),
        ),
      );
    }

    final rail = NavigationRail(
      selectedIndex: index,
      onDestinationSelected: (value) => context.go(_desktopNavPath(value)),
      backgroundColor: Colors.transparent,
      labelType: isDesktop ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
      useIndicator: true,
      unselectedLabelTextStyle: const TextStyle(color: LitColors.mutedText, fontWeight: FontWeight.w700),
      selectedLabelTextStyle: const TextStyle(color: LitColors.text, fontWeight: FontWeight.w800),
      unselectedIconTheme: const IconThemeData(color: LitColors.mutedText),
      indicatorColor: LitColors.primaryBlue.withValues(alpha: .25),
      leading: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 24),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: LitColors.primaryBlue.withValues(alpha: 0.4), blurRadius: 10)],
                gradient: const LinearGradient(colors: [LitColors.primaryBlue, LitColors.brightCyan]),
              ),
              child: const Icon(Icons.auto_stories_rounded, color: LitColors.background, size: 28),
            ),
            const SizedBox(height: 14),
            Text('LitApp', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home_rounded), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.groups_rounded), label: Text('Covens')),
        NavigationRailDestination(icon: Icon(Icons.menu_book_rounded), label: Text('Reading')),
        NavigationRailDestination(icon: Icon(Icons.emoji_events_rounded), label: Text('Rankings')),
        NavigationRailDestination(icon: Icon(Icons.flag_rounded), label: Text('Quests')),
        NavigationRailDestination(icon: Icon(Icons.calendar_month_rounded), label: Text('Calendar')),
        NavigationRailDestination(icon: Icon(Icons.card_giftcard_rounded), label: Text('Rewards')),
        NavigationRailDestination(icon: Icon(Icons.person_rounded), label: Text('Profile')),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                color: LitColors.warmSurface,
                child: rail,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(child: child),
            if (isDesktop) ...[
              const SizedBox(width: 18),
              SizedBox(width: 320, child: _ContextRail(repo: repo)),
            ],
          ],
        ),
      ),
    );
  }

  int _desktopNavIndexForLocation(String location) {
    if (location.startsWith('/clubs')) return 1;
    if (location.startsWith('/reading') || location.startsWith('/books')) return 2;
    if (location.startsWith('/ranking')) return 3;
    if (location.startsWith('/challenges')) return 4;
    if (location.startsWith('/calendar')) return 5;
    if (location.startsWith('/rewards')) return 6;
    if (location.startsWith('/profile') || location.startsWith('/notifications') || location.startsWith('/settings')) return 7;
    return 0;
  }

  int _mobileNavIndexForLocation(String location) {
    if (location.startsWith('/clubs')) return 1;
    if (location.startsWith('/reading') || location.startsWith('/books')) return 2;
    if (location.startsWith('/ranking')) return 3;
    if (location.startsWith('/profile') || location.startsWith('/notifications') || location.startsWith('/settings')) return 4;
    return 0;
  }

  String _desktopNavPath(int index) => switch (index) {
        0 => '/home',
        1 => '/clubs',
        2 => '/reading',
        3 => '/ranking',
        4 => '/challenges',
        5 => '/calendar',
        6 => '/rewards',
        _ => '/profile',
      };

  String _mobileNavPath(int index) => switch (index) {
        0 => '/home',
        1 => '/clubs',
        2 => '/reading',
        3 => '/ranking',
        _ => '/profile',
      };
}

class _ContextRail extends StatelessWidget {
  const _ContextRail({required this.repo});

  final LitRepository repo;

  @override
  Widget build(BuildContext context) {
    final unread = repo.notifications.where((n) => n.unread).take(3).toList();
    final upcoming = repo.events.take(3).toList();
    final achievements = repo.achievements.where((a) => a.unlocked).take(4).toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 16),
            children: [
              AppCard(
                color: LitColors.warmSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    ...unread.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          color: LitColors.warmSurface.withValues(alpha: 0.4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(item.body, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LitColors.mutedText)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                color: LitColors.warmSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upcoming Seances', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    ...upcoming.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: BoxDecoration(color: item.color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: item.color.withValues(alpha: 0.5), blurRadius: 4)])),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 2),
                                  Text(item.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LitColors.mutedText)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                color: LitColors.warmSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grimoire Trophies', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: achievements.map((item) => 
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: LitColors.primaryBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item.icon, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: LitColors.text)),
                            ],
                          ),
                        )
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
