//
//  ViewController.swift
//  LearnRx
//
//  Created by Manh Nguyen Ngoc on 23/02/2023.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.learnObservableSequences()
    }

    private func learnObservableSequences() {
        let helloSequence = Observable.just("Hello Babay")
        let fibonaciSequencu = Observable.from([0, 1, 1, 2, 3, 5, 8])
        let dictSequence = Observable.from([1: "Come on", 2: "Boy"])
        
        
    }
}

