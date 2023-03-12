class Exercise {
  int id;
  String name;
  String desc;
  String? video;
  String? image;
  String? youtubeLink;
  List<int> progress = [];
  List<String> progressTimes = [];
  Exercise(this.id, this.name, this.desc, [this.video, this.image, this.youtubeLink]);
  Exercise.fromJson(Map<String, dynamic> data):
    id = data["id"],
    name = data["name"],
    desc = data["desc"],
    image = data["image"],
    video = data["video"],
    youtubeLink = data["youtubeLink"],
    progress = data["progress"] == null ? [] : List<int>.from(data["progress"]),
    progressTimes = data["progressTimes"] == null ? [] : List<String>.from(data["progressTimes"]);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'video': video,
      'image': image,
      'youtubeLink': youtubeLink
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Exercise{$id, $name, $desc, ${video ?? "none"}, ${image ?? 'none'}, ${youtubeLink ?? 'none'}}';
  }
}
