//
//  TrantorApp.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

@main
struct TrantorApp: App {
    @StateObject var booksVM = BooksViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environmentObject(booksVM)
        }
    }
}
