//
//  Cinema_Fetching.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import Foundation
import Alamofire
// Define CinemaResponse struct that conforms to Codable
struct CinemaResponse: Codable {
    let cinemas: [Cinema]
}

// Define Cinema struct that conforms to Codable
struct Cinema: Codable {
    let cinema_name_en: String?
    let zone_name_en: String?
    let brand_name_en: String?
    let cinema_tel: String?
    let cinema_content_main: String? // HTML content for main description
    let cinema_office_hour_en: String? // Office hours in English

    // Map keys from the JSON to the struct properties
    enum CodingKeys: String, CodingKey {
        case cinema_name_en = "cinema_name_en"
        case zone_name_en = "zone_name_en"
        case brand_name_en = "brand_name_en"
        case cinema_tel = "cinema_tel"
        case cinema_content_main = "cinema_content_main"
        case cinema_office_hour_en = "cinema_office_hour_en"
    }
}

// Function to fetch cinemas from the API
func fetchCinemas(completion: @escaping (Result<[Cinema], Error>) -> Void) {
    let url = "https://www.majorcineplex.com/apis/get_cinema"
    
    // Make a network request using Alamofire to fetch cinema data
    AF.request(url).responseDecodable(of: CinemaResponse.self) { response in
        switch response.result {
        case .success(let cinemaResponse):
            // Pass the array of cinemas to the completion handler if successful
            completion(.success(cinemaResponse.cinemas))
        case .failure(let error):
            // Pass the error to the completion handler if the request fails
            completion(.failure(error))
        }
    }
}
