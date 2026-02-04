class Info {
  int? id;
  int? clientId;
  String? airline;
  String? country;
  String? createdAt;

  Info({this.id, this.clientId, this.airline, this.country, this.createdAt});

  Info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    airline = json['airline'];
    country = json['country'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['airline'] = airline;
    data['country'] = country;
    data['created_at'] = createdAt;
    return data;
  }

  static List<Info> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Info.fromJson(e)).toList();
  }
}
