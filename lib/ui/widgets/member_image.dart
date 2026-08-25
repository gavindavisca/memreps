import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:provider/provider.dart';
import '../../logic/app_state.dart';

import '../../logic/config.dart';

class MemberImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  const MemberImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isGrayscale = appState.currentProfile?.grayscalePhotos ?? false;

    final trimmedUrl = imageUrl.trim();
    if (trimmedUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        child: const Icon(Icons.person, size: 40, color: Colors.grey),
      );
    }

    String finalUrl = trimmedUrl;
    if (kIsWeb) {
      final proxyBase = Config.getFunctionUrl('proxyImage');
      finalUrl = '$proxyBase?url=${Uri.encodeComponent(trimmedUrl)}&cb=1';
    }

    debugPrint('🖼️ [MemberImage] Loading: "$finalUrl" (Raw: "$trimmedUrl")');

    Widget imageWidget = CachedNetworkImage(
      imageUrl: finalUrl,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      imageBuilder: (context, imageProvider) {
        debugPrint('✅ [MemberImage] Loaded successfully: "$finalUrl"');
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
        );
      },
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        child: const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        debugPrint('❌ [MemberImage] Error loading "$url": $error');
        return Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          child: const Icon(Icons.person, size: 40, color: Colors.grey),
        );
      },
    );

    if (isGrayscale) {
      imageWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
