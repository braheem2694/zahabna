class StoreRequest {
  final String id;
  final String subscriberName;
  final String motherName;
  final String storeName;
  final String phoneNumber;
  final String country;
  final String region;
  final String address;
  final double recordNumber;
  final double? latitude;
  final double? longitude;
  final int branchCount;
  final int subscriptionMonths;

  final bool agreedToTerms;
  final bool hasTransaction;
  final DateTime? createdAt;
  final DateTime? startDate;
  DateTime? endDate;
  String status;
  final String? birthDay;
  final String userTermsANdConditions;
  final List<StoreImage> images;

// pending, approved, rejected

  StoreRequest({
    required this.id,
    required this.subscriberName,
    required this.motherName,
    required this.latitude,
    required this.longitude,
    required this.hasTransaction,
    required this.storeName,
    required this.phoneNumber,
    required this.country,
    required this.region,
    required this.recordNumber,
    required this.address,
    required this.branchCount,
    required this.birthDay,
    required this.subscriptionMonths,
    required this.agreedToTerms,
    this.createdAt,
    this.startDate,
    this.endDate,
    this.userTermsANdConditions = '',
    required this.images,
    this.status = 'pending',
  });

  // Calculate total amount
  int get totalAmount => branchCount * subscriptionMonths * 30;

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'subscriberName': subscriberName,
      'motherName': motherName,
      'storeName': storeName,
      'phoneNumber': phoneNumber,
      'country': country,
      'region': region,
      'branchCount': branchCount,
      'subscriptionMonths': subscriptionMonths,
      'agreedToTerms': agreedToTerms,
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
      'birthDay': birthDay,
      'longitude': longitude,
      'has_transactions': hasTransaction,
      'latitude': latitude,
      'endDate': endDate?.toIso8601String(),
      'starting_date': startDate?.toIso8601String(),
    };
  }

  // Create from Map
  factory StoreRequest.fromMap(Map<String, dynamic> map) {
    List<StoreImage> parsedImages = [];
    if (map['images'] != null && map['images'] is List) {
      parsedImages = (map['images'] as List).map((img) => StoreImage.fromMap(img)).toList();
    }

    return StoreRequest(
      id: map['id'].toString() ?? '',
      subscriberName: map['name'] ?? '',
      motherName: map['mother_name'] ?? '',
      storeName: map['store_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      country: map['country'] ?? '',
      region: map['place'] ?? '',
      birthDay: map['birth_date'] ?? '',
      hasTransaction: map['has_transaction'] ?? false,
      userTermsANdConditions: map['terms_conditions'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      branchCount: map['branch_count'] ?? 0,
      address: map['address'] ?? '',
      recordNumber: map['record_no'] != null ? (map['record_no'] as num).toDouble() : 0.0,
      subscriptionMonths: map['subscription_count'] ?? 0,
      agreedToTerms: map['agreed_to_terms'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      endDate: map['ending_date'] != null ? DateTime.parse(map['ending_date']) : null,
      startDate: map['starting_date'] != null ? DateTime.parse(map['starting_date']) : null,
      status: (map['status'] ?? 'pending').toString(),
      images: parsedImages,
    );
  }
}

class StoreImage {
  final String filePath;
  final int type;
  final String fileExtension;

  StoreImage({
    required this.filePath,
    required this.type,
    required this.fileExtension,
  });

  factory StoreImage.fromMap(Map<String, dynamic> map) {
    return StoreImage(
      filePath: map['file_path'] ?? '',
      type: map['type'] ?? 0,
      fileExtension: map['file_extension'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'file_path': filePath,
      'type': type,
      'file_extension': fileExtension,
    };
  }
}
