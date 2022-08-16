import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/constants.dart';

class FluxImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final String? package;

  const FluxImage({
    required this.imageUrl,
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.package,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageProxy = '';
    var isSvgImage = imageUrl.split('.').last == 'svg';

    if (imageUrl.isEmpty) {
      return const SizedBox();
    }

    if (!imageUrl.contains('http')) {
      if (isSvgImage) {
        return SvgPicture.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: color,
          package: package,
        );
      }
      return SvgPicture.asset(
        imageUrl,
        width: width,
        height: height,
        color: color,
        package: package,
      );
    }

    if (kIsWeb) {
      imageProxy = '$kImageProxy${width}x,q30/';
      if (kImageProxy.isEmpty) {
        /// this image proxy is use for demo purpose, please make your own one
        imageProxy = 'https://cors.mstore.io/';
      }
    }

    if (isSvgImage) {
      return SvgPicture.network(
        '$imageProxy$imageUrl',
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    }

    if (!isSvgImage) {
      return Image.asset(
        '$imageUrl',
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    }

    return ExtendedImage.network(
      '$imageProxy$imageUrl',
      width: width,
      height: height,
      fit: fit,
      color: color,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return state.completedWidget;
          case LoadState.loading:
          case LoadState.failed:
          default:
            return const SizedBox();
        }
      },
    );
  }
}
