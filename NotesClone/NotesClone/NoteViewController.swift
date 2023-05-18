//
//  NoteViewController.swift
//  NotesClone
//
//  Created by Giorgio Latour on 5/17/23.
//

import UIKit

class NoteViewController: UIViewController {

    var textView: UITextView!
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = note.title
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = note.content
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        
    }
}
