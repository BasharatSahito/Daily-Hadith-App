class HadithModel {
  int? id;
  String? title;
  String? arabicHadith;
  String? urduHadith;
  String? englishHadith;
  String? info;

  HadithModel(
      {this.id,
      this.title,
      this.arabicHadith,
      this.urduHadith,
      this.englishHadith,
      this.info});

  HadithModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    arabicHadith = json['arabicHadith'];
    urduHadith = json['urduHadith'];
    englishHadith = json['englishHadith'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['arabicHadith'] = arabicHadith;
    data['urduHadith'] = urduHadith;
    data['englishHadith'] = englishHadith;
    data['info'] = info;
    return data;
  }
}
