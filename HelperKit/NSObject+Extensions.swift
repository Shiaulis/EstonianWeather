//
//  NSObject+Extensions.swift
//  HelperKit
//
//  Created by Andrius Shiaulis on 18.01.2021.
//

public extension NSObject {

    @objc static var className: String {
        String(describing: self)
    }

}
