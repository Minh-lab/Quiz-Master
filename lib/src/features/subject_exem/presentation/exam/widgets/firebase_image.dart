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

class _FirebaseImageState extends State<FirebaseImage> with AutomaticKeepAliveClientMixin {
  // Global cache để tránh gọi ref.getDownloadURL() nhiều lần cho cùng một link gs://
  static final Map<String, String> _resolvedUrlCache = {};

  String? _resolvedUrl;
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

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
    String finalImageUrl = widget.imageUrl.trim();
    
    // Xử lý các path chưa có tiền tố gs:// hoặc http(s)://
    if (!finalImageUrl.startsWith('http') && !finalImageUrl.startsWith('gs://')) {
      if (finalImageUrl.startsWith('/')) {
        finalImageUrl = finalImageUrl.substring(1);
      }
      finalImageUrl = 'gs://book-shop-791d3.firebasestorage.app/$finalImageUrl';
    }

    if (!finalImageUrl.startsWith('gs://')) {
      setState(() {
        _resolvedUrl = finalImageUrl;
        _isLoading = false;
      });
      return;
    }

    // Kiểm tra cache trước khi gọi network
    if (_resolvedUrlCache.containsKey(finalImageUrl)) {
      if (mounted) {
        setState(() {
          _resolvedUrl = _resolvedUrlCache[finalImageUrl];
          _isLoading = false;
        });
      }
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // Bóc tách lấy đường dẫn thực tế (bỏ qua tên bucket để tránh lỗi refFromURL)
      Uri uri = Uri.parse(finalImageUrl);
      String path = uri.path;
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      
      // Khởi tạo reference tới thư mục/file thông qua path
      final ref = FirebaseStorage.instance.ref().child(path);
      final downloadUrl = await ref.getDownloadURL();
      
      // Lưu vào cache
      _resolvedUrlCache[finalImageUrl] = downloadUrl;

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
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin
    if (_isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _resolvedUrl == null) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.broken_image, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  _error ?? 'Lỗi không xác định',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
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
