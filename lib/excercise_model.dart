class Excercise {
  String name;
  String desc;
  String? video;
  String? image;
  List<int> progress = [];
  List<String> progressTimes = [];
  Excercise(this.name, this.desc, [this.video, this.image]);
}
