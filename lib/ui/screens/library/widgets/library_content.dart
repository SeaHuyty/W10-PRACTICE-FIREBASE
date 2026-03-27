import 'package:assignment/model/song_with_artist/song_with_artist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    LibraryViewModel mv = context.watch<LibraryViewModel>();

    AsyncValue<List<SongWithArtist>> asyncValue = mv.songsValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );
        break;

      case AsyncValueState.success:
        List<SongWithArtist> songs = asyncValue.data!;
        content = RefreshIndicator(
          onRefresh: () async => context.read<LibraryViewModel>().fetchSong(),
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) => SongTile(
              song: songs[index],
              // isPlaying: mv.isSongPlaying(songs[index]),
              onTap: () {
                // mv.start(songs[index]);
                mv.likeSong(songs[index].song.id, songs[index].song.like);
              },
            ),
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Library", style: AppTextStyles.heading),
              SizedBox(width: 8),
              IconButton(
                tooltip: 'Refresh',
                onPressed: mv.fetchSong,
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
