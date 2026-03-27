import 'package:assignment/data/repositories/artists/artists_repository.dart';
import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/ui/utils/async_value.dart';
import 'package:flutter/material.dart';

class ArtistsViewmodel extends ChangeNotifier {
  final ArtistsRepository artistsRepository;

  AsyncValue<List<Artist>> artistsValue = AsyncValue.loading();

  ArtistsViewmodel({required this.artistsRepository}) {
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
}
