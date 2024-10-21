//
//  TranslationTransaction.swift
//  Project6_TranslationMe
//
//  Created by David Perez on 10/19/24.
//

import Foundation

struct TranslationTransaction: Identifiable {
    var id = UUID()
    var nonTranslated = ""
    var translated = ""
}
