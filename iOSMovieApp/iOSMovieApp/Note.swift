//
//  Note.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/31/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit

class MovieNote: NSObject {
    var title: String = ""
    var content: String = ""
    var movie: Movie
    
    init(_ m: Movie)
    {
        self.movie = m
    }
}
