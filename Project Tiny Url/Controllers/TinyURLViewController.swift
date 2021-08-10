//
//  ViewController.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import UIKit
import SnapKit

class TinyURLViewController: UIViewController {
    private let stackView = UIStackView()
    private let textField = UITextField()
    private let label = UILabel()
    private let button = UIButton()
    private let tableView = UITableView()

    private let tinyURLVM = TinyURLViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "URLCell")
        presentView()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        tinyURLVM.loadTinyURL { [self] in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }

    @objc func  makeItTinyButtonPressed(_ sender: UIButton) {
        if textField.text != "" {
            tinyURLVM.setLongURL(longURL: textField.text!)
            tinyURLVM.fetchDataFromApi { [self] in
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
    }

    // add url to pasteboard
    func addURLToPasteboard(tinyURL: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = tinyURL
        AlertService.URLCopiedToPasteboardAlert(view: self)
    }
}

//MARK: - Table View Delegate
extension TinyURLViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tinyURLVM.getTinyURLArray().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reverseIndexPathRow = reverseIndexPathRow(indexPath: indexPath)
        let tinyURLArray = tinyURLVM.getTinyURLArray()
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "URLCell")
        cell.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        cell.textLabel?.text = tinyURLArray[reverseIndexPathRow].shortURL
        cell.detailTextLabel?.text = tinyURLArray[reverseIndexPathRow].longURL
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reverseIndexPathRow = reverseIndexPathRow(indexPath: indexPath)
        let tinyURLArray = tinyURLVM.getTinyURLArray()
        addURLToPasteboard(tinyURL: tinyURLArray[reverseIndexPathRow].shortURL)
    }

    // reverse index for display new cell at the top
    func reverseIndexPathRow(indexPath: IndexPath) -> Int {
        let reverseIndexPathRow = tinyURLVM.getTinyURLArray().count - 1 - indexPath.row
        return reverseIndexPathRow
    }
}

//MARK: - TextField delege to dismiss keyboard
extension TinyURLViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
    }
}

//MARK: - SnapKit
extension TinyURLViewController {
    private func presentView() {
        self.view.addSubview(stackView)
        self.view.addSubview(tableView)
        createStackView()
        createTableView()
        createLabel()
        createTextField()
        createButton()
        setUpFont()
    }

    private func createStackView() {
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 36
        stackView.axis = .vertical
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(100)
            $0.leading.equalTo(self.view).offset(20)
            $0.trailing.equalTo(self.view).offset(-20)
        }
    }

    private func createTableView() {
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(40)
        }
    }

    private func createTextField() {
        textField.placeholder = "URL"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        stackView.addArrangedSubview(textField)
        textField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalTo(self.stackView).offset(30)
            $0.trailing.equalTo(self.stackView).offset(-30)
        }
    }

    private func createButton() {
        button.addTarget(self, action: #selector(self.makeItTinyButtonPressed(_:)), for: .touchUpInside)
        button.setTitle("Make it Tiny!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemOrange
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalTo(self.stackView).offset(60)
            $0.trailing.equalTo(self.stackView).offset(-60)
        }
    }

    private func createLabel() {
        label.text = "Enter URL:"
        label.textColor = .black
        stackView.addArrangedSubview(label)
    }

    private func setUpFont() {
        let font = UIFont(name: "Arial Rounded MT Bold", size: 20.0)
        button.titleLabel?.font = font
        label.font = font
    }
}
