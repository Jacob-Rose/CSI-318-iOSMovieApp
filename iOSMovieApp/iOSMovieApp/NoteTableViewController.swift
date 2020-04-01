//
//  NoteTableViewController.swift
//  iOSMovieApp
//
//  Created by user167502 on 4/1/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell
{
    
}

class NoteTableViewController: UITableViewController {

    var movieNotes: [MovieNote] = [MovieNote]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieNotes = NoteManager.shared.getAllUserNotes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieNotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)

        // Configure the cell...
        var cellTitle:String  = movieNotes[indexPath.row].title
        let note = movieNotes[indexPath.row]
        if let movieTitle = TMDBAPI.shared.getMovieFromID(movieID: note.movieID)?.title
        {
            cellTitle = cellTitle + " | " + movieTitle
        }
        cell.textLabel?.text = cellTitle

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showNote"
        {
            let indexPath = tableView.indexPathForSelectedRow!
            if let dest = segue.destination as? NoteDetailViewController
            {
                dest.note = movieNotes[indexPath.row]
            }
        }
    }
    

}
