class Song {
  final int id;
  final int albumId; // BARU
  final int artistId; // BARU
  final String title;
  final int duration;
  final String audioUrl;
  final String album;
  final String coverUrl;
  final String artist;
  final String lyrics;

  Song({
    required this.id,
    required this.albumId,
    required this.artistId,
    required this.title,
    required this.duration,
    required this.audioUrl,
    required this.album,
    required this.coverUrl,
    required this.artist,
    required this.lyrics,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: int.parse(json['id'].toString()),
      albumId: int.parse((json['album_id'] ?? '0').toString()),
      artistId: int.parse((json['artist_id'] ?? '0').toString()),
      title: json['title'].toString(),
      duration: int.parse(json['duration'].toString()),
      audioUrl: json['audio_url'].toString(),
      album: json['album'].toString(),
      coverUrl: json['cover_url'].toString(),
      artist: json['artist'].toString(),
      lyrics: (json['lyrics'] ?? '').toString(),
    );
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
