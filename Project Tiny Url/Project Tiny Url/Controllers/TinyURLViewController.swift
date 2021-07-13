//
//  ViewController.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import UIKit

class TinyURLViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var tableView: UITableView!

    private let tinyURLVM = TinyURLViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tinyURLVM.loadTinyURL { [self] in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }

    @IBAction func tinyURLButtonPressed(_ sender: UIButton) {
        if textView.text != "" {
            tinyURLVM.setLongURL(longURL: textView.text)
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
        // reverse index for display new cell at the top
        let reverseIndexPathRow = tinyURLVM.getTinyURLArray().count - 1 - indexPath.row
        let tinyURLArray = tinyURLVM.getTinyURLArray()
        let cell = tableView.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath)
        cell.textLabel?.text = tinyURLArray[reverseIndexPathRow].shortURL
        cell.detailTextLabel?.text = tinyURLArray[reverseIndexPathRow].longURL
        return cell
    }
}
