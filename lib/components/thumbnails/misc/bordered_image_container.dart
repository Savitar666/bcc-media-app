import 'package:brunstadtv_app/helpers/permanent_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brunstadtv_app/helpers/transparent_image.dart';

import '../../../theme/design_system/design_system.dart';
import '../../../helpers/images.dart';

class BorderedImageContainer extends StatelessWidget {
  final String? imageUrl;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final bool? useCache;

  const BorderedImageContainer({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.child,
    this.borderRadius,
    this.useCache,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      margin: margin,
      foregroundDecoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        border: Border.all(
          width: 1,
          color: DesignSystem.of(context).colors.onTint.withOpacity(0.1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          if (imageUrl == null) {
            return const SizedBox.shrink();
          }
          final imageHeight = (constraints.maxHeight * MediaQuery.of(context).devicePixelRatio).round();
          final imageUri = imageUrl == null ? null : getImageUri(imageUrl!, height: imageHeight);
          return ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(6),
            child: SizedBox(
              height: constraints.maxHeight,
              child: imageUri == null
                  ? null
                  : FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: useCache == true
                          ? CachedNetworkImageProvider(imageUri.toString(), cacheManager: PermanentCacheManager())
                          : networkImageWithRetryAndResize(
                              imageUrl: imageUri.toString(),
                              cacheHeight: (constraints.maxHeight * MediaQuery.of(context).devicePixelRatio).round(),
                            ),
                      imageErrorBuilder: imageErrorBuilder,
                      fadeInDuration: const Duration(milliseconds: 400),
                    ),
            ),
          );
        },
      ),
    );
  }
}
