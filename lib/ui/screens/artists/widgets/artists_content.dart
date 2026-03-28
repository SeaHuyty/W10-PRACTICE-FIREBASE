import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/ui/screens/artists/artist_songs_screen.dart';
import 'package:assignment/ui/screens/artists/view_model/artists_viewmodel.dart';
import 'package:assignment/ui/widgets/artist/artist_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';

class ArtistsContent extends StatelessWidget {
  const ArtistsContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    ArtistsViewmodel artistAsync = context.watch<ArtistsViewmodel>();

    AsyncValue<List<Artist>> asyncValue = artistAsync.artistsValue;

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
        List<Artist> artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) => ArtistTile(
            artist: artists[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtistSongsScreen(artist: artists[index]),
              ),
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
          Text("Artists", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
