import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';

class InlineHeadlineWidget extends StatelessWidget {
  final String title;
  final double? productsNumbers;
  final VoidCallback? onTap;

  const InlineHeadlineWidget({
    super.key,
    required this.title,
    this.productsNumbers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8.0),
            if (productsNumbers != null)
              Text(
                '($productsNumbers)',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.gray),
              ),
          ],
        ),
      ],
    );
  }
}
