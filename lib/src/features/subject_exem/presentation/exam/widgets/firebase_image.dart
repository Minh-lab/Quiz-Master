import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const FirebaseImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<FirebaseImage> createState() => _FirebaseImageState();
}

class _FirebaseImageState extends State<FirebaseImage> {
  String? _resolvedUrl;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resolveUrl();
  }

  @override
  void didUpdateWidget(covariant FirebaseImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _resolveUrl();
    }
  }

  Future<void> _resolveUrl() async {
    if (!widget.imageUrl.startsWith('gs://')) {
      setState(() {
        _resolvedUrl = widget.imageUrl;
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      // Lấy tham chiếu đến file từ link gs:// và lấy URL download công khai
      final ref = FirebaseStorage.instance.refFromURL(widget.imageUrl);
      final downloadUrl = await ref.getDownloadURL();
      
      if (mounted) {
        setState(() {
          _resolvedUrl = downloadUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _resolvedUrl == null) {
      return const SizedBox(
        height: 150,
        child: Center(child: Icon(Icons.broken_image, color: Colors.red, size: 40)),
      );
    }

    return Center(
      child: CachedNetworkImage(
        imageUrl: _resolvedUrl!,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
        placeholder: (context, url) => const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
