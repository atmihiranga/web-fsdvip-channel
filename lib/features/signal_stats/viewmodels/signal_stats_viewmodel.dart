import 'package:project_3_forex_signals_daily/features/signal_stats/models/signal_stats_model.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/repositories/signal_stats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'signal_stats_viewmodel.g.dart';

@riverpod
class SignalStatsViewmodel extends _$SignalStatsViewmodel {
  late SignalStatsRepository _signalStatsRepository;
  @override
  AsyncValue<SignalStatsModel> build() {
    _signalStatsRepository = ref.watch(signalStatsRepositoryProvider);
    _fetchSignalStats();
    return AsyncValue.loading();
  }

  Future<void> _fetchSignalStats() async {
    final docSnap = await _signalStatsRepository.fetchSignalStatsDoc();
    final signalStats = SignalStatsModel.fromMap(docSnap.data()!);
    state = AsyncValue.data(signalStats);
  }

  void updateStatsDoc() {}
}
