import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShColors.dart';
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

  /// Optional base filename (without path). You can pass with or without ".pdf".
  final String? fileName;

  /// If true, tries to open the PDF URL in the browser instead of in-app viewer (for previews).
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
  double? _progress; // null = idle, 0..1 during download
  bool get _downloading => _progress != null && _progress! > 0 && _progress! < 1;

  PdfControllerPinch? _pdfController; // (kept if you preview elsewhere)
  bool _showViewer = false;

  final Color _accent = MainColor; // tweak to your theme

  @override
  void initState() {
    super.initState();
    _checkFile();
    _initViewer(); // harmless, only used if you choose to preview somewhere else
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  Future<void> _checkFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/${_fileBaseName()}.pdf';
    if (await File(savePath).exists()) {
      setState(() => _localPath = savePath);
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
      _pdfController = PdfControllerPinch(document: PdfDocument.openData(bytes));
      setState(() => _showViewer = true);
    } catch (_) {
      setState(() => _showViewer = false);
    }
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(widget.pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Returns a clean base name WITHOUT extension, used for saving.
  String _fileBaseName() {
    if (widget.fileName != null && widget.fileName!.trim().isNotEmpty) {
      final raw = widget.fileName!.trim();
      return raw.toLowerCase().endsWith('.pdf') ? raw.substring(0, raw.length - 4) : raw;
    }
    final rawLast = widget.pdfUrl.split('/').last.split('?').first;
    return rawLast.toLowerCase().endsWith('.pdf') ? rawLast.substring(0, rawLast.length - 4) : (rawLast.isEmpty ? 'document' : rawLast);
  }

  /// Visible name WITH extension for the UI.
  String _displayFileName() => '${_fileBaseName()}.pdf';

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _progress = 0);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/${_fileBaseName()}.pdf';

      await Dio().download(
        widget.pdfUrl,
        savePath,
        options: Options(receiveTimeout: const Duration(minutes: 2)),
        onReceiveProgress: (received, total) {
          if (!mounted) return;
          if (total > 0) setState(() => _progress = received / total);
        },
      );

      setState(() {
        _localPath = savePath;
        _progress = 1;
      });
      FToast().init(context).showToast(
            gravity: ToastGravity.BOTTOM,
            child: _toast('Downloaded', Icons.download_done),
          );
    } catch (e) {
      setState(() => _progress = null);
      Ui.flutterToast('Download failed'.tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
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

  Widget _toast(String msg, IconData icon, {Color bg = const Color(0xDD323232)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(msg, style: const TextStyle(color: Colors.white)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLocal = _localPath != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _downloading ? null : (_localPath != null ? _openFile : _download),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: _downloading
                ? LinearGradient(colors: [
                    _accent.withOpacity(0.55),
                    _accent.withOpacity(0.15),
                  ])
                : LinearGradient(colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.02),
                  ]),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_downloading ? 0.08 : 0.05),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _downloading ? _accent.withOpacity(0.06) : Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Slightly smaller leading icon to give more room to text
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.picture_as_pdf, color: _accent, size: 18),
                    ),
                    const SizedBox(width: 10),

                    // Bigger text area
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _displayFileName(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _downloading ? 'Downloading…' : (_localPath != null ? 'Tap to open' : 'Tap to download'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Enhanced dropdown menu (compact + elegant)
                    PopupMenuButton<String>(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      constraints: const BoxConstraints(minWidth: 180),
                      offset: const Offset(0, 40),
                      shadowColor: Colors.black.withOpacity(0.1),
                      onSelected: (v) async {
                        switch (v) {
                          // case 'open_folder':
                          //   await _openFolder();
                          //   break;
                          case 'open_browser':
                            await _openInBrowser();
                            break;
                          case 'share':
                            if (_localPath != null) {
                              await Share.shareXFiles([XFile(_localPath!)], text: _displayFileName());
                            } else {
                              await Share.share(widget.pdfUrl);
                            }
                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                        // _menuItem(Icons.folder_open, 'Open Folder', 'open_folder'),
                        _menuItem(Icons.open_in_browser, 'Open in Browser', 'open_browser'),
                        _menuItem(Icons.share, 'Share', 'share'),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert_rounded, color: Colors.black54, size: 20),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Primary Action (Download / Open / Progress)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.95, end: 1.0).animate(anim),
                          child: child,
                        ),
                      ),
                      child: _downloading
                          ? _ProgressPill(
                              key: const ValueKey('downloading'),
                              progress: _progress ?? 0,
                              accent: _accent,
                            )
                          : _ActionPill(
                              key: ValueKey(_localPath != null ? 'open' : 'download'),
                              label: _localPath != null ? 'Open' : 'Download',
                              icon: _localPath != null ? Icons.open_in_new_rounded : Icons.download_rounded,
                              solid: _localPath != null,
                              accent: _accent,
                              onTap: _localPath != null ? _openFile : _download,
                            ),
                    ),
                  ],
                ),

                // Slim inline progress bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: _downloading ? 6 : 0,
                  margin: EdgeInsets.only(top: _downloading ? 10 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: _accent.withOpacity(0.12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _downloading
                      ? TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: (_progress ?? 0)),
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          builder: (_, value, __) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: value.clamp(0, 1),
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: _accent,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(IconData icon, String label, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _TinyBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.2,
          height: 1.0,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool solid;
  final VoidCallback onTap;
  final Color accent;

  const _ActionPill({
    super.key,
    required this.label,
    required this.icon,
    required this.solid,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final bg = solid ? accent : accent.withOpacity(0.12);
    final fg = solid ? Colors.white : accent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: accent.withOpacity(solid ? 0 : 0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  final double progress; // 0..1
  final Color accent;

  const _ProgressPill({
    super.key,
    required this.progress,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).clamp(0, 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      constraints: const BoxConstraints(minWidth: 126),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress == 0 ? null : progress,
              color: accent,
              backgroundColor: accent.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            progress == 0 ? 'Preparing…' : '$pct%',
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
