import 'package:assignment/model/song_with_artist/song_with_artist.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    // required this.isPlaying,
    required this.onTap,
  });

  final SongWithArtist song;
  // final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            foregroundImage: NetworkImage(song.song.image.toString()),
          ),
          title: Text(song.song.title),
          trailing: 
          // Row(
          //   children: [
              // Text(
              //   isPlaying ? "Playing" : "",
              //   style: TextStyle(color: Colors.amber),
              // ),
              IconButton(onPressed: onTap, icon: Icon(Icons.favorite)),
            // ],
          // ),
          subtitle: Row(
            children: [
              Text('${song.song.duration.inMinutes.toString()} mins'),
              SizedBox(width: 20),
              Text('${song.song.like.toString()} likes'),
              SizedBox(width: 20),
              Text('${song.artist.name} - ${song.artist.genre}'),
            ],
          ),
        ),
      ),
    );
  }
}
