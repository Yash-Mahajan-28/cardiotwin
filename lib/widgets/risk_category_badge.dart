/// Risk category badge widget for status display

import 'package:flutter/material.dart';
import '../models/model_config.dart';

class RiskCategoryBadge extends StatelessWidget {
  final RiskCategory category;
  final double? percentage;
  final bool showEmoji;
  final double? fontSize;
  final EdgeInsets? padding;

  const RiskCategoryBadge({
    Key? key,
    required this.category,
    this.percentage,
    this.showEmoji = true,
    this.fontSize,
    this.padding,
  }) : super(key: key);

  Color _getCategoryColor() {
    switch (category) {
      case RiskCategory.LOW:
        return const Color(0xFF4CAF50); // Green
      case RiskCategory.MODERATE:
        return const Color(0xFFFFC107); // Amber
      case RiskCategory.HIGH:
        return const Color(0xFFF44336); // Red
    }
  }

  String _getEmoji() {
    switch (category) {
      case RiskCategory.LOW:
        return '🟢';
      case RiskCategory.MODERATE:
        return '🟡';
      case RiskCategory.HIGH:
        return '🔴';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    final emoji = _getEmoji();
    final displayText = '${showEmoji ? emoji + ' ' : ''}${category.label}${percentage != null ? ' (${percentage!.toStringAsFixed(1)}%)' : ''}';

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: fontSize ?? 14,
        ),
      ),
    );
  }
}

