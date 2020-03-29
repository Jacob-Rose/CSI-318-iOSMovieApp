//
//  MovieTableViewController.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/18/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell
{
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
}

class MovieTableViewController: UITableViewController {

    var movies: Array<Movie> = Array<Movie>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80

        TMDBAPI.shared.loadPopularLocal()
        movies = TMDBAPI.shared.loadedMovies
        //movies.append(contentsOf: TMDBAPI.shared.getPopular2())
    }

    // MARK: - Table view data source
    
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    //https://stackoverflow.com/questions/28430663/send-data-from-tableview-to-detailview-swift
    var valueToPass:Movie!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueToPass = movies[indexPath.row]
        performSegue(withIdentifier: "movieDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if (segue.identifier == "movieDetail") {
            // initialize new view controller and cast it as your view controller
            guard let movie = valueToPass else{
                return
            }
            if let viewController = segue.destination as? MovieDetailViewController
            {
                viewController.setMovie(newMovie: movie)
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        if let image: UIImage = TMDBAPI.shared.loadMovieImage(url: movies[indexPath.row].posterPath)
        {
            cell.movieImage.image = image
            cell.movieTitle.text = movies[indexPath.row].title
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
