//
//  TranslationVM.swift
//  Project6_TranslationMe
//
//  Created by David Perez on 10/19/24.
//

import Foundation

class TranslationVM: ObservableObject {
    @Published var savedTranslation: [TranslationTransaction] = []
    
    func getTranslation(translate: String) async -> String {
        // Encode the query string to handle special characters
        let query = translate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? translate
        let urlString = "https://api.mymemory.translated.net/get?q=\(query)&langpair=en|es"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return ""
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // GET is more appropriate for this API

        do {
            // Await the result of the data task
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Parse the JSON response
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let responseData = json["responseData"] as? [String: Any],
               let translatedText = responseData["translatedText"] as? String {
                savedTranslation.append(TranslationTransaction(nonTranslated: translate, translated: translatedText))
                return translatedText
            } else {
                print("Failed to find translatedText in response")
                return ""
            }
        } catch {
            print("Error fetching or parsing translation: \(error)")
            return ""
        }
    }
}
