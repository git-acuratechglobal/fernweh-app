import 'package:cached_network_image/cached_network_image.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:flutter/material.dart';
import 'loading_widget.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      return CachedNetworkImage(
          memCacheWidth: snapshot.maxWidth.cacheSize(context),
          memCacheHeight: snapshot.maxHeight.cacheSize(context),
          maxWidthDiskCache: snapshot.maxWidth.cacheSize(context),
          maxHeightDiskCache: snapshot.maxHeight.cacheSize(context),
          imageUrl: url,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const Center(child: LoadingWidget()),
          fit: BoxFit.cover);
    });
  }
}
