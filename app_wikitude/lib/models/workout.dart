class MuscleGroup {
  int id;
  String name;
  String? icon;
  String? image;

  MuscleGroup({
    required this.id,
    required this.name,
    this.icon,
    this.image,
  });

  factory MuscleGroup.fromJson(Map<String, dynamic> json) {
    return MuscleGroup(
      id: json["id"],
      name: json["name"],
      icon: json["icon"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'image': image,
      };
}

class Exercise {
  int id;
  int musclegroupId;
  String name;
  String description;
  String focus;
  String? image;
  String url;

  Exercise({
    required this.id,
    required this.musclegroupId,
    required this.name,
    required this.description,
    required this.focus,
    this.image,
    required this.url,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json["id"],
      musclegroupId: json["musclegroupId"],
      name: json["name"],
      description: json["description"],
      focus: json["focus"],
      image: json["image"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'musclegroupId': musclegroupId,
        'description': description,
        'focus': focus,
        'image': image,
        'url': url,
      };
}
