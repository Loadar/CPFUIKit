//
//  UIColor+Hex.swift
//  Demo
//
//  Created by Aaron on 2023/4/4.
//

import UIKit

extension UIColor {
    public convenience init?(hex string: String) {
        let length = string.lengthOfBytes(using: .utf8)
        guard (length == 6 || length == 8) else {
            return nil
        }
        
        var finalString = string
        // 颜色alpha通道默认为1
        if length == 6 {
            finalString += "ff"
        }
        
        let scanner = Scanner(string: finalString)
        var hexNumber: UInt64 = 0
        let success = scanner.scanHexInt64(&hexNumber)
        
        guard success else {
            return nil
        }
        
        let red = (hexNumber >> 24) & 0x000000ff
        let green = (hexNumber >> 16) & 0x000000ff
        let blue = (hexNumber >> 8) & 0x000000ff
        let alpha = hexNumber & 0x000000ff
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
}
