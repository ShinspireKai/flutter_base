import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/assets.gen.dart';
import 'package:inspection_app/util/widgets/widget_image_asset/image_asset_custom.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage({
    super.key,
    this.fit,
    this.size,
  });

  final double? size;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return ImageAssetCustom(
      imagePath: Assets.images.emptyAvatar.path,
      size: size,
      boxFit: fit,
    );
  }
}
