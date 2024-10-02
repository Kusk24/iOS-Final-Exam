//
//  Movie_Fetching.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import Foundation
import Alamofire

// Define MovieResponse struct that conforms to Codable
struct MovieResponse: Codable {
    let movies: [Movie]
}

// Define Movie struct that conforms to Codable
struct Movie: Codable {
    let poster_url: String?
    let title_en: String?
    let release_date: String?
    let genre: String?
    let now_showing: String? // Optional since it can be "" or missing
    let widescreen_url: String? // Correct field for widescreen URL
    let duration: Int? // Movie duration in minutes
    let synopsis_en: String? // English synopsis
    let tr_mp4: String? // Trailer in MP4 format

    // Map keys from the JSON to the struct properties
    enum CodingKeys: String, CodingKey {
        case poster_url = "poster_url"
        case title_en = "title_en"
        case release_date = "release_date"
        case genre = "genre"
        case now_showing = "now_showing"
        case widescreen_url = "widescreen_url"
        case duration = "duration"
        case synopsis_en = "synopsis_en"
        case tr_mp4 = "tr_mp4"
    }
}

// Function to fetch movies from the API
func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
    let url = "https://www.majorcineplex.com/apis/get_movie_avaiable"
    
    // Make a network request using Alamofire to fetch movie data
    AF.request(url).responseDecodable(of: MovieResponse.self) { response in
        switch response.result {
        case .success(let movieResponse):
            // Pass the array of movies to the completion handler if successful
            completion(.success(movieResponse.movies))
        case .failure(let error):
            // Pass the error to the completion handler if the request fails
            completion(.failure(error))
        }
    }
}
