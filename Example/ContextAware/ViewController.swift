//
//  ViewController.swift
//  ContextAware
//
//  Created by Alex Manzella on 26/10/21.
//

import UIKit

class ViewController: UIViewController {}

class SecondViewController: UIViewController {}

class ThirdViewController: UIViewController {
    @objc @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
