import 'package:assignment/data/repositories/artists/artists_repository.dart';
import 'package:assignment/data/repositories/songs/song_repository.dart';
import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/model/song_with_artist/song_with_artist.dart';
import 'package:assignment/ui/utils/async_value.dart';
import 'package:flutter/material.dart';

class ArtistsViewmodel extends ChangeNotifier {
  final ArtistsRepository artistsRepository;
  final SongRepository songRepository;

  AsyncValue<List<Artist>> artistsValue = AsyncValue.loading();
  AsyncValue<List<SongWithArtist>> songsValue = AsyncValue.loading();
  List<String> comments = [];

  ArtistsViewmodel({
    required this.artistsRepository,
    required this.songRepository,
  }) {
    _init();
  }

  void _init() async {
    fetchArtist();
  }

  void fetchArtist() async {
    artistsValue = AsyncValue.loading();
    notifyListeners();

    try {
      List<Artist> artists = await artistsRepository.fetchArtists();
      artistsValue = AsyncValue.success(artists);
    } catch (e) {
      artistsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  void initArtistDetails(Artist artist) {
    comments = artist.comments.map((c) => c.comment).toList();
    fetchSongsByArtistId(artist.id);
  }

  Future<void> fetchSongsByArtistId(String artistId) async {
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final songs = await songRepository.fetchSongsByArtistId(artistId);
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<bool> likeSong(SongWithArtist song, String artistId) async {
    final didLike = await songRepository.likeSong(song.song.id, song.song.like);
    if (didLike) {
      await fetchSongsByArtistId(artistId);
      return true;
    }
    return false;
  }

  Future<bool> addComment(String artistId, String commentText) async {
    final text = commentText.trim();
    if (text.isEmpty) return false;

    final didAdd = await songRepository.addComment(artistId, text);
    if (didAdd) {
      comments = [...comments, text];
      notifyListeners();
      return true;
    }

    return false;
  }
}
