import SwiftUI

struct SongListView: View {
    @ObservedObject var viewModel: MusicPlayerViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var filteredSongs: [Song] {
        if searchText.isEmpty {
            return viewModel.songs
        } else {
            return viewModel.songs.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            // 🔍 Arama Çubuğu
            TextField("Şarkı ara...", text: $searchText)
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)

            // 🎵 Şarkı Grid'i
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredSongs.indices, id: \.self) { i in
                        let song = filteredSongs[i]
                        let isCurrent = viewModel.songs.firstIndex(of: song) == viewModel.currentSongIndex

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

                                HStack(spacing: 6) {
                                    Button(action: {
                                        viewModel.toggleFavorite(for: song)
                                    }) {
                                        Image(systemName: song.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(song.isFavorite ? .yellow : .white.opacity(0.5))
                                    }
                                    .buttonStyle(BorderlessButtonStyle())

                                    if isCurrent {
                                        Image(systemName: "waveform")
                                            .foregroundColor(.green)
                                    }
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
        .background(
            LinearGradient(colors: [Color.purple.opacity(0.9), Color.blue.opacity(0.9)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationTitle("🎵 Şarkı Kartları")
        .navigationBarTitleDisplayMode(.inline)
    }
}
