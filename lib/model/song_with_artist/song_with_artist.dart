import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/model/songs/song.dart';

class SongWithArtist {
  final Artist artist;
  final Song song;

  const SongWithArtist({required this.artist, required this.song});
}