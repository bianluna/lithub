import re

with open('lib/features/reading/reading_screen.dart', 'r') as f:
    text = f.read()

# patch initState
old_init = """  void initState() {
    super.initState();
    final repo = ref.read(litRepositoryProvider);
    final reading = repo.readings.first;
    _pageController =
        TextEditingController(text: reading.currentPage.toString());
    _percentController =
        TextEditingController(text: reading.progressPercent.toString());
  }"""
new_init = """  void initState() {
    super.initState();
    final repo = ref.read(litRepositoryProvider);
    final reading = repo.readings.isNotEmpty ? repo.readings.first : null;
    _pageController =
        TextEditingController(text: reading?.currentPage.toString() ?? '0');
    _percentController =
        TextEditingController(text: reading?.progressPercent.toString() ?? '0');
  }"""

text = text.replace(old_init, new_init)

# patch build
old_build = """  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    final reading = repo.readings.first;
    final book = repo.bookById(reading.bookId)!;
    final club = repo.clubById(reading.clubId)!;"""
new_build = """  Widget build(BuildContext context) {
    final repo = ref.watch(litRepositoryProvider);
    if (repo.readings.isEmpty) return const Scaffold(body: Center(child: Text("No reading active")));
    final reading = repo.readings.first;
    final book = repo.bookById(reading.bookId)!;
    final club = repo.clubById(reading.clubId)!;"""

text = text.replace(old_build, new_build)

with open('lib/features/reading/reading_screen.dart', 'w') as f:
    f.write(text)

