import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MusicPlayerViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // 🌌 Arka Plan - Gradient
                LinearGradient(colors: [Color.purple.opacity(0.9), Color.blue.opacity(0.9)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // 🧭 Başlık ve Liste Butonları
                    HStack(spacing: 12) {
                        Text("🎧 Müzik Çalar")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        // ⭐ Favoriler
                        NavigationLink(destination: FavoriteSongsView(viewModel: viewModel)) {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }

                        // 📂 Şarkı Listesi
                        NavigationLink(destination: SongListView(viewModel: viewModel)) {
                            Image(systemName: "music.note.list")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)

                    // 🎵 Albüm Kapağı
                    Image(viewModel.currentSong.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 3))
                        .shadow(radius: 10)

                    // 🔀 Shuffle Bilgisi
                    if viewModel.isShuffleEnabled {
                        Text("Karışık mod açık")
                            .font(.caption)
                            .foregroundColor(.yellow)
                            .transition(.opacity)
                            .animation(.easeInOut, value: viewModel.isShuffleEnabled)
                    }

                    // 🎵 Şarkı Adı + Favori
                    HStack(spacing: 8) {
                        Text(viewModel.currentSong.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        Button(action: {
                            viewModel.toggleFavorite(for: viewModel.currentSong)
                        }) {
                            Image(systemName: viewModel.currentSong.isFavorite ? "star.fill" : "star")
                                .foregroundColor(viewModel.currentSong.isFavorite ? .yellow : .white.opacity(0.6))
                                .font(.title3)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.horizontal)

                    // ⏱️ Zaman Çubuğu
                    VStack(spacing: 6) {
                        Slider(value: Binding(
                            get: { viewModel.currentTime },
                            set: { newValue in
                                viewModel.currentTime = newValue
                                viewModel.player?.currentTime = newValue
                            }
                        ), in: 0...max(viewModel.songDuration, 1))
                        .accentColor(.white)

                        HStack {
                            Text(formatTime(viewModel.currentTime))
                            Spacer()
                            Text(formatTime(viewModel.songDuration))
                        }
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal)

                    // 🎮 Oynatma Kontrolleri
                    HStack(spacing: 30) {
                        Button(action: { viewModel.previousSong() }) {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 30))
                        }

                        Button(action: {
                            viewModel.isPlaying ? viewModel.playPause() : viewModel.playCurrentSong()
                        }) {
                            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                        }

                        Button(action: { viewModel.nextSong() }) {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: 30))
                        }

                        Button(action: {
                            viewModel.isShuffleEnabled.toggle()
                        }) {
                            Image(systemName: viewModel.isShuffleEnabled ? "shuffle.circle.fill" : "shuffle.circle")
                                .font(.system(size: 28))
                                .foregroundColor(viewModel.isShuffleEnabled ? .yellow : .white.opacity(0.6))
                        }
                        .accessibilityLabel("Karışık Çalma")
                    }
                    .foregroundColor(.white)

                    // ⏩ 10sn ileri/geri
                    HStack(spacing: 30) {
                        Button(action: { viewModel.rewind(seconds: 10) }) {
                            Label("10sn Geri", systemImage: "gobackward.10")
                        }
                        Button(action: { viewModel.forward(seconds: 10) }) {
                            Label("10sn İleri", systemImage: "goforward.10")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                    // 🔊 Ses Kontrolü
                    VStack(spacing: 4) {
                        Text("🔊 Ses Seviyesi")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))

                        Slider(value: Binding(
                            get: { Double(viewModel.volume) },
                            set: { newValue in
                                viewModel.volume = Float(newValue)
                                viewModel.player?.volume = Float(newValue)
                            }
                        ), in: 0.0...1.0)
                        .accentColor(.white)
                    }
                    .padding(.horizontal)

                    // ⏹️ Durdur Butonu
                    Button(action: {
                        viewModel.stop()
                    }) {
                        Text("⏹️ Durdur")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 20)
                }
                .padding(.top, 30)
            }
            .navigationBarHidden(true)
        }
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
