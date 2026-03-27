import '../../model/songs/song.dart';

class SongDto {
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String artistKey = 'artistId';
  static const String durationKey = 'duration';
  static const String imageKey = 'imageUrl';
  static const String likeKey = 'like';

  static Song fromJson(Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[titleKey] is String);
    assert(json[artistKey] is String);
    assert(json[durationKey] is int);
    assert(json[imageKey] is String);
    assert(json[likeKey] is int);

    return Song(
      id: json[idKey],
      title: json[titleKey],
      artist: json[artistKey],
      duration: Duration(milliseconds: json[durationKey]),
      image: Uri.parse(json[imageKey]),
      like: json[likeKey]
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      idKey: song.id,
      titleKey: song.title,
      artistKey: song.artist,
      durationKey: song.duration.inMilliseconds,
      imageKey: song.image.toString(),
      likeKey: song.like
    };
  }
}
