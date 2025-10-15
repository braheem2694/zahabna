import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:android_intent_plus/android_intent.dart';

class PdfActionsCard extends StatefulWidget {
  /// Remote URL of the PDF to preview/download
  final String pdfUrl;

  /// Optional custom filename (without path). Defaults to the URL file name.
  final String? fileName;

  /// If true, tries to open the PDF URL in the browser instead of in-app viewer.
  final bool viewInBrowserByDefault;

  const PdfActionsCard({
    super.key,
    required this.pdfUrl,
    this.fileName,
    this.viewInBrowserByDefault = false,
  });

  @override
  State<PdfActionsCard> createState() => _PdfActionsCardState();
}

class _PdfActionsCardState extends State<PdfActionsCard> {
  String? _localPath; // Saved file path
  double _progress = 0.0; // 0..1 during download
  bool _downloading = false;
  PdfControllerPinch? _pdfController; // in-app viewer controller
  bool _showViewer = false;

  @override
  void initState() {
    checkFile();
    super.initState();
    _initViewer();
  }
  checkFile()async{
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/${_deriveFileName()}.pdf';
    bool iFound = await File(savePath).exists();
    if(iFound){
      setState(() {
        _localPath =savePath;

      });
    }

  }

  Future<void> _initViewer() async {
    if (widget.viewInBrowserByDefault) return;

    try {
      final resp = await Dio().get<List<int>>(
        widget.pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final Uint8List bytes = Uint8List.fromList(resp.data ?? const <int>[]);
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(bytes),
      );
      setState(() => _showViewer = true);
    } catch (e) {
      setState(() => _showViewer = false);
    }
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(widget.pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _deriveFileName() {
    if (widget.fileName != null && widget.fileName!.trim().isNotEmpty) {
      return widget.fileName!;
    }
    final last = widget.pdfUrl.split('/').last;
    return last.isEmpty ? 'document.pdf' : last.split('?').first;
  }

  Future<void> _download() async {
    setState(() {
      _downloading = true;
      _progress = 0.0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/${_deriveFileName()}.pdf';

      await Dio().download(
        widget.pdfUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            setState(() => _progress = received / total);
          }
        },
        options: Options(receiveTimeout: const Duration(minutes: 2)),
      );

      setState(() {
        _localPath = savePath;
        _downloading = false;
        _progress = 1.0;
      });
    } catch (e) {
      setState(() {
        _downloading = false;
        _progress = 0.0;
      });

      Ui.flutterToast('Download failed'.tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Download failed')),
      // );
    }
  }

  Future<void> _openFile() async {
    final path = _localPath;
    if (path == null) return;
    await OpenFilex.open(path);
  }

  Future<void> _openFolder() async {
    final path = _localPath;
    if (path == null) return;

    final dirPath = File(path).parent.path;

    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.file(dirPath).toString(),
        type: 'resource/folder',
      );
      try {
        await intent.launch();
      } catch (_) {
        await Share.share(dirPath, subject: 'Folder path');
      }
    } else if (Platform.isIOS) {
      await Share.share(dirPath, subject: 'Folder path');
    } else {
      await OpenFilex.open(dirPath);
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasLocal = _localPath != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, size: 18),
          const SizedBox(width: 8),
          // Filename (ellipsized)
          Text(
            _deriveFileName(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),

          // SINGLE ACTION BUTTON
          _buildActionButton(hasLocal),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool hasLocal) {
    if (_downloading) {
      return SizedBox(
          height: getSize(16),
          width: getSize(16),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ));
    }

    final icon = hasLocal ? Icons.open_in_new_rounded : Icons.download_rounded;
    final onPressed = hasLocal ? _openFile : _download;

    return GestureDetector(onTap: onPressed, child: Icon(icon, size: getSize(18)));
  }
}
