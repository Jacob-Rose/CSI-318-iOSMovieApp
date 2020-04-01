//
//  Note.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/31/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit

class NoteManager
{
    public static let shared = NoteManager();
    
    private init() {}
    
    public func getUserNoteForMovie(movieID: Int) -> MovieNote?
    {
        if let noteData: Data = UserDefaults.standard.data(forKey: String(movieID))
        {
            if let movieNote: MovieNote = try? JSONDecoder().decode(MovieNote.self, from: noteData)
            {
                return movieNote
            }
        }
        return nil
    }
    
    public func saveUserNoteForMovie(movieNote: MovieNote)
    {
        if let jsonString = try? JSONEncoder().encode(movieNote)
        {
            UserDefaults.standard.set(jsonString, forKey: String(movieNote.movieID))
            if var movieNoteList: [Int] = UserDefaults.standard.array(forKey: "MovieNoteList") as? [Int]
            {
                if !movieNoteList.contains(movieNote.movieID)
                {
                    movieNoteList.append(movieNote.movieID)
                }
                UserDefaults.standard.set(movieNoteList, forKey: "MovieNoteList")
            }
            else
            {
                UserDefaults.standard.set([Int](), forKey: "MovieNoteList")
            }
        }
    }
    
    public func removeUserNoteForMovie(movieID: Int)
    {
        UserDefaults.standard.removeObject(forKey: String(movieID))
        if var movieNoteList: [Int] = UserDefaults.standard.array(forKey: "MovieNoteList") as? [Int]
        {
            movieNoteList = movieNoteList.filter {$0 != movieID}
            UserDefaults.standard.set(movieNoteList, forKey: "MovieNoteList")
        }
    }
    
    public func getAllUserNotes() -> [MovieNote]
    {
        var movieNotes: [MovieNote] = [MovieNote]()
        if let movieNoteList: [Int] = UserDefaults.standard.array(forKey: "MovieNoteList") as? [Int]
        {
            for movieID in movieNoteList
            {
                if let note = getUserNoteForMovie(movieID: movieID)
                {
                    movieNotes.append(note)
                }
            }
        }
        return movieNotes
    }
}

class MovieNote: Codable {
    var title: String = ""
    var content: String = ""
    var movieID: Int = 0;
}
