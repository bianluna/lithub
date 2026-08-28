import re

with open('lib/features/reading/reading_screen.dart', 'r') as f:
    text = f.read()

# Update initState and dispose with _percentController
old_init = """  late TextEditingController _pageController;
  double _percent = 67;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(litRepositoryProvider);
    final reading = repo.readings.first;
    _percent = reading.progressPercent.toDouble();
    _pageController = TextEditingController(text: reading.currentPage.toString());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }"""

new_init = """  late TextEditingController _pageController;
  late TextEditingController _percentController;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(litRepositoryProvider);
    final reading = repo.readings.first;
    _pageController = TextEditingController(text: reading.currentPage.toString());
    _percentController = TextEditingController(text: reading.progressPercent.toString());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _percentController.dispose();
    super.dispose();
  }"""

text = text.replace(old_init, new_init)

# Update TextField row
old_textfield = """                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _pageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Page'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Update progress',
                            icon: Icons.refresh_rounded,
                            onPressed: () {
                              final page = int.tryParse(_pageController.text) ?? reading.currentPage;
                              ref.read(litRepositoryProvider).updateReadingProgress(reading.id, page: page, percent: _percent.round());
                              setState(() {});
                            },
                          ),
                        ),"""

new_textfield = """                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pages read',
                              suffixText: ' / ${reading.totalPages}',
                              hintText: '0',
                            ),
                            onChanged: (val) {
                              final p = int.tryParse(val) ?? 0;
                              final newPercent = ((p / reading.totalPages) * 100).round().clamp(0, 100);
                              if (_percentController.text != newPercent.toString()) {
                                _percentController.text = newPercent.toString();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _percentController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Percentage',
                              suffixText: ' / 100%',
                              hintText: '0',
                            ),
                            onChanged: (val) {
                              final p = int.tryParse(val) ?? 0;
                              final newPage = ((p / 100) * reading.totalPages).round().clamp(0, reading.totalPages);
                              if (_pageController.text != newPage.toString()) {
                                _pageController.text = newPage.toString();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Update progress',
                            icon: Icons.refresh_rounded,
                            onPressed: () {
                              final page = int.tryParse(_pageController.text) ?? reading.currentPage;
                              final pcent = int.tryParse(_percentController.text) ?? reading.progressPercent;
                              ref.read(litRepositoryProvider).updateReadingProgress(reading.id, page: page, percent: pcent);
                              setState(() {});
                            },
                          ),
                        ),"""

if old_textfield in text:
    text = text.replace(old_textfield, new_textfield)
    with open('lib/features/reading/reading_screen.dart', 'w') as f:
        f.write(text)
    print("Successfully replaced text fields")
else:
    print("Could not find text fields string!")

