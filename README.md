# Starter-Database-for-music-providers (3NF)
A small database with an **artist, album, song, playlists, tags, users** tables for a university project.

Contributors of the project:
* Juozas Rimantas, Gediminas Valys

---

![database](https://github.com/Effanuel/Starter-Database-for-music-providers/blob/master/generated_database_scheme.png)

## Installation:
* Just import **.sql** file into your database IDE.

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

2. Automatic insertion into foreign tables using block of codes:

```sql
BEGIN; # inserting just an artist
  INSERT INTO artists(artist)
  VALUES ('TEST_ARTIST_INSERT');
COMMIT;


BEGIN; # inserting an album of some specific artist
  INSERT INTO albums(album)
  VALUES ('TEST_ALBUM_INSERT');
  INSERT INTO album_artist(albumID, artistID)
  VALUES (LAST_INSERT_ID(), (SELECT artistID FROM artists WHERE artist = 'TEST_ARTIST_INSERT'));
COMMIT;


BEGIN; # inserting a song of some specific album
  INSERT INTO songs(song)
  VALUES ('TEST_SONG_INSERT');
  INSERT INTO song_album(songID, albumID)
  VALUES (LAST_INSERT_ID(), (SELECT albumID FROM albums WHERE album = 'TEST_ALBUM_INSERT'));
COMMIT;

```
---
### Due to triggers we created earlier, row deletion from the main tables is very simple:

```sql
DELETE FROM artists # deletes an artist, album of the artist, songs of the album of the artist
WHERE artist = 'TEST_ARTIST_INSERT';

DELETE FROM albums  # deletes an album of the artist, songs of the album of the artist
WHERE album = 'TEST_ALBUM_INSERT';

DELETE FROM songs  # deletes a song of the album of the artist
WHERE song = 'TEST_SONG_INSERT';

```
---
## THINGS TO IMPROVE:
* Renaming table names to singular to comply with norms;
* Make multi-row insertion easier;
* Adding more columns;
* Adding dummy data;

### Disclaimer:
* Given the limited functionality, this database could be also considered to be **5NF**.



