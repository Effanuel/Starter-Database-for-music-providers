CREATE TABLE albums
(
  albumID       int AUTO_INCREMENT,
  album         text          NULL,
  released_year year          NULL,
  URL           varchar(2083) NULL,
  CONSTRAINT albums_albumID_uindex
    UNIQUE (albumID)
);

ALTER TABLE albums
  ADD PRIMARY KEY (albumID);

CREATE TRIGGER albums_delete_songs_delete
  BEFORE DELETE
  ON albums
  FOR EACH ROW
BEGIN
  DELETE
  FROM songs
  WHERE songs.songID IN (
    SELECT song_album.songID
    FROM song_album
    WHERE song_album.albumID = OLD.albumID
  );

END;

CREATE TABLE playlist
(
  playlistID int AUTO_INCREMENT
    PRIMARY KEY,
  name       text NOT NULL
);

CREATE TABLE songs
(
  songID       int AUTO_INCREMENT,
  song         varchar(150)     NOT NULL,
  playtime     time             NULL,
  weekly_views int(11) UNSIGNED NULL,
  CONSTRAINT songs_songID_uindex
    UNIQUE (songID)
);

ALTER TABLE songs
  ADD PRIMARY KEY (songID);

CREATE TABLE playlists_song
(
  playlistID int NULL,
  songID     int NULL,
  CONSTRAINT playlists_song_playlist_playlistID_fk
    FOREIGN KEY (playlistID) REFERENCES playlist (playlistID)
      ON DELETE CASCADE,
  CONSTRAINT playlists_songs_songID_fk
    FOREIGN KEY (songID) REFERENCES songs (songID)
      ON DELETE CASCADE
);

CREATE TABLE song_album
(
  songID  int           NOT NULL,
  albumID int DEFAULT 0 NOT NULL,
  CONSTRAINT albumID_albums_song
    FOREIGN KEY (albumID) REFERENCES albums (albumID)
      ON DELETE CASCADE,
  CONSTRAINT songID_songs_album
    FOREIGN KEY (songID) REFERENCES songs (songID)
      ON DELETE CASCADE
);

CREATE TABLE tags
(
  tagID int AUTO_INCREMENT
    PRIMARY KEY,
  tag   varchar(20) NOT NULL
);

CREATE TABLE artists
(
  artistID    int AUTO_INCREMENT,
  artist      varchar(50) NULL,
  tagID       int         NULL,
  description text        NULL,
  CONSTRAINT artists_artistID_uindex
    UNIQUE (artistID),
  CONSTRAINT artists_tags_tagID_fk
    FOREIGN KEY (tagID) REFERENCES tags (tagID)
);

ALTER TABLE artists
  ADD PRIMARY KEY (artistID);

CREATE TABLE album_artist
(
  albumID  int NULL,
  artistID int NULL,
  CONSTRAINT albumID_albums_artist
    FOREIGN KEY (albumID) REFERENCES albums (albumID)
      ON DELETE CASCADE,
  CONSTRAINT artistID_artists_album
    FOREIGN KEY (artistID) REFERENCES artists (artistID)
      ON DELETE CASCADE
);

CREATE TRIGGER artist_delete_albums_delete
  BEFORE DELETE
  ON artists
  FOR EACH ROW
BEGIN
  DELETE
  FROM albums
  WHERE albums.albumID IN (
    SELECT album_artist.albumID
    FROM album_artist
    WHERE album_artist.artistID = old.artistID
  );

END;

CREATE TABLE users
(
  userID       int         NOT NULL,
  name         varchar(20) NOT NULL,
  email        varchar(50) NULL,
  premium      tinyint(1)  NULL,
  created_date date        NULL,
  CONSTRAINT users_email_uindex
    UNIQUE (email),
  CONSTRAINT users_name_uindex
    UNIQUE (name),
  CONSTRAINT users_userID_uindex
    UNIQUE (userID)
);

ALTER TABLE users
  ADD PRIMARY KEY (userID);

CREATE TABLE user_playlists
(
  userID     int NOT NULL,
  playlistID int NOT NULL,
  CONSTRAINT user_playlists_playlist_playlistID_fk
    FOREIGN KEY (playlistID) REFERENCES playlist (playlistID)
      ON DELETE CASCADE,
  CONSTRAINT user_playlists_users_userID_fk
    FOREIGN KEY (userID) REFERENCES users (userID)
      ON DELETE CASCADE
);


