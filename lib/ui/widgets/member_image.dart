import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    String finalUrl = imageUrl;
    
    if (kIsWeb && imageUrl.isNotEmpty) {
      if (kDebugMode) {
        // In local development, the relative /proxy path doesn't exist on the Flutter dev server.
        // We point directly to the local Functions emulator instead.
        finalUrl = 'http://127.0.0.1:5001/openclaw-bot-486015/us-central1/proxyImage?url=${Uri.encodeComponent(imageUrl)}';
      } else {
        // In production, Firebase Hosting rewrites /proxy to the Cloud Function.
        finalUrl = '/proxy?url=${Uri.encodeComponent(imageUrl)}';
      }
    }

    return CachedNetworkImage(
      imageUrl: finalUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
        child: const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
        child: const Icon(Icons.person, size: 40, color: Colors.grey),
      ),
    );
  }
}
