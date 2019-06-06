# Starter-Database-for-music-providers (3NF)
A small database with an **artist, album, song, playlists, tags, users** tables for a university project.

![database](https://github.com/Effanuel/Starter-Database-for-music-providers/blob/master/generated_database_scheme.png)




## Database features included:
1. Automatic deletion of foreign tables' rows using triggers
```sql
CREATE TRIGGER artist_delete_albums_delete
 BEFORE DELETE
 ON artists
 FOR EACH ROW
BEGIN
 DELETE FROM albums
 WHERE albums.albumID IN (
  SELECT album_artist.albumID
  FROM album_artist WHERE album_artist.artistID = old.artistID
 );
END


CREATE TRIGGER albums_delete_songs_delete
 BEFORE DELETE
 ON albums
 FOR EACH ROW
BEGIN
 DELETE FROM songs
 WHERE songs.songID IN (
  SELECT song_album.songID
  FROM song_album WHERE song_album.albumID = OLD.albumID
 );
END
```

2. Automatic insertion into foreign tables *(using cascade, can also be done using triggers, although unnecessary)*
### Due to triggers we created earlier, row deletion from the main tables is very simple:

```sql
DELETE FROM artists # deletes an artist, album of the artist, songs of the album of the artist
WHERE artist = 'TEST_ARTIST_INSERT';

DELETE FROM albums  # deletes an album of the artist, songs of the album of the artist
WHERE album = 'TEST_ALBUM_INSERT';

DELETE FROM songs  # deletes a song of the album of the artist
WHERE song = 'TEST_SONG_INSERT';

```

## THINGS TO IMPROVE:
* Renaming table names to singular to comply with norms





