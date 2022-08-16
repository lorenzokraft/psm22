import 'package:flutter/material.dart';
import '../../../../models/entities/brand.dart';
import '../../../../widgets/common/flux_image.dart';

class BrandItem extends StatelessWidget {
  final Brand? brand;
  final onTap;
  final isBrandNameShown;
  final isLogoCornerRounded;

  const BrandItem(
      {this.brand,
      this.onTap,
      this.isBrandNameShown = true,
      this.isLogoCornerRounded = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: isLogoCornerRounded
                ? const BorderRadius.all(
                    Radius.circular(15.0),
                  )
                : BorderRadius.zero,
            child: FluxImage(
              imageUrl: brand!.image!,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          isBrandNameShown
              ? Text(
                  brand!.name!,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
