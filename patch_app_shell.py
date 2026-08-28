import re

with open('lib/core/widgets/app_shell.dart', 'r') as f:
    content = f.read()

old_scaffold = """    if (isMobile) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => context.go(_mobileNavPath(value)),
          indicatorColor: LitColors.primaryBlue.withOpacity(.18),
          backgroundColor: LitColors.background,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.groups_rounded), label: 'Covens'),
            NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Reading'),
            NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'Rankings'),
            NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      );
    }"""

new_scaffold = """    if (isMobile) {
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
    }"""

if old_scaffold in content:
    content = content.replace(old_scaffold, new_scaffold)
    with open('lib/core/widgets/app_shell.dart', 'w') as f:
        f.write(content)
    print("Successfully patched app_shell.dart")
else:
    print("Could not find old scaffold pattern in app_shell.dart")

