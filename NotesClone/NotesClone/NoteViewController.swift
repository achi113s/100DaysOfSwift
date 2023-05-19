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
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .systemYellow
        
        title = note.title
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = note.content
        textView.delegate = self
        textView.inputAccessoryView = toolbar()
        textView.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func saveNote() {
        guard let homeVC = navigationController?.viewControllers.first as? HomeViewController else {
            fatalError("Could not get HomeViewController!")
        }
        
        homeVC.saveData()
    }
    
    func toolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barStyle = .default
        toolbar.barTintColor = .systemBackground
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickDoneButton))
        
        toolbar.setItems([space, doneButton], animated: false)
        
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    @objc func onClickCancelButton() {
        self.textView.endEditing(true)
    }
    
    @objc func onClickDoneButton() {
        self.textView.endEditing(true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // try to save on every change?
        note.content = textView.text
        saveNote()
    }
}
