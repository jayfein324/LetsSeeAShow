//
//  NSAttributedStringExtension.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/5/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import Foundation

extension NSAttributedString {
    static func makeHyperLink(for path : String, in string : String, as substring : String) -> NSAttributedString {
        let nsString = NSString(string : string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        return attributedString
    }
}
