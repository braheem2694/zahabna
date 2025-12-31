import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/assets.dart';

import '../main.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// 🚀 BACKGROUND UPLOAD SERVICE
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// A singleton service that handles image uploads independently of UI lifecycle.
/// 
/// Key Features:
/// - Lives for the entire app lifecycle (permanent: true)
/// - Continues uploads even after screens are disposed
/// - Prevents duplicate uploads via task tracking
/// - Observable state for UI re-attachment
/// - Thread-safe task management
/// 
/// Usage:
///   BackgroundUploadService.instance.enqueueUpload(...);
///   
/// Note: Dio uses platform channels, so uploads run on main isolate.
/// The key is decoupling from controller lifecycle, not thread isolation.
/// ═══════════════════════════════════════════════════════════════════════════

/// Represents a single image upload task
class UploadTask {
  final String id;
  final String tableName;
  final String rowId;
  final String fileName;
  final String filePath;
  final int type;
  final String token;
  
  UploadTaskStatus status;
  String? errorMessage;
  
  UploadTask({
    required this.id,
    required this.tableName,
    required this.rowId,
    required this.fileName,
    required this.filePath,
    required this.type,
    required this.token,
    this.status = UploadTaskStatus.pending,
    this.errorMessage,
  });
  
  /// Unique key to prevent duplicate uploads
  String get uniqueKey => '$rowId-$type-$fileName';
}

enum UploadTaskStatus {
  pending,
  uploading,
  completed,
  failed,
}

/// Represents a batch of uploads for a single request
class UploadBatch {
  final String batchId;
  final String rowId;
  final List<UploadTask> tasks;
  final DateTime createdAt;
  
  UploadBatch({
    required this.batchId,
    required this.rowId,
    required this.tasks,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  int get completedCount => tasks.where((t) => t.status == UploadTaskStatus.completed).length;
  int get failedCount => tasks.where((t) => t.status == UploadTaskStatus.failed).length;
  int get totalCount => tasks.length;
  bool get isComplete => completedCount + failedCount == totalCount;
  bool get hasFailures => failedCount > 0;
  double get progress => totalCount > 0 ? completedCount / totalCount : 0.0;
}

class BackgroundUploadService extends GetxService {
  // ═══════════════════════════════════════════════════════════════════════════
  // SINGLETON PATTERN
  // ═══════════════════════════════════════════════════════════════════════════
  
  static BackgroundUploadService get instance {
    if (!Get.isRegistered<BackgroundUploadService>()) {
      Get.put(BackgroundUploadService(), permanent: true);
    }
    return Get.find<BackgroundUploadService>();
  }
  
  /// Initialize at app startup (call from main.dart)
  static Future<BackgroundUploadService> init() async {
    return Get.put(BackgroundUploadService(), permanent: true);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE - Observable for UI re-attachment
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Currently active batches
  final RxMap<String, UploadBatch> _activeBatches = <String, UploadBatch>{}.obs;
  
  /// Overall upload state
  final RxBool isUploading = false.obs;
  
  /// Current batch progress (0.0 - 1.0)
  final RxDouble currentProgress = 0.0.obs;
  
  /// Track in-progress task keys to prevent duplicates
  final Set<String> _inProgressKeys = {};
  
  /// Stream controller for upload events
  final _uploadEventController = StreamController<UploadEvent>.broadcast();
  Stream<UploadEvent> get uploadEvents => _uploadEventController.stream;
  
  /// Dio instance (reusable)
  late final dio.Dio _dio;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════
  
  @override
  void onInit() {
    super.onInit();
    _dio = dio.Dio();
    debugPrint('📤 BackgroundUploadService initialized');
  }
  
  @override
  void onClose() {
    _uploadEventController.close();
    _dio.close();
    debugPrint('📤 BackgroundUploadService closed');
    super.onClose();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Enqueue a batch of images for background upload.
  /// 
  /// This method returns immediately - uploads continue in background.
  /// Use [uploadEvents] stream to monitor progress.
  /// 
  /// [images] - List of image data with: filePath, fileName, type
  /// [tableName] - Database table name
  /// [rowId] - Row ID for the upload
  /// [token] - Auth token (captured at call time to avoid stale refs)
  void enqueueUpload({
    required List<Map<String, dynamic>> images,
    required String tableName,
    required String rowId,
    String? token,
  }) {
    if (images.isEmpty) {
      debugPrint('📤 No images to upload, skipping');
      return;
    }
    
    final authToken = token ?? prefs?.getString("token") ?? "";
    if (authToken.isEmpty) {
      debugPrint('📤 No auth token available, cannot upload');
      _emitEvent(UploadEvent.error('No authentication token'));
      return;
    }
    
    // Create unique batch ID
    final batchId = '${rowId}_${DateTime.now().millisecondsSinceEpoch}';
    
    // Filter out already in-progress or duplicate uploads
    final tasks = <UploadTask>[];
    for (final img in images) {
      final task = UploadTask(
        id: '${batchId}_${img['type']}',
        tableName: tableName,
        rowId: rowId,
        fileName: img['fileName'] ?? _basename(img['filePath'] ?? ''),
        filePath: img['filePath'] ?? '',
        type: img['type'] ?? 0,
        token: authToken,
      );
      
      // Skip if already uploading this exact file
      if (_inProgressKeys.contains(task.uniqueKey)) {
        debugPrint('📤 Skipping duplicate: ${task.uniqueKey}');
        continue;
      }
      
      tasks.add(task);
    }
    
    if (tasks.isEmpty) {
      debugPrint('📤 All images already uploading or duplicates');
      return;
    }
    
    // Create batch
    final batch = UploadBatch(
      batchId: batchId,
      rowId: rowId,
      tasks: tasks,
    );
    
    _activeBatches[batchId] = batch;
    
    debugPrint('📤 Queued ${tasks.length} images for upload (batch: $batchId)');
    
    // Fire and forget - this continues even if caller is disposed
    _processUploadBatch(batch);
  }
  
  /// Check if there are active uploads for a given row
  bool hasActiveUploads(String rowId) {
    return _activeBatches.values.any((b) => b.rowId == rowId && !b.isComplete);
  }
  
  /// Get progress for a specific row (0.0 - 1.0)
  double getProgressForRow(String rowId) {
    final batches = _activeBatches.values.where((b) => b.rowId == rowId);
    if (batches.isEmpty) return 1.0;
    
    int total = 0;
    int completed = 0;
    for (final b in batches) {
      total += b.totalCount;
      completed += b.completedCount;
    }
    
    return total > 0 ? completed / total : 1.0;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE - Upload Processing
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Process uploads sequentially within a batch.
  /// This runs as an async operation independent of any controller.
  Future<void> _processUploadBatch(UploadBatch batch) async {
    isUploading.value = true;
    _emitEvent(UploadEvent.started(batch.batchId, batch.totalCount));
    
    for (final task in batch.tasks) {
      // Mark as in-progress
      _inProgressKeys.add(task.uniqueKey);
      task.status = UploadTaskStatus.uploading;
      _updateProgress();
      
      try {
        await _uploadSingleImage(task);
        task.status = UploadTaskStatus.completed;
        _emitEvent(UploadEvent.progress(
          batch.batchId,
          batch.completedCount,
          batch.totalCount,
        ));
        debugPrint('📤 ✅ Uploaded: ${task.fileName} (type: ${task.type})');
      } catch (e) {
        task.status = UploadTaskStatus.failed;
        task.errorMessage = e.toString();
        _emitEvent(UploadEvent.taskFailed(batch.batchId, task.type, e.toString()));
        debugPrint('📤 ❌ Failed: ${task.fileName} - $e');
      } finally {
        _inProgressKeys.remove(task.uniqueKey);
        _updateProgress();
      }
    }
    
    // Batch complete
    if (batch.hasFailures) {
      _emitEvent(UploadEvent.completedWithErrors(
        batch.batchId,
        batch.completedCount,
        batch.failedCount,
      ));
    } else {
      _emitEvent(UploadEvent.completed(batch.batchId, batch.completedCount));
    }
    
    // Cleanup completed batch after a delay
    Future.delayed(const Duration(seconds: 5), () {
      _activeBatches.remove(batch.batchId);
    });
    
    // Update global uploading state
    isUploading.value = _activeBatches.values.any((b) => !b.isComplete);
  }
  
  /// Upload a single image file
  Future<void> _uploadSingleImage(UploadTask task) async {
    final formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        task.filePath,
        filename: task.fileName,
      ),
      "file_name": task.fileName,
      "token": task.token,
      "table_name": task.tableName,
      "row_id": task.rowId,
      "type": task.type.toString(),
    });
    
    final response = await _dio.post(
      "${con}side/upload-images",
      data: formData,
      options: dio.Options(
        headers: {
          'Accept': "application/json",
          'Authorization': 'Bearer ${task.token}',
        },
        // Timeout for slow connections
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Upload failed with status: ${response.statusCode}');
    }
  }
  
  void _updateProgress() {
    if (_activeBatches.isEmpty) {
      currentProgress.value = 0.0;
      return;
    }
    
    int total = 0;
    int completed = 0;
    for (final batch in _activeBatches.values) {
      total += batch.totalCount;
      completed += batch.completedCount;
    }
    
    currentProgress.value = total > 0 ? completed / total : 0.0;
  }
  
  void _emitEvent(UploadEvent event) {
    if (!_uploadEventController.isClosed) {
      _uploadEventController.add(event);
    }
  }
  
  String _basename(String path) {
    final q = path.split('?').first;
    final h = q.split('#').first;
    return h.split('/').last;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UPLOAD EVENTS - For UI observation
// ═══════════════════════════════════════════════════════════════════════════

enum UploadEventType {
  started,
  progress,
  taskFailed,
  completed,
  completedWithErrors,
  error,
}

class UploadEvent {
  final UploadEventType type;
  final String? batchId;
  final int? current;
  final int? total;
  final int? failedType;
  final String? message;
  
  UploadEvent._({
    required this.type,
    this.batchId,
    this.current,
    this.total,
    this.failedType,
    this.message,
  });
  
  factory UploadEvent.started(String batchId, int total) => UploadEvent._(
    type: UploadEventType.started,
    batchId: batchId,
    total: total,
  );
  
  factory UploadEvent.progress(String batchId, int current, int total) => UploadEvent._(
    type: UploadEventType.progress,
    batchId: batchId,
    current: current,
    total: total,
  );
  
  factory UploadEvent.taskFailed(String batchId, int type, String message) => UploadEvent._(
    type: UploadEventType.taskFailed,
    batchId: batchId,
    failedType: type,
    message: message,
  );
  
  factory UploadEvent.completed(String batchId, int count) => UploadEvent._(
    type: UploadEventType.completed,
    batchId: batchId,
    current: count,
  );
  
  factory UploadEvent.completedWithErrors(String batchId, int completed, int failed) => UploadEvent._(
    type: UploadEventType.completedWithErrors,
    batchId: batchId,
    current: completed,
    total: failed,
  );
  
  factory UploadEvent.error(String message) => UploadEvent._(
    type: UploadEventType.error,
    message: message,
  );
}
