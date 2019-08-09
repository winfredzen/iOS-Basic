//
//  Manager.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/9.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import UIKit

struct Manager {
    var arr = ["1", "one"]
    var p : Int = {
        return 2
    }()
    
    var spacing: CGFloat = 16.0  {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = spacing
        return stackView
    }()
}

struct Human {
    init() {
        print("Born 1996")
    }
}

//createBob类型为() -> Human
let createBob = { () -> Human in
    let human = Human()
    return human
}

let babyBob = createBob()


let boby: Human = {
    let human = Human()
    return human
}()
