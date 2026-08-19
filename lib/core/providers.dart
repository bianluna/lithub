import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/services/lit_repository.dart';

final litRepositoryProvider = ChangeNotifierProvider<MockLitRepository>((ref) {
  return MockLitRepository();
});
