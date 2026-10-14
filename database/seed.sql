-- Data Awal untuk Sponify

INSERT INTO users (username, email, password) VALUES
('demo_user', 'demo@sponify.com', 'password123'),
('test_user', 'test@sponify.com', 'password123');

INSERT INTO artists (name, image_url) VALUES
('The Coding Beats', 'https://picsum.photos/seed/artist1/300'),
('Lo-Fi Chill', 'https://picsum.photos/seed/artist2/300'),
('Synthwave Rider', 'https://picsum.photos/seed/artist3/300');

INSERT INTO albums (artist_id, title, cover_url, release_year) VALUES
(1, 'Debugging Sessions', 'https://picsum.photos/seed/album1/400', 2024),
(2, 'Study Vibes', 'https://picsum.photos/seed/album2/400', 2023),
(3, 'Neon Nights', 'https://picsum.photos/seed/album3/400', 2025);

INSERT INTO songs (album_id, title, duration, audio_url) VALUES
(1, 'Null Pointer Exception', 180, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
(1, 'Stack Overflow', 210, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
(1, 'Git Commit', 195, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'),
(2, 'Coffee Break', 240, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'),
(2, 'Late Night Coding', 200, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3'),
(2, 'Rainy Day', 220, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3'),
(3, 'Neon Highway', 185, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3'),
(3, 'Retro Wave', 205, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3'),
(3, 'Cyberpunk City', 190, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3'),
(3, 'Digital Dream', 215, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3');

INSERT INTO playlists (user_id, name, description) VALUES
(1, 'My Favorite', 'Kumpulan lagu favorit saya'),
(2, 'Workout Mix', 'Lagu buat olahraga');

INSERT INTO playlist_songs (playlist_id, song_id) VALUES
(1, 1), (1, 4), (1, 7),
(2, 2), (2, 5), (2, 8);

INSERT INTO liked_songs (user_id, song_id) VALUES
(1, 1), (1, 2), (1, 7),
(2, 4), (2, 5);