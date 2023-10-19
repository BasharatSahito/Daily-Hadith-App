class HadithModel {
  int? id;
  String? title;
  String? content;
  // String? date;
  HadithModel({
    this.id,
    this.title,
    this.content,
  });

  HadithModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    // date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    // data['date'] = date;
    return data;
  }
}
