import SwiftUI

struct FavoriteSongsView: View {
    @ObservedObject var viewModel: MusicPlayerViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var favoriteSongs: [Song] {
        viewModel.songs.filter { $0.isFavorite }
    }

    var filteredFavorites: [Song] {
        if searchText.isEmpty {
            return favoriteSongs
        } else {
            return favoriteSongs.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            // 🔍 Arama kutusu
            TextField("Favorilerde ara...", text: $searchText)
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)

            if filteredFavorites.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "star.slash.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.4))
                    Text("Favori şarkınız bulunamadı.")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.subheadline)
                }
                .padding(.top, 60)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredFavorites, id: \.id) { song in
                            let isCurrent = song == viewModel.currentSong

                            Button(action: {
                                if let index = viewModel.songs.firstIndex(of: song) {
                                    viewModel.currentSongIndex = index
                                    viewModel.playCurrentSong()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Image(song.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 140, height: 140)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))

                                    Text(song.name)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .foregroundColor(.white)

                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)

                                    if isCurrent {
                                        Image(systemName: "waveform")
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.05))
                                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
        .background(
            LinearGradient(colors: [Color.purple.opacity(0.9), Color.blue.opacity(0.9)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationTitle("⭐ Favori Şarkılar")
        .navigationBarTitleDisplayMode(.inline)
    }
}
