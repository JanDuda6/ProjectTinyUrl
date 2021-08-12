//
//  AlertService.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation
import UIKit

struct AlertService {
    static func URLCopiedToPasteboardAlert(view: UIViewController) {
        let alertController = UIAlertController(title: Translations.alertTitle, message: Translations.alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }
}
