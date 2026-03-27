class Song {
  final String id;
  final String title;
  final String artist;
  final Duration duration;
  final Uri image;
  final int like;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.image,
    required this.like
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, duration: $duration, image: $image)';
  }
}
