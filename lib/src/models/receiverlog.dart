part of 'models.dart';

Receiverlog receiverlogFromJson(String str) => Receiverlog.fromJson(json.decode(str));

String receiverlogToJson(Receiverlog data) => json.encode(data.toJson());

class Receiverlog {
  Receiverlog({
    this.icon,
    this.type,
    this.data,
  });

  String? icon;
  String? type;
  String? data;

  factory Receiverlog.fromJson(Map<String, dynamic> json) => Receiverlog(
        icon: json["icon"],
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "type": type,
        "data": data,
      };
}
