import '../../../cores/assets.dart';

class MainSlider {
  int? id;
  String? sliderName;
  int? orderNumber;
  String? externalLink;
  String? mainImage;
  int? attachmentCounter;
  dynamic lockedBy;
  String? createdBy;
  dynamic updatedBy;
  int? centerNum;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Attachment>? attachments;

  MainSlider({
    this.id,
    this.sliderName,
    this.orderNumber,
    this.externalLink,
    this.mainImage,
    this.attachmentCounter,
    this.lockedBy,
    this.createdBy,
    this.updatedBy,
    this.centerNum,
    this.createdAt,
    this.updatedAt,
    this.attachments,
  });

  MainSlider copyWith({
    int? id,
    String? sliderName,
    int? orderNumber,
    String? externalLink,
    String? mainImage,
    int? attachmentCounter,
    dynamic lockedBy,
    String? createdBy,
    dynamic updatedBy,
    int? centerNum,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Attachment>? attachments,
  }) =>
      MainSlider(
        id: id ?? this.id,
        sliderName: sliderName ?? this.sliderName,
        orderNumber: orderNumber ?? this.orderNumber,
        externalLink: externalLink ?? this.externalLink,
        mainImage: mainImage ?? this.mainImage,
        attachmentCounter: attachmentCounter ?? this.attachmentCounter,
        lockedBy: lockedBy ?? this.lockedBy,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        centerNum: centerNum ?? this.centerNum,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        attachments: attachments ?? this.attachments,
      );

  factory MainSlider.fromJson(Map<String, dynamic> json) => MainSlider(
    id: json["id"],
    sliderName: json["slider_name"],
    orderNumber: json["order_number"],
    externalLink: json["external_link"],
    mainImage: json["main_image"]!=null?"$conVersion${json["main_image"]}":null,
    attachmentCounter: json["attachment_counter"],
    lockedBy: json["locked_by"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    centerNum: json["center_num"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slider_name": sliderName,
    "order_number": orderNumber,
    "external_link": externalLink,
    "main_image": mainImage,
    "attachment_counter": attachmentCounter,
    "locked_by": lockedBy,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "center_num": centerNum,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
  };
}
class Attachment {
  String? filePath;
  String? fileName;
  String? fileExtension;
  DateTime? createdAt;
  String? fileSize;

  Attachment({
    this.filePath,
    this.fileName,
    this.fileExtension,
    this.createdAt,
    this.fileSize,
  });

  Attachment copyWith({
    String? filePath,
    String? fileName,
    String? fileExtension,
    DateTime? createdAt,
    String? fileSize,
  }) =>
      Attachment(
        filePath: filePath ?? this.filePath,
        fileName: fileName ?? this.fileName,
        fileExtension: fileExtension ?? this.fileExtension,
        createdAt: createdAt ?? this.createdAt,
        fileSize: fileSize ?? this.fileSize,
      );

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    filePath: json["file_path"]!=null?"$conVersion${json["file_path"]}":null,

    fileName: json["file_name"],
    fileExtension: json["file_extension"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    fileSize: json["file_size"],
  );

  Map<String, dynamic> toJson() => {
    "file_path": filePath,
    "file_name": fileName,
    "file_extension": fileExtension,
    "created_at": createdAt?.toIso8601String(),
    "file_size": fileSize,
  };
}