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
        body: SafeArea(child: child),
        floatingActionButton: FloatingActionButton(
          backgroundColor: LitColors.primaryPurple,
          foregroundColor: Colors.white,
          onPressed: () => context.go('/reading'),
          child: const Icon(Icons.auto_stories_rounded),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => context.go(_navPath(value)),
          indicatorColor: LitColors.primaryPurple.withOpacity(.18),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.groups_rounded), label: 'Clubs'),
            NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Reading'),
            NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'Rankings'),
            NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      );
    }

    final rail = NavigationRail(
      selectedIndex: index,
      onDestinationSelected: (value) => context.go(_navPath(value)),
      backgroundColor: Colors.transparent,
      labelType: isDesktop ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
      useIndicator: true,
      indicatorColor: LitColors.primaryPurple.withOpacity(.18),
      leading: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 24),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(colors: [LitColors.primaryPurple, LitColors.softPeriwinkle]),
              ),
              child: const Icon(Icons.auto_stories_rounded, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text('LitApp', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home_rounded), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.groups_rounded), label: Text('Clubs')),
        NavigationRailDestination(icon: Icon(Icons.menu_book_rounded), label: Text('Reading')),
        NavigationRailDestination(icon: Icon(Icons.emoji_events_rounded), label: Text('Rankings')),
        NavigationRailDestination(icon: Icon(Icons.flag_rounded), label: Text('Challenges')),
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
                color: const Color(0xF5FFFFFF),
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
    return 4;
  }

  String _navPath(int index) => switch (index) {
        0 => '/home',
        1 => '/clubs',
        2 => '/reading',
        3 => '/ranking',
        4 => '/challenges',
        5 => '/calendar',
        6 => '/rewards',
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
                color: LitColors.warmSurface.withOpacity(.72),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    ...unread.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          color: Colors.white.withOpacity(.7),
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
                color: const Color(0x66FFD8BE),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upcoming events', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    ...upcoming.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
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
                color: const Color(0x66B8B8FF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Achievements', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: achievements.map((item) => ColorPill(label: '${item.icon} ${item.title}', color: LitColors.primaryPurple)).toList(),
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
