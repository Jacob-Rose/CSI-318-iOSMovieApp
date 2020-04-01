//
//  NoteDetailViewController.swift
//  iOSMovieApp
//
//  Created by user167502 on 3/31/20.
//  Copyright © 2020 jakerose. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!
    
    public var note: MovieNote? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    @IBAction func deleteButtonPresse(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete?", message:"Are you sure you want to delete this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.deleteNote()
            self.note = nil
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func deleteNote()
    {
        if let note: MovieNote = note
        {
            NoteManager.shared.removeUserNoteForMovie(movieID: note.movieID)
        }
    }
    func reload()
    {
        if let note: MovieNote = note
        {
            if let noteTitleTextField: UITextField = noteTitleTextField
            {
                noteTitleTextField.text = note.title
            }
            if let noteContentTextView: UITextView = noteContentTextView
            {
                noteContentTextView.text = note.content
            }
        }
    }
    
    func save()
    {
        if let note: MovieNote = note
        {
            if let noteTitleTextField: UITextField = noteTitleTextField
            {
                if let title = noteTitleTextField.text
                {
                    note.title = title
                }
            }
            if let noteContentTextView: UITextView = noteContentTextView
            {
                if let content = noteContentTextView.text
                {
                    note.content = content
                }
            }
            NoteManager.shared.saveUserNoteForMovie(movieNote: note)
        }
    }
}
