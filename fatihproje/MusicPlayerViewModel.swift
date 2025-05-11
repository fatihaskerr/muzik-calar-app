import Foundation
import AVFoundation

class MusicPlayerViewModel: ObservableObject {
    var player: AVAudioPlayer?

    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var currentSongIndex = 0
    @Published var songs: [Song] = Song.sampleSongs
    @Published var songDuration: TimeInterval = 0
    @Published var volume: Float = 1.0
    var timer: Timer?
    @Published var isShuffleEnabled = false
    private var shuffledIndices: [Int] = []
    private var shuffleIndex = 0


    var currentSong: Song {
        songs[currentSongIndex]
    }

    // MARK: - INIT: Favorileri yükle
    init() {
        loadFavorites()
    }

    func playCurrentSong() {
        playSound(named: currentSong.fileName)
    }

    func playSound(named fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") {
            print("✅ Dosya bulundu: \(url)")
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                player?.volume = volume
                player?.play()
                isPlaying = true
                self.songDuration = self.player?.duration ?? 0
                startTimer()
            } catch {
                print("❌ Oynatma hatası: \(error.localizedDescription)")
            }
        } else {
            print("❌ Şarkı bulunamadı: \(fileName).m4a")
        }
    }

    func playPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopTimer()
        } else {
            player.play()
            isPlaying = true
            startTimer()
        }
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
        stopTimer()
    }

    func forward(seconds: TimeInterval) {
        guard let player = player else { return }
        player.currentTime = min(player.currentTime + seconds, player.duration)
    }

    func rewind(seconds: TimeInterval) {
        guard let player = player else { return }
        player.currentTime = max(player.currentTime - seconds, 0)
    }

    func nextSong() {
        if isShuffleEnabled {
            if shuffledIndices.isEmpty || shuffleIndex >= shuffledIndices.count {
                shuffledIndices = songs.indices.shuffled()
                shuffleIndex = 0
            }
            currentSongIndex = shuffledIndices[shuffleIndex]
            shuffleIndex += 1
        } else {
            currentSongIndex = (currentSongIndex + 1) % songs.count
        }
        playCurrentSong()
    }

    func previousSong() {
        if isShuffleEnabled {
            if shuffledIndices.isEmpty || shuffleIndex <= 1 {
                // Shuffle listesi yoksa ya da başa geldiyse, sondan başla
                shuffledIndices = songs.indices.shuffled()
                shuffleIndex = shuffledIndices.count
            }
            shuffleIndex = max(0, shuffleIndex - 2)
            currentSongIndex = shuffledIndices[shuffleIndex]
            shuffleIndex += 1
        } else {
            currentSongIndex = (currentSongIndex - 1 + songs.count) % songs.count
        }
        playCurrentSong()
    }


    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentTime = self.player?.currentTime ?? 0
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - FAVORİLER

    func toggleFavorite(for song: Song) {
        if let index = songs.firstIndex(of: song) {
            songs[index].isFavorite.toggle()
            saveFavorites()
        }
    }

    func saveFavorites() {
        let favorites = songs.map { $0.isFavorite }
        UserDefaults.standard.set(favorites, forKey: "favoriteStatuses")
    }

    func loadFavorites() {
        if let statuses = UserDefaults.standard.array(forKey: "favoriteStatuses") as? [Bool],
           statuses.count == songs.count {
            for i in songs.indices {
                songs[i].isFavorite = statuses[i]
            }
        }
    }
}
