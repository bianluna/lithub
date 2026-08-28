import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:litapp/core/theme/lit_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? LitColors.warmSurface;

    final cardContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withValues(alpha: 0.35),
            baseColor.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Padding(padding: padding, child: child),
    );

    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: cardContent,
        ),
      ),
    );

    if (onTap == null) return card;
    return Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(28), onTap: onTap, child: card));
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.actionLabel, this.onAction});

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!, style: const TextStyle(fontWeight: FontWeight.w700))),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return _GradientActionButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      colors: const [LitColors.primaryBlue, LitColors.brightCyan],
      textColor: LitColors.background,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return _GradientActionButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      colors: const [LitColors.warmSurface, LitColors.goldSparks],
      textColor: LitColors.text,
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    required this.onPressed,
    required this.label,
    required this.colors,
    required this.textColor,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final List<Color> colors;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarCard extends StatelessWidget {
  const SearchBarCard({super.key, required this.hintText, this.controller, this.onChanged});

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: LitColors.warmSurface.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: LitColors.mutedText),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: LitColors.mutedText),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, required this.seed, this.size = 48});

  final String seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = seedColor(seed);
    final initials = seed.isEmpty
        ? '?'
        : seed.length == 1
            ? seed.toUpperCase()
            : seed.substring(0, 2).toUpperCase();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [color.withValues(alpha: .95), color.withValues(alpha: .55)]),
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class ColorPill extends StatelessWidget {
  const ColorPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withValues(alpha: .42), color.withValues(alpha: .18)]),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: .4)),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.progress, this.height = 10, this.color = LitColors.primaryBlue, this.backgroundColor = const Color(0x33FFFFFF)});

  final double progress;
  final double height;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        minHeight: height,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, this.icon, this.color = LitColors.brightCyan});

  final String label;
  final String value;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04), // Almost non opacity background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: color), // Changed icon color to perfectly match the accent color
          const SizedBox(height: 20),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({super.key, required this.title, required this.message, this.actionLabel, this.onAction});

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: LitColors.warmSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Icon(Icons.auto_stories_rounded, size: 38, color: LitColors.primaryBlue),
          ),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LitColors.mutedText)),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            PrimaryButton(label: actionLabel!, onPressed: onAction ?? () {}),
          ],
        ],
      ),
    );
  }
}

class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: LitColors.warmSurface,
      child: Row(
        children: [
          const Icon(Icons.waving_hand_rounded, color: LitColors.primaryBlue),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: Theme.of(context).textTheme.bodyMedium)),
          if (onRetry != null) SecondaryButton(label: 'Retry', onPressed: onRetry!),
        ],
      ),
    );
  }
}

class MiniBarChart extends StatelessWidget {
  const MiniBarChart({super.key, required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values
            .map(
              (value) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 120 * (value / maxValue).clamp(0.12, 1),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [LitColors.primaryBlue.withValues(alpha: .6), LitColors.primaryBlue.withValues(alpha: .2)]),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class MilestoneTimeline extends StatelessWidget {
  const MilestoneTimeline({super.key, required this.items});

  final List<(String, bool)> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: item.$2 ? [BoxShadow(color: LitColors.primaryBlue.withValues(alpha: 0.5), blurRadius: 6)] : null,
                    color: item.$2 ? LitColors.primaryBlue : LitColors.brightCyan.withValues(alpha: .3),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 36,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: -2),
              child: Text(item.$1, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      }),
    );
  }
}

class SelectableChip extends StatelessWidget {
  const SelectableChip({super.key, required this.label, this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap!(),
      selectedColor: LitColors.primaryBlue.withValues(alpha: .25),
      backgroundColor: Colors.white.withValues(alpha: 0.05),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: selected ? LitColors.primaryBlue : LitColors.text,
      ),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class CoverArt extends StatelessWidget {
  const CoverArt({super.key, required this.seed, required this.title, required this.subtitle, required this.accentColor, this.height = 200, this.width = 140});

  final String seed;
  final String title;
  final String subtitle;
  final Color accentColor;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final palette = [
      LitColors.primaryBlue.withValues(alpha: .9),
      LitColors.brightCyan.withValues(alpha: .95),
      LitColors.goldSparks.withValues(alpha: .9),
    ];
    final index = seed.hashCode.abs() % palette.length;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [palette[index], accentColor.withValues(alpha: .88)]),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: -12,
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            top: 16,
            child: Text(
              title,
              style: GoogleFonts.playfairDisplay(
                textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.1),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 16,
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: .9), height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}

Color seedColor(String seed) {
  final index = seed.hashCode.abs() % 4;
  return switch (index) {
    0 => LitColors.primaryBlue,
    1 => LitColors.brightCyan,
    2 => LitColors.goldSparks,
    _ => LitColors.brightCyan,
  };
}
class LitBottomNavItem {
  final IconData icon;
  final String label;

  const LitBottomNavItem({required this.icon, required this.label});
}

class LitBottomNavigation extends StatelessWidget {
  const LitBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<LitBottomNavItem> destinations;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 0),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        color: LitColors.warmSurface.withValues(alpha: 0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(destinations.length, (index) {
            final isSelected = index == selectedIndex;
            final item = destinations[index];
            return GestureDetector(
              onTap: () => onDestinationSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16 : 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? LitColors.primaryBlue.withValues(alpha: 0.25) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected ? Border.all(color: LitColors.brightCyan.withValues(alpha: 0.3), width: 1) : Border.all(color: Colors.transparent, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected ? LitColors.brightCyan : LitColors.mutedText,
                      size: 24,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: const TextStyle(
                          color: LitColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
