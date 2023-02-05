//
//  TrantorViewModel.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

final class TrantorViewModel:ObservableObject {
    let persistence = ModelPersistence()
    
    @Published var trantorBooks:[TrantorBooks]
    @Published var trantorAuthors:[TrantorAuthors]
    
    init() {
        self.trantorBooks = persistence.loadTrantorBooks()
        self.trantorAuthors = persistence.loadTrantorAuthors()
    }
}

