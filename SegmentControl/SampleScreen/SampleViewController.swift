//
//  ViewController.swift
//  SegmentControl
//
//  Created by Alexander Borisov on 13.05.2024.
//

import UIKit

class SampleViewController: UIViewController {

    private let sampleView = SampleView()

    override func loadView() {
        view = sampleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
