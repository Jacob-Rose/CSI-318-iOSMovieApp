//
//  MovieDetailViewController.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/28/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit
import MapKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieCoverImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var movieTheaterMap: MKMapView!
    
    
    let favoriteOn: UIImage? = try? UIImage(systemName: "star.fill")
    let favoriteOff: UIImage? = try? UIImage(systemName: "star")
    
    private var movie:Movie? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reload();
        // Do any additional setup after loading the view.
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        //if in favorites, remove, else then add and replace image
        if let movie = movie{
            if TMDBAPI.shared.isMovieFavorited(movieID: movie.id)
            {
                TMDBAPI.shared.removeMovieFromFavorites(movieID: movie.id)
            }
            else
            {
                TMDBAPI.shared.addMovieToFavorites(movieID: movie.id)
            }
        }
        reload()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    public func setMovie(newMovie: Movie){
        movie = newMovie;
        
    }
    
    public func reload()
    {
        if let movie: Movie = movie{
            if let image:UIImage = TMDBAPI.shared.loadMovieImage(url: movie.posterPath)
            {
                movieCoverImageView.image = image
            }
            if let favoriteButton: UIButton = favoriteButton
            {
                if TMDBAPI.shared.isMovieFavorited(movieID: movie.id)
                {
                    favoriteButton.setBackgroundImage(favoriteOn!, for: .normal)
                }
                else{
                    favoriteButton.setBackgroundImage(favoriteOff!, for: .normal)
                }
            }
            if let movieTheaterMap: MKMapView = movieTheaterMap
            {
                //movieTheaterMap.set
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
