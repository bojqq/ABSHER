//
//  UserProfile.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

struct UserProfile {
    let name: String
    let idNumber: String
    let profileImage: String?
    
    static let mock = UserProfile(
        name: "إلياس محمد ناصر البدوي الغامدي",
        idNumber: "١١٢٩٣٤٥١٩٣",
        profileImage: "Me.png"
    )
}
