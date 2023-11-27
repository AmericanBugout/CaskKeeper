//
//  Font+Ext.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI

extension Font {
    
    static func customLight(size: CGFloat) -> Font {
        return Font.custom("AsapCondensed-Light", size: size)
    }
    
    static func customRegular(size: CGFloat) -> Font {
        return Font.custom("AsapCondensed-Regular", size: size)
    }
    
    static func customBold(size: CGFloat) -> Font {
        return Font.custom("AsapCondensed-Bold", size: size)
    }
    
    static func customSemiBold(size: CGFloat) -> Font {
        return Font.custom("AsapCondensed-SemiBold", size: size)
    }
}
