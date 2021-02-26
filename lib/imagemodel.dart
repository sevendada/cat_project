class ImageModel {
  int height;
  String id;
  String url;
  int width;

  ImageModel({this.height, this.id, this.url, this.width});

  ImageModel.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    id = json['id'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['id'] = this.id;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}