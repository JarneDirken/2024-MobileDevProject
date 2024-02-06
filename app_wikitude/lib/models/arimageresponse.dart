class ARImageResponse {
  int id;
  int musclegroupId;
  String name;
  String description;
  String focus;
  String image;
  String url;

  ARImageResponse({
      required this.id, 
      required this.musclegroupId, 
      required this.name,
      required this.description,
      required this.focus,
      required this.image,
      required this.url,
    });
  factory ARImageResponse.fromJson(Map<String, dynamic> json) {
    return ARImageResponse(
      id: json['id'],
      musclegroupId: json['musclegroupId'],
      name: json['name'],
      description: json['description'],
      focus: json['focus'],
      image: json['image'],
      url: json['url'],
    );
  }
}