import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorSelectableGif extends StatelessWidget {
  final Color backgroundColor;
  final Function(TenorResult)? onTap;
  final TenorResult result;

  const TenorSelectableGif({
    required this.result,
    this.backgroundColor = Colors.transparent,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaObject = result.media.tinyGifTransparent ?? result.media.tinyGif;

    // If no media object is found, early out
    if (mediaObject == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => onTap?.call(result),
      child: ExtendedImage.network(
        mediaObject.url,
        cache: true,
        gaplessPlayback: true,
        fit: BoxFit.fill,
        headers: const {'accept': 'image/*'},
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return AspectRatio(
                aspectRatio: mediaObject.dimensions.aspectRatio,
                child: Container(
                  color: backgroundColor,
                ),
              );
            case LoadState.completed:
              return AspectRatio(
                aspectRatio: mediaObject.dimensions.aspectRatio,
                child: ExtendedRawImage(
                  fit: BoxFit.fill,
                  image: state.extendedImageInfo?.image,
                ),
              );
            case LoadState.failed:
              return AspectRatio(
                aspectRatio: mediaObject.dimensions.aspectRatio,
                child: Container(
                  color: backgroundColor,
                ),
              );
            default:
              return AspectRatio(
                aspectRatio: mediaObject.dimensions.aspectRatio,
                child: Container(
                  color: backgroundColor,
                ),
              );
          }
        },
      ),
    );
  }
}
