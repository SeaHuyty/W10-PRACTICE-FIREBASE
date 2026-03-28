import 'package:assignment/model/song_with_artist/song_with_artist.dart';

import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs();

  Future<Song?> fetchSongById(String id);
  Future<List<SongWithArtist>> joinArtist();
  Future<List<SongWithArtist>> fetchSongsByArtistId(String artistId);
  Future<bool> addComment(String artistId, String comment);
  Future<bool> likeSong(String songId, int currentLike);
}
