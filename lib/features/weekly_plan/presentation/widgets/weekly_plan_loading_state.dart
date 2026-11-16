import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/app/colors.dart';

// Skeleton screen shown while the backend builds the draft.
class WeeklyPlanLoadingState extends StatefulWidget {
  const WeeklyPlanLoadingState({super.key});

  @override
  State<WeeklyPlanLoadingState> createState() => _WeeklyPlanLoadingStateState();
}

class _WeeklyPlanLoadingStateState extends State<WeeklyPlanLoadingState>
    with SingleTickerProviderStateMixin {
  // One controller drives both the shimmer sweep and the cycling dots.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final dotCount = (t * 4).floor().clamp(0, 3);

        return Stack(
          children: [
            IgnorePointer(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                children: [
                  // Summary card placeholder.
                  _Bone(t: t, height: 150, radius: 20),
                  const SizedBox(height: 16),
                  // Day strip placeholder.
                  Row(
                    children: List.generate(
                      5,
                      (_) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _Bone(t: t, height: 64, radius: 14),
                        ),
                      ),
                    ),
                  ),
                  // Meal slot placeholders.
                  for (var i = 0; i < 3; i++) ...[
                    const SizedBox(height: 22),
                    _Bone(t: t, width: 90, height: 14),
                    const SizedBox(height: 10),
                    _SkeletonCard(t: t),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(child: _LoadingPill(dotCount: dotCount)),
            ),
          ],
        );
      },
    );
  }
}

class _LoadingPill extends StatelessWidget {
  final int dotCount;

  const _LoadingPill({required this.dotCount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputBackground : Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.burntOrange,
            ),
          ),
          const SizedBox(width: 12),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                fontSize: 12,
              ),
              children: [
                const TextSpan(text: 'BUILDING YOUR WEEK'),
                TextSpan(text: '.' * dotCount),
                // Invisible dots keep the pill width constant.
                TextSpan(
                  text: '.' * (3 - dotCount),
                  style: const TextStyle(color: Colors.transparent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Same shape as WeeklyPlanSlotCard so the layout doesn't jump.
class _SkeletonCard extends StatelessWidget {
  final double t;

  const _SkeletonCard({required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _Bone(t: t, width: 76, height: 76, radius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: _Bone(t: t, height: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Bone(t: t, width: 60, height: 22, radius: 100),
                    const SizedBox(width: 8),
                    _Bone(t: t, width: 76, height: 22, radius: 100),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Bone(t: t, width: 40, height: 40, radius: 100),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double t;
  final double? width;
  final double height;
  final double radius;

  const _Bone({
    required this.t,
    this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.07);
    final highlight = isDark
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.black.withValues(alpha: 0.02);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [base, highlight, base],
          stops: const [0.35, 0.5, 0.65],
          transform: _SlideGradient(-1 + 2 * t),
        ),
      ),
    );
  }
}

class _SlideGradient extends GradientTransform {
  final double slidePercent;

  const _SlideGradient(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}