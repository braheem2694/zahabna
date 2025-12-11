List notificationslist = <notificationsclass>[];

class notificationsclass {
  String? notification_id;
  String? notification_type;
  String? notification_status;
  String? notification_link;
  String? notification_text;
  String? category_name;
  String? product_id;
  String? url;
  String? category_id;
  String? created_time;
  String? description;
  String? gift_card_id;
  String? subject;
  String? body;
  String? created_at;
  String? table_id;
  String? row_id;
  String? is_seen;

  notificationsclass({
    this.notification_id,
    this.subject,
    this.body,
    this.created_at,
    this.row_id,
    this.table_id,
    this.is_seen,
    this.notification_type,
    this.notification_status,
    this.notification_link,
    this.notification_text,
    this.category_name,
    this.url,
    this.product_id,
    this.category_id,
    this.created_time,
    this.description,
    this.gift_card_id,
  });

  notificationsclass.fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime to local datetime
    DateTime? parsedDate;
    String? localDateTime;
    if (json['created_at'] != null && json['created_at'].toString() != 'null') {
      try {
        // Parse as UTC and convert to local
        String dateStr = json['created_at'].toString();
        // Add 'Z' suffix if not present to indicate UTC
        if (!dateStr.endsWith('Z') && !dateStr.contains('+')) {
          dateStr = dateStr + 'Z';
        }
        parsedDate = DateTime.parse(dateStr).toLocal();
        // Format: yyyy-MM-dd HH:mm:ss
        localDateTime = parsedDate.toString().substring(0, 19);
      } catch (e) {
        localDateTime = json['created_at'].toString();
      }
    } else {
      localDateTime = json['created_at'].toString();
    }

    notificationslist.add(notificationsclass(
      notification_id: json['notification_id'].toString(),
      subject: json['subject'].toString(),
      body: json['body'].toString(),
      created_at: localDateTime,
      is_seen: json['is_seen'].toString(),
      row_id: json['row_id'].toString(),
      table_id: json['table_id'].toString(),
      notification_type: json['notification_type'].toString(),
      notification_status: json['notification_status'].toString(),
      notification_link: json['notification_link'].toString(),
      notification_text: json['notification_text'].toString(),
      category_name: json['category_name'].toString(),
      url: json['url'].toString(),
      product_id: json['r_product_id'].toString(),
      category_id: json['category_id'].toString(),
      created_time: json['created_time'].toString(),
      gift_card_id: json['gift_card_id'].toString(),
      description: json['description'].toString(),
    ));
  }
}
