class CropsModel {
  String? url;
  int? uid;
  String? cropName;
  String? cropDescription;
  String? cropType;
  double? latitude;
  double? longitude;

  CropsModel(
      {required this.url,
      required this.uid,
      required this.cropName,
      required this.cropDescription,
      required this.cropType,
      required this.latitude,
      required this.longitude});

  CropsModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    uid = json['uid'];
    cropName = json['crop_name'];
    cropDescription = json['crop_description'];
    cropType = json['crop_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['uid'] = this.uid;
    data['crop_name'] = this.cropName;
    data['crop_description'] = this.cropDescription;
    data['crop_type'] = this.cropType;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
