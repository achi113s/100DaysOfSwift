//
//  Extensions.swift
//  Day82ChallengeExtensions
//
//  Created by Giorgio Latour on 6/24/23.
//

import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

extension Int {
    func times(_ f: () -> Void) {
        for _ in 0..<abs(self) {
            f()
        }
    }
}

extension Array where Element: Comparable {
    mutating func removeAll(item: Element) {
        self = self.filter({ $0 != item })
    }
    
    mutating func remove(item: Element) {
        if let i = self.firstIndex(of: item) {
            self.remove(at: i)
        }
    }
}
