import UIKit

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
        // Individual letters of Strings are instances of Character.
        // firstLetter.uppercased() actually returns a String because
        // in some languages a lowercase letter maps to more than
        // one uppercase character.
    }
    
    func withPrefix(_ prefix: String) -> String  {
        guard !self.hasPrefix(prefix) else { return self }
        return prefix + self
    }
    
    var isNumeric: Bool {
        guard Double(self) != nil else { return false }
        return true
    }
    
    var lines: Array<String> {
        return self.components(separatedBy: "\n")
    }
}

var myString = "pet"
myString.withPrefix("car")

var myNumeric = "1.23"
myNumeric.isNumeric

var myNumericFalse = "1.2.3"
myNumericFalse.isNumeric

var myLines = "this\nis\na\ntest"
myLines.lines
