import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MenuShimmer extends StatelessWidget {
  final bool isTable;
  final bool isDark;

  const MenuShimmer({super.key, required this.isTable, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (isTable) {
      return _buildTableShimmer();
    } else {
      return _buildCardShimmer();
    }
  }

  Widget _buildCardShimmer() {
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[300]!,
      highlightColor: isDark ? const Color(0xFF3A3A3A) : Colors.grey[100]!,
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableShimmer() {
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[300]!,
      highlightColor: isDark ? const Color(0xFF3A3A3A) : Colors.grey[100]!,
      child: Column(
        children: [
          // Header Shimmer
          Container(height: 50, color: Colors.white),
          const Divider(height: 1),
          // Rows Shimmer
          ...List.generate(
            8,
            (index) => Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
