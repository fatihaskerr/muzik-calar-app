import Foundation

struct Song: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String      // Ekranda gözüken isim
    let fileName: String  // Gerçek dosya ismi (uzantısız)
    let imageName: String // albüm kapağı adı
    var isFavorite: Bool = false

    static let sampleSongs = [
        Song(name: "Boşu Boşuna - Hiraız Erdüş", fileName: "bosu_bosuna_clean", imageName: "bosu_bosuna"),
        Song(name: "Bekleyenim - Aleyna Tilki", fileName: "bekleyenim_clear", imageName: "bekleyenim"),
        Song(name: "Lan - Zeynep Bastık", fileName: "zeynepbastik_lan", imageName: "zeynepbastik_lan"),
        Song(name: "Emrah Karaduman & Merve Özbey - Bir İmkansız Var", fileName: "imkansiz_var", imageName: "imkansiz_var"),
        Song(name: "Halodayı & Azer Bülbül - Aman Güzel Yavaş Yürü", fileName: "amanguzelyavasyuru", imageName: "amanguzelyavasyuru")
    ]
}
