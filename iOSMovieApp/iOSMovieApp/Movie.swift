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
    
    let apiKey: String = "a4e722f09fd2244b040453e17da4700a"
    let startURL: String = "https://www.api.themoviedb.org/3/"
    let imageURL: String = "https://image.tmdb.org/t/p/w500"
    let youtubeURL: String = "https://www.youtube.com/embed/"
    
    public var loadedMovies: Array<Movie> = Array<Movie>() //only used because i cannot use TMDB currently
    
    func loadMovieImage(url: String) -> UIImage?
    {
        let url = URL(string: imageURL + url)
        if let data: Data = try? Data(contentsOf: url!)
        {
            return UIImage(data: data)
        }
        return nil
    }
    
    //Not Working
    func getPopular() -> [Movie]
    {
        let discoverURLStr = String(startURL + "discover/movie?apikey=" + apiKey + "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")
        let url = URL(string: discoverURLStr)
        if let url: URL = url{
            if let data: Data = try? Data(contentsOf: url)
            {
                let jsonDecoder = JSONDecoder()
                //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonObj: MoviesResponse = try? jsonDecoder.decode(MoviesResponse.self, from: data)
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
                if let movie = getMovieFromIDLocal(movieID: movieID)
                {
                    movies.append(movie)
                }
            }
        }
        return movies
    }
    
    func loadPopularLocal()
    {
        if let path = Bundle.main.path(forResource: "popular-movies", ofType: "json")
        {
            if let dataString = try? String(contentsOfFile: path, encoding: .utf8)
            {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = try? dataString.data(using: .utf8)
                {
                    if let jsonObj: MoviesResponse = try? jsonDecoder.decode(MoviesResponse.self, from: data)
                    {
                        loadedMovies.append(contentsOf: jsonObj.results)
                    }
                }
            }
        }
    }
    
    func loadMovieLocal(url: String)
    {
        if let data:String = try? String(contentsOfFile: url, encoding: .utf8)
        {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            if let jsonObj: Movie = try? jsonDecoder.decode(Movie.self, from: data.data(using: .utf8)!)
            {
                loadedMovies.append(jsonObj)
            }
        }
    }
    
    func loadMovieListLocal()
    {
        if let path = Bundle.main.path(forResource: "movie-list", ofType: "txt")
        {
            if let movieList = try? String(contentsOfFile: path, encoding: .utf8).split(separator: "\n")
            {
                for movieFile in movieList
                {
                    if let moviePath = Bundle.main.path(forResource: String(movieFile), ofType: "json")
                    {
                        loadMovieLocal(url: moviePath)
                    }
                }
            }
        }
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
        if var favIDs: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int]
        {
            return favIDs.contains(movieID)
        }
        else
        {
            UserDefaults.standard.set([Int](), forKey: "Favorites")
        }
        return false
    }
    
    func getMovieFromIDLocal(movieID: Int) -> Movie?
    {
        for movie in loadedMovies
        {
            if movie.id == movieID
            {
                return movie
            }
        }
        return nil
    }
}

 

public struct MoviesResponse: Codable {
    
    public var page: Int
    public var totalResults: Int
    public var totalPages: Int
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
    public var posterPath: String
    public var backdropPath: String
    public var videos: [MovieVideoLink]?
}

public struct MovieVideoLink: Codable
{
    public var key: String
    public var site: String
}
