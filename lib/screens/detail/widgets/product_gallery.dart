import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product;
import '../../../widgets/common/webview.dart';
import 'image_galery.dart';

class ProductGallery extends StatelessWidget {
  final Product? product;
  final Function? onSelect;

  const ProductGallery({this.product, this.onSelect});

  void _playVideo(BuildContext context) {
    if (onSelect != null) {
      onSelect!(product!.videoUrl, true);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WebView(url: product!.videoUrl);
        });
  }

  void _onShowGallery(BuildContext context, [int index = 0]) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ImageGalery(images: product!.images, index: index);
        });
  }

  void _handleImageTap(BuildContext context,
      {int index = 0, bool fullScreen = false}) {
    if (onSelect != null && !fullScreen) {
      onSelect!(product!.images[index], false);
      return;
    }
    _onShowGallery(context, index);
  }

  @override
  Widget build(BuildContext context) {
    var isEmpty = (product!.images.length) <= 1 && product!.videoUrl == null;

    if ((product!.images.length) < kProductDetail.showThumbnailAtLeast ||
        isEmpty) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        final dimension = constraint.maxWidth * 0.2;
        return SizedBox(
          height: dimension * 0.8 + 8,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (product!.videoUrl != null && product!.videoUrl != '')
                  InkWell(
                    onTap: () => _playVideo(context),
                    child: Container(
                      width: dimension,
                      height: dimension * 0.8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                ImageTools.networkImage(product!.imageFeature),
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.dstATop)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.play_circle_outline,
                            size: 40,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.of(context).video,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          )
                        ],
                      ),
                    ),
                  ),
                for (var i = kIsWeb ? 0 : 1; i < product!.images.length; i++)
                  GestureDetector(
                    onDoubleTap: () =>
                        _handleImageTap(context, index: i, fullScreen: true),
                    onLongPress: () =>
                        _handleImageTap(context, index: i, fullScreen: true),
                    onTap: () => _handleImageTap(context, index: i),
                    child: Container(
                      padding: const EdgeInsets.only(left: 4.0, right: 8),
                      margin: const EdgeInsets.only(left: 2, top: 4, right: 4),
                      child: ImageTools.image(
                        url: product!.images[i],
                        height: dimension * (kIsWeb ? 1.2 : 0.9),
                        width: dimension,
                        isResize: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
