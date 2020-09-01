//
//  DispatchQueue+Extensions.swift
//  AMTfm
//
//  Created by DEEBA on 25.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import Foundation

func background(work: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
        work()
    }
}

func main(work: @escaping () -> ()) {
    DispatchQueue.main.async {
        work()
    }
}
