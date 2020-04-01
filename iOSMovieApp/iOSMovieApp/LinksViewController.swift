//
//  LinksViewController.swift
//  iOSMovieApp
//
//  Created by user167502 on 4/1/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit

class LinksViewController: UIViewController {

    @IBAction func majesticPressed(_ sender: Any) {
        guard let url = URL(string: "http://www.majestic10.com/") else { return }
        openLink(url: url)
    }
    @IBAction func roxysPressed(_ sender: Any) {
        guard let url = URL(string: "http://merrilltheatres.net/showtimes.html") else { return }
        openLink(url: url)
    }
    @IBAction func whereToWatchPressed(_ sender: Any) {
        guard let url = URL(string: "https://www.justwatch.com/us") else { return }
               openLink(url: url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //https://stackoverflow.com/questions/25945324/swift-open-link-in-safari
    func openLink(url: URL)
    {
        UIApplication.shared.open(url)
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
