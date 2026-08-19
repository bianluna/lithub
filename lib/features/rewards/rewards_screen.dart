import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/theme/lit_theme.dart';
import 'package:litapp/core/widgets/lit_widgets.dart';
import 'package:litapp/models/lit_models.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Row(
          children: [
            Expanded(child: Text('Rewards', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900))),
            AppCard(
              color: LitColors.primaryPurple.withOpacity(.12),
              child: Text('${repo.currentUser.points} points', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Redeem points for non-monetary rewards.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: LitColors.mutedText)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          children: repo.rewards.map((reward) => SizedBox(width: 360, child: _RewardCard(rewardId: reward.id))).toList(),
        ),
      ],
    );
  }
}

class _RewardCard extends ConsumerWidget {
  const _RewardCard({required this.rewardId});
  final String rewardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(litRepositoryProvider);
    final reward = repo.rewards.firstWhere((item) => item.id == rewardId);
    final enough = repo.currentUser.points >= reward.cost;
    final available = reward.availability != RewardAvailability.soldOut;
    return AppCard(
      color: reward.availability == RewardAvailability.soldOut ? LitColors.background : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: LitColors.softPeriwinkle.withOpacity(.25), borderRadius: BorderRadius.circular(18)),
                child: Center(child: Text(reward.icon, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(reward.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
            ],
          ),
          const SizedBox(height: 12),
          Text(reward.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
          const SizedBox(height: 14),
          Row(
            children: [
              ColorPill(label: '${reward.cost} points', color: LitColors.primaryPurple),
              const SizedBox(width: 10),
              ColorPill(label: reward.availability.name.toUpperCase(), color: LitColors.softPeach),
            ],
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: available && enough ? 'Redeem reward' : available ? 'Need more points' : 'Unavailable',
            icon: Icons.card_giftcard_rounded,
            onPressed: available && enough ? () => ref.read(litRepositoryProvider).redeemReward(reward.id) : null,
          ),
        ],
      ),
    );
  }
}
