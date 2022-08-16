import 'fstore_notification_item.dart';

class FStoreNotification {
  final bool enable;
  List<FStoreNotificationItem> listNotification = <FStoreNotificationItem>[];

  FStoreNotification.init(
    this.enable, {
    List<FStoreNotificationItem>? list,
  }) {
    if (list != null) {
      listNotification = list;
    }
  }

  FStoreNotification copyWith({
    bool? enable,
    List<FStoreNotificationItem>? listNotification,
  }) {
    return FStoreNotification.init(
      enable ?? this.enable,
      list: List.from(listNotification ?? this.listNotification),
    );
  }

  factory FStoreNotification.fromJson(Map<String, dynamic> json) {
    var listNotification = <FStoreNotificationItem>[];
    if (json['listNotification'] != null) {
      listNotification = List.from(json['listNotification']).map((json) {
        return FStoreNotificationItem.fromJson(json);
      }).toList();
    }
    return FStoreNotification.init(
      json['enable'] ?? true,
      list: listNotification,
    );
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('enable', enable);
    writeNotNull(
        'listNotification', listNotification.map((e) => e.toJson()).toList());
    return val;
  }
}
