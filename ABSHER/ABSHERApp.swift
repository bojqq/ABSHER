//
//  ABSHERApp.swift
//  ABSHER
//
//  Created by Ilyas MacBook Pro on 03/06/1447 AH.
//

import SwiftUI

@main
struct ABSHERApp: App {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .preferredColorScheme(.dark)
        }
    }
}
