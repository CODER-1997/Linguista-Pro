import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GroupListShimmer extends StatelessWidget {
  const GroupListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
