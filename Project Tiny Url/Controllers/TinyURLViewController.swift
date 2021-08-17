//
//  ViewController.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift

class TinyURLViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let tinyURLVM = TinyURLViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

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
        label.text = Translations.labelText
        label.textColor = .black
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle(Translations.buttonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemOrange
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtonGesture()
        prepareLayout()
        textField.delegate = self
        bindTableView()
        tinyURLVM.loadTinyURL()
    }

    func  makeItTinyButtonPressed() {
        guard let longURL = textField.text else { return }
        tinyURLVM.getShortUrl(with: longURL)
    }

    func bindTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "URLCell")
    
        tinyURLVM.urls.bind(to: tableView.rx.items(cellIdentifier: "URLCell", cellType: CustomTableViewCell.self)) { row, tinyURL, cell in
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
        setAlert()
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

    private func setAlert() {
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            return view
        }()

        let alertTitle: UILabel = {
            let alertTitle = UILabel()
            alertTitle.text = "Success!!"
            alertTitle.font = UIFont.boldSystemFont(ofSize: 17)
            return alertTitle
        }()

        let alertMessage: UILabel = {
            let alertMessage = UILabel()
            alertMessage.text = "Tiny URL copied to clipboard!"
            alertMessage.font = UIFont.systemFont(ofSize: 13)
            return alertMessage
        }()

        let alertDismiss: UILabel = {
            let alertDismiss = UILabel()
            alertDismiss.text = "Swipe to dismiss"
            alertDismiss.font = UIFont.boldSystemFont(ofSize: 13)
            alertDismiss.textColor = .systemBlue
            return alertDismiss
        }()

        let alertStackView: UIStackView = {
            let alertStackView = UIStackView()
            alertStackView.layer.cornerRadius = 20
            alertStackView.backgroundColor = .systemGray5
            alertStackView.alignment = .center
            alertStackView.axis = .vertical
            alertStackView.distribution = .fillProportionally
            alertStackView.addArrangedSubview(alertTitle)
            alertStackView.addArrangedSubview(alertMessage)
            alertStackView.addArrangedSubview(alertDismiss)
            return alertStackView
        }()

        backgroundView.addSubview(alertStackView)
        self.view.addSubview(backgroundView)

        backgroundView.snp.makeConstraints {
            $0.bottom.trailing.leading.top.equalToSuperview()
        }

        alertStackView.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.width.equalTo(250)
            $0.centerY.centerX.equalTo(backgroundView)
        }
        alertStackView.rx.swipeGesture([.up, .down])
            .when(.recognized)
            .subscribe(onNext: { _ in
                backgroundView.removeFromSuperview()
            }).disposed(by: disposeBag)
    }

    private func setUpButtonGesture() {
        button.rx.tap
            .subscribe(onNext:  { [weak self] _ in
                self?.makeItTinyButtonPressed()
            }).disposed(by: disposeBag)
    }

    private func setUpFont() {
        let font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.font = font
        label.font = font
    }
}
