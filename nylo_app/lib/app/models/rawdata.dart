class RawData {
  String? rawData;

  RawData({this.rawData});

  RawData.fromJson(Map<String, dynamic> json) {
    rawData = json['rawData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rawData'] = this.rawData;
    return data;
  }
}
