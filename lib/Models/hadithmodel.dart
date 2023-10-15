class HadithModel {
  int? id;
  String? title;
  String? content;

  HadithModel({this.id, this.title, this.content});

  HadithModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}
