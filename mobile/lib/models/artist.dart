class Artist {
  final int id;
  final String name;
  final String imageUrl;
  final int albumCount;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.albumCount,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      imageUrl: (json['image_url'] ?? '').toString(),
      albumCount: int.parse((json['album_count'] ?? '0').toString()),
    );
  }
}