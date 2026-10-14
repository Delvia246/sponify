class Song {
  final int id;
  final String title;
  final int duration;
  final String audioUrl;
  final String album;
  final String coverUrl;
  final String artist;

  Song({
    required this.id,
    required this.title,
    required this.duration,
    required this.audioUrl,
    required this.album,
    required this.coverUrl,
    required this.artist,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      duration: int.parse(json['duration'].toString()),
      audioUrl: json['audio_url'].toString(),
      album: json['album'].toString(),
      coverUrl: json['cover_url'].toString(),
      artist: json['artist'].toString(),
    );
  }

  // Format durasi dari detik ke "3:15"
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}