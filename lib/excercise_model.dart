class Excercise {
  int id;
  String name;
  String desc;
  String? video;
  String? image;
  List<int> progress = [];
  List<String> progressTimes = [];
  Excercise(this.id, this.name, this.desc, [this.video, this.image]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'video': video,
      'image': image
    };
  }
}
