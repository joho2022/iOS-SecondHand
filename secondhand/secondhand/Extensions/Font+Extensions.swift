//
//  Font+Extensions.swift
//  secondhand
//
//  Created by 조호근 on 6/3/24.
//

import SwiftUI

extension Font {
    enum FontWeight {
        case regular
        case semibold
        
        var weight: Font.Weight {
            switch self {
            case .regular: return .regular
            case .semibold: return .semibold
            }
        }
    }
    
    static func system(_ type: FontWeight, size: CGFloat) -> Font {
        return .system(size: size, weight: type.weight)
    }
}
