import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading_widget.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.url});
final String url;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) =>
        const Icon(Icons.error),
        progressIndicatorBuilder:
            (context, url, downloadProgress) =>
        const Center(child: LoadingWidget()),
        fit: BoxFit.cover);
  }
}
