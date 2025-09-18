class NotificationsModel {
  int? id;
  String? title;
  String? body;
  int? isRead;
  String? readAt;
  int? driverId;
  String? createdAt;
  String? updatedAt;

  NotificationsModel(
      {this.id,
      this.title,
      this.body,
      this.isRead,
      this.readAt,
      this.driverId,
      this.createdAt,
      this.updatedAt});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isRead = json['is_read'];
    readAt = json['read_at'];
    driverId = json['driver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
 NotificationsModel copyWith({
    int? id,
    String? title,
    String? body,
    int? isRead,
    String? readAt,
    int? driverId,
    String? createdAt,
    String? updatedAt,
    }) {
    return NotificationsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      driverId: driverId ?? this.driverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
    }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['is_read'] = isRead;
    data['read_at'] = readAt;
    data['driver_id'] = driverId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
