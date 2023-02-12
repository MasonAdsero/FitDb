class Exercise {
  int id;
  String name;
  String desc;
  String? video;
  String? image;
  List<int> progress = [];
  List<String> progressTimes = [];
  Exercise(this.id, this.name, this.desc, [this.video, this.image]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'video': video,
      'image': image
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Exercise{$id, $name, $desc, ${video ?? "none"}, ${image ?? 'none'}}';
  }
}
