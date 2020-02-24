//
//  Service.swift
//  SourceDLT_App
//
//  Created by masato on 24/2/2020.
//  Copyright © 2020 gigmuster. All rights reserved.
//

import UIKit


class Service {

    static func showAllert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Void)? = nil) {


        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: nil)
    }
}


