//
//  OnboardingService.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

// MARK: - OnboardingService
class OnboardingService {
    static func loadOnboardingData(completion: @escaping (OnboardingData?) -> Void) {
        let urlString = "https://test-ios.universeapps.limited/onboarding"
        
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error: empty response from server")
                completion(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(OnboardingData.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
