class Playlist {
  final int id;
  final String name;
  final String description;
  final int songCount;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.songCount,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      description: (json['description'] ?? '').toString(),
      songCount: int.parse((json['song_count'] ?? '0').toString()),
    );
  }
}