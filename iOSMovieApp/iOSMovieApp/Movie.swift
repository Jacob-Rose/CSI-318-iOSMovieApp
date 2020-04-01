//
//  Movie.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/18/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit


class TMDBAPI
{
    public static let shared = TMDBAPI();
    
    private init() {}
    
    //Hello whoever is looking at this amazing api key. They are completely free from The Movie Database after creating an account and applying and I ask kindly for you to not use this one. However if it is used i can reset it rather easily.
    //of course David, you can use mine to test
    let apiKey: String = "a4e722f09fd2244b040453e17da4700a"
     
   
    
    func loadMovieImage(url: String) -> UIImage?
    {
        let imageURL: String = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: imageURL + url)
        if let data: Data = try? Data(contentsOf: url!)
        {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getPopular(page: Int) -> [Movie]
    {
        let discoverURL: String = "https://api.themoviedb.org/3/discover/movie" + "?api_key=" + apiKey + "&page=" + String(page)
        let url = URLComponents(string: discoverURL)
        if let url = url?.url{
            if let data = try? Data(contentsOf: url)
            {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonObj: MovieResult = try? jsonDecoder.decode(MovieResult.self, from: data)
                {
                    return jsonObj.results
                }
            }
        }
        
        return [Movie]()
    }
    
    func getFavoriteMovies() -> [Movie]
    {
        var movies: [Movie] = [Movie]()
        if let favIDs: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int]
        {
            for movieID in favIDs
            {
                if let movie = getMovieFromID(movieID: movieID)
                {
                    movies.append(movie)
                }
            }
        }
        return movies
    }
    
    func addMovieToFavorites(movieID: Int)
    {
        if var favIDs: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int]
        {
            if !favIDs.contains(movieID)
            {
                favIDs.append(movieID)
                UserDefaults.standard.set(favIDs, forKey: "Favorites")
            }
        }
    }
    
    func removeMovieFromFavorites(movieID: Int)
    {
        if var favIDs: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int]
        {
            favIDs=favIDs.filter{ $0 != movieID}
            UserDefaults.standard.set(favIDs, forKey: "Favorites")
        }
    }
    
    func isMovieFavorited(movieID: Int) -> Bool{
        if let favIDs: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int]
        {
            return favIDs.contains(movieID)
        }
        else
        {
            UserDefaults.standard.set([Int](), forKey: "Favorites")
        }
        return false
    }
    
    func getMoviesFromSearch(query: String, page: Int) -> [Movie]
    {
        let searchURL: String = "https://api.themoviedb.org/3/search/movie?api_key=" + apiKey + "&query=" + query + "&page=" + String(page)
        let url = URLComponents(string: searchURL)
        if let url = url?.url{
            if let data = try? Data(contentsOf: url)
            {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonObj: MovieResult = try? jsonDecoder.decode(MovieResult.self, from: data)
                {
                    return jsonObj.results
                }
            }
        }
        
        return [Movie]()
    }
    
    func getMovieFromID(movieID: Int) -> Movie?
    {
        let movieURL: String = "https://api.themoviedb.org/3/movie/" + String(movieID) + "?api_key=" + apiKey + "&append_to_response=videos"
        let url = URLComponents(string: movieURL)
        if let url = url?.url{
            if let data = try? Data(contentsOf: url)
            {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonObj: Movie = try? jsonDecoder.decode(Movie.self, from: data)
                {
                    return jsonObj
                }
                if let jsonObj: MovieResult = try?  jsonDecoder.decode(MovieResult.self, from: data) //sometimes comes as this?
                {
                    return jsonObj.results[0];
                }
            }
        }
        return nil
    }
}

//MARK:Structs

public struct MovieResult: Codable {
    
    public var page: Int?
    public var id: Int?
    public var totalResults: Int?
    public var totalPages: Int?
    public var results: [Movie]
}
public struct Movie: Codable {
    
    public var id: Int
    public var title: String
    public var overview: String?
    public var releaseDate: String?
    public var voteAverage: Double?
    public var voteCount: Int?
    public var adult: Bool?
    public var posterPath: String?
    public var backdropPath: String?
    public var videos: VideoResults?
}

public struct VideoResults : Codable
{
    public var results: [VideoLink]
}

public struct VideoLink: Codable
{
    public var key: String
    public var site: String
}
