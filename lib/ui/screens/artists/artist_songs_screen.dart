import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/model/song_with_artist/song_with_artist.dart';
import 'package:assignment/ui/screens/artists/view_model/artists_viewmodel.dart';
import 'package:assignment/ui/theme/theme.dart';
import 'package:assignment/ui/utils/async_value.dart';
import 'package:assignment/ui/widgets/song/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistSongsScreen extends StatefulWidget {
  const ArtistSongsScreen({super.key, required this.artist});

  final Artist artist;

  @override
  State<ArtistSongsScreen> createState() => _ArtistSongsScreenState();
}

class _ArtistSongsScreenState extends State<ArtistSongsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ArtistsViewmodel>().initArtistDetails(widget.artist);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _likeSong(SongWithArtist song) async {
    final artistVm = context.read<ArtistsViewmodel>();
    final didLike = await artistVm.likeSong(song, widget.artist.id);

    if (!mounted) return;

    if (!didLike) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not like this song. Please try again.'),
        ),
      );
    }
  }

  Future<void> _addComment() async {
    final artistVm = context.read<ArtistsViewmodel>();

    try {
      final didAdd = await artistVm.addComment(
        widget.artist.id,
        _commentController.text,
      );

      if (!didAdd) {
        throw Exception('Failed to add comment');
      }

      if (!mounted) return;
      _commentController.clear();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not add comment. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final artistVm = context.watch<ArtistsViewmodel>();
    final songsValue = artistVm.songsValue;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.artist.name, style: AppTextStyles.heading),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: switch (songsValue.state) {
                AsyncValueState.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                AsyncValueState.error => Center(
                  child: Text(
                    'error = ${songsValue.error!}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                AsyncValueState.success => () {
                  final songs = songsValue.data ?? [];

                  if (songs.isEmpty) {
                    return Center(
                      child: Text(
                        'No songs for this artist yet.',
                        style: AppTextStyles.title,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return SongTile(song: song, onTap: () => _likeSong(song));
                    },
                  );
                }(),
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comments', style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  Expanded(
                    child: artistVm.comments.isEmpty
                        ? Center(
                            child: Text(
                              'No comments yet.',
                              style: AppTextStyles.title,
                            ),
                          )
                        : ListView.builder(
                            itemCount: artistVm.comments.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  artistVm.comments[index],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addComment,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
