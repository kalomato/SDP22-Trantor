//
//  ContentView.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var trantorVM = TrantorViewModel()
    
    var body: some View {
        List(trantorVM.trantorBooks) { books in
            Text(books.title)
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
