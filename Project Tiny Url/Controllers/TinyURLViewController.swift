//
//  ViewController.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TinyURLViewController: UIViewController {
    private let tableView = UITableView()
    private let tinyURLVM = TinyURLViewModel()
    private var disposeBag = DisposeBag()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 36
        stackView.axis = .vertical
        return stackView
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "URL"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Enter URL:"
        label.textColor = .black
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Make it Tiny!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemOrange
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(self.makeItTinyButtonPressed(_:)), for: .touchUpInside)
        prepareLayout()
        textField.delegate = self
        tinyURLVM.loadTinyURL()
        bindTableView()
    }

    @objc func  makeItTinyButtonPressed(_ sender: UIButton) {
        guard let longURL = textField.text else { return }
        tinyURLVM.getShortUrl(with: longURL)
    }

    func bindTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "URLCell")
    
        tinyURLVM.urls.bind(to: tableView.rx.items(cellIdentifier: "URLCell", cellType: UITableViewCell.self)) { row, tinyURL, cell in
            cell.backgroundColor = .clear
            cell.textLabel?.text = tinyURL.shortURL
            cell.detailTextLabel?.text = tinyURL.longURL
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(TinyURL.self).subscribe(onNext: { [weak self] tinyUrl in
            self?.addURLToPasteboard(tinyURL: tinyUrl.shortURL)
        }).disposed(by: disposeBag)
    }

    // add url to pasteboard
    func addURLToPasteboard(tinyURL: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = tinyURL
        AlertService.URLCopiedToPasteboardAlert(view: self)
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
    private func prepareLayout() {
        self.view.addSubview(stackView)
        self.view.addSubview(tableView)
        setUpStackView()
        setUpTableView()
        setUpTextField()
        setUpButton()
        setUpFont()
    }

    private func setUpStackView() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(100)
            $0.leading.equalTo(self.view).offset(20)
            $0.trailing.equalTo(self.view).offset(-20)
        }
    }

    private func setUpTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(40)
        }
    }

    private func setUpTextField() {
        textField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalTo(self.stackView).offset(30)
            $0.trailing.equalTo(self.stackView).offset(-30)
        }
    }

    private func setUpButton() {
        button.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalTo(self.stackView).offset(60)
            $0.trailing.equalTo(self.stackView).offset(-60)
        }
    }

    private func setUpFont() {
        let font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.font = font
        label.font = font
    }
}

