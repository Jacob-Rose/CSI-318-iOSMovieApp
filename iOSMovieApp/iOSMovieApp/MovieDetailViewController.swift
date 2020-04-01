//
//  MovieDetailViewController.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/28/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit
import WebKit

//https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

//https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
extension UIColor
{
    //https://old.kristofk.com/extracting-rgb-values-from-uicolor/
     public func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red:fRed, green:fGreen, blue:fBlue, alpha:fAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    public func isLight() -> Bool {
        let rgb = self.rgb()
        if let rgb = rgb
        {
            let r = rgb.red
            let g = rgb.green
            let b = rgb.blue
            let brightness: CGFloat = ((r * 299.0) + (g * 587.0) + (b * 114.0))/1000;
            if brightness > 0.5
            {
                return true
            }
            else
            {
                return false
            }
        }
        return true
    }
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieCoverImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    @IBOutlet weak var movieTrailerWebView: WKWebView!
    
    
    @IBOutlet weak var addNoteButton: UIButton!
    
    @IBAction func addNotePressed(_ sender: Any) {
        performSegue(withIdentifier: "showNote", sender: self)
        
    }
    let favoriteOn: UIImage? = UIImage(systemName: "star.fill")
    let favoriteOff: UIImage? = UIImage(systemName: "star")
    
    private var movie:Movie? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showNote" {
            if let viewController = segue.destination as? NoteDetailViewController
            {
                if let movie: Movie = movie{
                    if let note: MovieNote = NoteManager.shared.getUserNoteForMovie(movieID: movie.id)
                    {
                        viewController.note = note
                    }
                    else
                    {
                        let movieNote: MovieNote = MovieNote()
                        movieNote.movieID = movie.id
                        viewController.note = movieNote
                    }
                }
            }
        }
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
        movie = TMDBAPI.shared.getMovieFromID(movieID: newMovie.id); //reload to get video links
    }
    
    public func reload()
    {
        if let movie: Movie = movie{
            if let image:UIImage = TMDBAPI.shared.loadMovieImage(url: movie.posterPath)
            {
                movieCoverImageView.image = image
                if let color = image.averageColor
                {
                    view.backgroundColor = color
                }
            }
            if let movieTrailerWebView: WKWebView = movieTrailerWebView
            {
                if let videos = movie.videos
                {
                    for video in videos.results
                    {
                        if video.site == "YouTube"
                        {
                            let youtubeURL: String = "https://www.youtube.com/embed/"
                            if let url = URL(string: youtubeURL + video.key)
                            {
                                movieTrailerWebView.load(URLRequest(url: url))
                                break
                            }
                        }
                    }
                    
                }
               
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
            
            if let movieTitleLabel: UILabel = movieTitleLabel
            {
                movieTitleLabel.text = movie.title
                if let bColor = view.backgroundColor
                {
                    movieTitleLabel.textColor = bColor.isLight() ? UIColor.black : UIColor.white
                }
                
            }
            
            if let movieDescriptionLabel: UILabel = movieDescriptionLabel
            {
                if let overview: String = movie.overview
                {
                    movieDescriptionLabel.text = overview
                }
                if let bColor = view.backgroundColor
                {
                    movieTitleLabel.textColor = bColor.isLight() ? UIColor.black : UIColor.white
                }
            }
            
            if let _: MovieNote = NoteManager.shared.getUserNoteForMovie(movieID: movie.id)
            {
                addNoteButton.setTitle("Edit Note", for: .normal)
            }
            else
            {
                addNoteButton.setTitle("Add Note", for: .normal)
            }
        }
    }
}
