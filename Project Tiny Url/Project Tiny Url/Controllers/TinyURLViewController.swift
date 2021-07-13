//
//  ViewController.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import UIKit

class TinyURLViewController: UIViewController {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    private let tinyURLVM = TinyURLViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        tinyURLVM.loadTinyURL { [self] in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }

    @IBAction func tinyURLButtonPressed(_ sender: UIButton) {
        if textField.text != "" {
            tinyURLVM.setLongURL(longURL: textField.text!)
            tinyURLVM.fetchDataFromApi { [self] in
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
    }

}

//MARK: - Table View Delegate
extension TinyURLViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tinyURLVM.getTinyURLArray().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reverseIndexPathRow = reverseIndexPathRow(index: indexPath)
        let tinyURLArray = tinyURLVM.getTinyURLArray()
        let cell = tableView.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath)
        cell.textLabel?.text = tinyURLArray[reverseIndexPathRow].shortURL
        cell.detailTextLabel?.text = tinyURLArray[reverseIndexPathRow].longURL
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reverseIndexPathRow = reverseIndexPathRow(index: indexPath)
        let tinyURLArray = tinyURLVM.getTinyURLArray()
        addURLToClipboard(tinyURL: tinyURLArray[reverseIndexPathRow].shortURL)
    }

    // add url to pasteboard
    func addURLToClipboard(tinyURL: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = tinyURL
        AlertService.URLCopiedToClipboardHandler(view: self)
    }

    // reverse index for display new cell at the top
    func reverseIndexPathRow(index: IndexPath) -> Int {
        let reverseIndexPathRow = tinyURLVM.getTinyURLArray().count - 1 - index.row
        return reverseIndexPathRow
    }
}

//MARK: - TextField delege to dismiss keyboard
extension TinyURLViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
    }
}
