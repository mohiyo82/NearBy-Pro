import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppTextStyles {
  static const TextStyle buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);
  static const TextStyle labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const TextStyle headlineSmall = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, color: AppColors.textGray);
  static const TextStyle captionText = TextStyle(fontSize: 12, color: AppColors.textLight);
  static const TextStyle labelMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textGray);
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );  static const TextStyle headlineMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.5);
}

// ── Primary Button ──────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: AppTextStyles.buttonText),
                ],
              ),
      ),
    );
  }
}

// ── Outline Button ──────────────────────────────────────────────
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  const OutlineButton(
      {super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.buttonText
                  .copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App Input Field ─────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscure;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscure = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 6),
        TextFormField(
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.primary, size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: AppColors.textLight, size: 20)
                : null,
          ),
        ),
      ],
    );
  }
}

// ── Result Card ─────────────────────────────────────────────────
class ResultCard extends StatelessWidget {
  final String name;
  final String category;
  final String distance;
  final String address;
  final double rating;
  final IconData categoryIcon;

  const ResultCard({
    super.key,
    required this.name,
    required this.category,
    required this.distance,
    required this.address,
    required this.rating,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(categoryIcon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppTextStyles.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(category, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          address,
                          style: AppTextStyles.captionText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    distance,
                    style: AppTextStyles.captionText
                        .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.warning),
                    const SizedBox(width: 3),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.textDark),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ──────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader(
      {super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Bottom Navigation Bar ───────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x15000000), blurRadius: 12, offset: Offset(0, -3))
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded), label: 'Saved'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

// ── Stat Chip ───────────────────────────────────────────────────
class StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const StatChip(
      {super.key,
      required this.icon,
      required this.label,
      this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c)),
        ],
      ),
    );
  }
}

// ── Info Row ────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.captionText),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Map Placeholder ─────────────────────────────────────────────
class MapPlaceholder extends StatelessWidget {
  final double height;

  const MapPlaceholder({super.key, this.height = 240});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Grid lines
          CustomPaint(
            size: Size(double.infinity, height),
            painter: _MapGridPainter(),
          ),
          // Center pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Colors.white, size: 26),
                ),
                Container(
                  width: 12,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          // Label
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: const Text('Map View (Placeholder)',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGray)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB2DFDB).withOpacity(0.4)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Avatar Placeholder ──────────────────────────────────────────
class AvatarPlaceholder extends StatelessWidget {
  final double size;
  final String initials;

  const AvatarPlaceholder(
      {super.key, this.size = 80, this.initials = 'U'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Tag Chip ────────────────────────────────────────────────────
class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const TagChip(
      {super.key,
      required this.label,
      this.selected = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.textGray,
          ),
        ),
      ),
    );
  }
}

// ── Custom App Bar ──────────────────────────────────────────────
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Color? bgColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? AppColors.background,
      title: Text(title, style: AppTextStyles.headlineMedium),
      automaticallyImplyLeading: showBack,
      leading: showBack
          ? IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ── Divider with label ──────────────────────────────────────────
class LabelDivider extends StatelessWidget {
  final String label;

  const LabelDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.bodySmall),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

// ── Step Progress Indicator ─────────────────────────────────────
class StepProgress extends StatelessWidget {
  final int current;
  final int total;

  const StepProgress({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i < current;
        final isCurrent = i == current - 1;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary
                  : isCurrent
                      ? AppColors.primaryLight
                      : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ── Empty State Widget ──────────────────────────────────────────
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 44),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Category Icon Grid Item ─────────────────────────────────────
class CategoryGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const CategoryGridItem({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: c.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: c, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textDark, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
