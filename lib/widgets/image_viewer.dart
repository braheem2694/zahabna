import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String? imageUrl;
  final File? imageFile;

  const FullScreenImageViewer({
    Key? key,
    this.imageUrl,
    this.imageFile,
  })  : assert(imageUrl != null || imageFile != null,
  'Either imageUrl or imageFile must be provided'),
        super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  double _opacity = 1.0;

  final TransformationController _transformationController =
  TransformationController();
  TapDownDetails? _doubleTapDetails;

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += Offset(0, details.delta.dy);
      _opacity = (1.0 - _offset.dy.abs() / 300).clamp(0.0, 1.0);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_offset.dy > 100) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _offset = Offset.zero;
        _opacity = 1.0;
      });
    }
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails!.localPosition;
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale != 1.0) {
      _transformationController.value = Matrix4.identity();
    } else {
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 1.0, -position.dy * 1.0)
        ..scale(2.0);
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Widget _buildImageWidget() {
    if (widget.imageFile != null) {
      return Image.file(
        widget.imageFile!,
        fit: BoxFit.contain,
      );
    } else {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white, size: 48),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(_opacity),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: _handleVerticalDragUpdate,
          onVerticalDragEnd: _handleVerticalDragEnd,
          onDoubleTapDown: (details) => _doubleTapDetails = details,
          onDoubleTap: _handleDoubleTap,
          child: Center(
            child: Transform.translate(
              offset: _offset,
              child: Opacity(
                opacity: _opacity,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 5,
                  child: _buildImageWidget(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
