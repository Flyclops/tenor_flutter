import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorSelectableGif extends StatelessWidget {
  final TenorResult result;
  final Function(TenorResult)? _onTap;
  final Color backgroundColor;

  const TenorSelectableGif({
    required this.result,
    Function(TenorResult)? onTap,
    this.backgroundColor = Colors.transparent,
    super.key,
  }) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    final mediaObject = result.media.tinygifTransparent ?? result.media.tinygif;

    // If no media object is found, early out
    if (mediaObject == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _onTap?.call(result),
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
