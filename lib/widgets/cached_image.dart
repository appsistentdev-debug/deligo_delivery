import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:deligo_delivery/config/assets.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final String? imagePlaceholder;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit? fit;
  final Widget? placeholderWidget;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.imagePlaceholder,
    this.height,
    this.width,
    this.radius,
    this.fit,
    this.placeholderWidget,
  });

  @override
  Widget build(BuildContext context) => imageUrl != null && imageUrl!.isNotEmpty
      ? CachedNetworkImage(
          imageUrl: imageUrl!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.fill,
          errorWidget: (context, img, d) => Image.asset(
            imagePlaceholder != null ? imagePlaceholder! : Assets.emptyImage,
            height: height,
            width: width,
            fit: fit ?? BoxFit.fill,
          ),
          placeholder: (context, string) =>
              placeholderWidget ??
              Image.asset(
                imagePlaceholder != null
                    ? imagePlaceholder!
                    : Assets.emptyImage,
                height: height,
                width: width,
                fit: fit ?? BoxFit.fill,
              ),
        )
      : Image.asset(
          imagePlaceholder != null ? imagePlaceholder! : Assets.emptyImage,
          height: height,
          width: width,
          fit: fit ?? BoxFit.fill,
        );
}

class CachedImageProvider extends CachedNetworkImageProvider {
  const CachedImageProvider(super.url);
}
