class Album {
  final int id;
  final String title;
  final String coverUrl;
  final int releaseYear;
  final String artist;
  final int songCount;

  Album({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.releaseYear,
    required this.artist,
    required this.songCount,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      coverUrl: (json['cover_url'] ?? '').toString(),
      releaseYear: int.parse((json['release_year'] ?? '0').toString()),
      artist: json['artist'].toString(),
      songCount: int.parse((json['song_count'] ?? '0').toString()),
    );
  }
}