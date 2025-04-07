//
//  OnboardingService.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(Error)
    case emptyResponse
    case decodingError(Error)
}

// MARK: - OnboardingService
class OnboardingService {
    static let onboardingPath = "\(Environment.baseURL)/onboarding"
    
    static func loadOnboardingData() async throws -> OnboardingData {
        guard let url = URL(string: onboardingPath) else {
            print("Error: Invalid URL")
            throw NetworkError.invalidURL
        }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard !data.isEmpty else {
                    print("Error: empty response from server")
                    throw NetworkError.emptyResponse
                }
                
                let decodedData = try JSONDecoder().decode(OnboardingData.self, from: data)
                return decodedData
                
            } catch let decodingError as DecodingError {
                print("Error parsing JSON: \(decodingError)")
                throw NetworkError.decodingError(decodingError)
            } catch {
                print("Error loading data: \(error.localizedDescription)")
                throw NetworkError.serverError(error)
            }
        }
}
