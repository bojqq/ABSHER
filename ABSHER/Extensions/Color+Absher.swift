import SwiftUI

extension Color {
    // Background Colors
    static let absherBackground = Color(hex: "#1C1C1E")
    static let absherCardBackground = Color(hex: "#2C2C2E")
    static let absherCardBorder = Color(hex: "#3C3C3E")
    
    // Accent Colors
    static let absherGreen = Color(hex: "#4CAF50")
    static let absherLightGreen = Color(hex: "#8BC34A")
    static let absherMint = Color(hex: "#A8E6CF")
    static let absherPurple = Color(hex: "#7C4DFF")
    static let absherOrange = Color(hex: "#FF9500")
    
    // Text Colors
    static let absherTextPrimary = Color.white
    static let absherTextSecondary = Color(hex: "#8E8E93")
    static let absherTextMuted = Color(hex: "#636366")
    
    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
