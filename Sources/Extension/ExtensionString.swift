//
//  ExtensionString.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension String {
    
    public func convertStringWithCommas() -> String {
        if let value = Int(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            return numberFormatter.string(from: NSNumber(value:value))!
        }
        return self
    }
    
    public var convertHTMLToAttributedString: NSAttributedString? {
        return Data(utf8).convertHTMLToAttributedString
    }
    
    public func index(of pattern: String) -> String.Index? {
        for i in self.indices {
            var j = i
            var found = true
            for p in pattern.indices {
                if j == self.endIndex || self[j] != pattern[p] {
                    found = false
                    break
                } else {
                    j = self.index(after: j)
                }
            }
            if found {
                return i
            }
        }
        return nil
    }
    
    public func index(of pattern: String, usingHorspoolImprovement: Bool = false) -> Index? {
        // Cache the length of the search pattern because we're going to
        // use it a few times and it's expensive to calculate.
        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= self.count else { return nil }
        
        // Make the skip table. This table determines how far we skip ahead
        // when a character from the pattern is found.
        var skipTable = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            skipTable[c] = patternLength - i - 1
        }
        
        // This points at the last character in the pattern.
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]
        
        // The pattern is scanned right-to-left, so skip ahead in the string by
        // the length of the pattern. (Minus 1 because startIndex already points
        // at the first character in the source string.)
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        // This is a helper function that steps backwards through both strings
        // until we find a character that doesn’t match, or until we’ve reached
        // the beginning of the pattern.
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }
        
        // The main loop. Keep going until the end of the string is reached.
        while i < endIndex {
            let c = self[i]
            
            // Does the current character match the last character from the pattern?
            if c == lastChar {
                
                // There is a possible match. Do a brute-force search backwards.
                if let k = backwards() { return k }
                
                if !usingHorspoolImprovement {
                    // If no match, we can only safely skip one character ahead.
                    i = index(after: i)
                } else {
                    // Ensure to jump at least one character (this is needed because the first
                    // character is in the skipTable, and `skipTable[lastChar] = 0`)
                    let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                    i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
                }
            } else {
                // The characters are not equal, so skip ahead. The amount to skip is
                // determined by the skip table. If the character is not present in the
                // pattern, we can skip ahead by the full pattern length. However, if
                // the character *is* present in the pattern, there may be a match up
                // ahead and we can't skip as far.
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }

    public func indexes(of pattern: String) -> [Int]? {
        
        let text = Array(self)
        let _pattern = Array(pattern)
        
        let textLength: Int = text.count
        let patternLength: Int = _pattern.count
        
        guard patternLength > 0 else {
            return nil
        }
        
        var suffixPrefix: [Int] = [Int](repeating: 0, count: patternLength)
        var textIndex: Int = 0
        var patternIndex: Int = 0
        var indexes: [Int] = [Int]()
        
        /* Pre-processing stage: computing the table for the shifts (through Z-Algorithm) */
        let zeta = ZetaAlgorithm(pattern: pattern)
        
        for patternIndex in (1 ..< patternLength).reversed() {
            textIndex = patternIndex + zeta![patternIndex] - 1
            suffixPrefix[textIndex] = zeta![patternIndex]
        }
        
        /* Search stage: scanning the text for pattern matching */
        textIndex = 0
        patternIndex = 0
        
        while textIndex + (patternLength - patternIndex - 1) < textLength {
            
            while patternIndex < patternLength && text[textIndex] == _pattern[patternIndex] {
                textIndex = textIndex + 1
                patternIndex = patternIndex + 1
            }
            
            if patternIndex == patternLength {
                indexes.append(textIndex - patternIndex)
            }
            
            if patternIndex == 0 {
                textIndex = textIndex + 1
            } else {
                patternIndex = suffixPrefix[patternIndex - 1]
            }
        }
        
        guard !indexes.isEmpty else {
            return nil
        }
        return indexes
    }
    
    public func longestCommonSubsequence(_ other: String) -> String {
        
        // Computes the length of the lcs using dynamic programming.
        // Output is a matrix of size (n+1)x(m+1), where matrix[x][y] is the length
        // of lcs between substring (0, x-1) of self and substring (0, y-1) of other.
        func lcsLength(_ other: String) -> [[Int]] {
            
            // Create matrix of size (n+1)x(m+1). The algorithm needs first row and
            // first column to be filled with 0.
            var matrix = [[Int]](repeating: [Int](repeating: 0, count: other.count+1), count: self.count+1)
            
            for (i, selfChar) in self.enumerated() {
                for (j, otherChar) in other.enumerated() {
                    if otherChar == selfChar {
                        // Common char found, add 1 to highest lcs found so far.
                        matrix[i+1][j+1] = matrix[i][j] + 1
                    } else {
                        // Not a match, propagates highest lcs length found so far.
                        matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
                    }
                }
            }
            
            // Due to propagation, lcs length is at matrix[n][m].
            return matrix
        }
        
        // Backtracks from matrix[n][m] to matrix[1][1] looking for chars that are
        // common to both strings.
        func backtrack(_ matrix: [[Int]]) -> String {
            var i = self.count
            var j = other.count
            
            // charInSequence is in sync with i so we can get self[i]
            var charInSequence = self.endIndex
            
            var lcs = String()
            
            while i >= 1 && j >= 1 {
                // Indicates propagation without change: no new char was added to lcs.
                if matrix[i][j] == matrix[i][j - 1] {
                    j -= 1
                }
                    // Indicates propagation without change: no new char was added to lcs.
                else if matrix[i][j] == matrix[i - 1][j] {
                    i -= 1
                    // As i was decremented, move back charInSequence.
                    charInSequence = self.index(before: charInSequence)
                }
                    // Value on the left and above are different than current cell.
                    // This means 1 was added to lcs length (line 17).
                else {
                    i -= 1
                    j -= 1
                    charInSequence = self.index(before: charInSequence)
                    
                    lcs.append(self[charInSequence])
                }
            }
            
            // Due to backtrack, chars were added in reverse order: reverse it back.
            // Append and reverse is faster than inserting at index 0.
            return String(lcs.reversed())
        }
        
        // Combine dynamic programming approach with backtrack to find the lcs.
        return backtrack(lcsLength(other))
    }
}

func ZetaAlgorithm(pattern: String) -> [Int]? {
    let pattern = Array(pattern)
    let patternLength = pattern.count
    
    guard patternLength > 0 else {
        return nil
    }
    
    var zeta = [Int](repeating: 0, count: patternLength)
    
    var left = 0
    var right = 0
    var k_1 = 0
    var betaLength = 0
    var textIndex = 0
    var patternIndex = 0
    
    for k in 1 ..< patternLength {
        if k > right {
            patternIndex = 0
            
            while k + patternIndex < patternLength  &&
                pattern[k + patternIndex] == pattern[patternIndex] {
                    patternIndex = patternIndex + 1
            }
            
            zeta[k] = patternIndex
            
            if zeta[k] > 0 {
                left = k
                right = k + zeta[k] - 1
            }
        } else {
            k_1 = k - left + 1
            betaLength = right - k + 1
            
            if zeta[k_1 - 1] < betaLength {
                zeta[k] = zeta[k_1 - 1]
            } else if zeta[k_1 - 1] >= betaLength {
                textIndex = betaLength
                patternIndex = right + 1
                
                while patternIndex < patternLength && pattern[textIndex] == pattern[patternIndex] {
                    textIndex = textIndex + 1
                    patternIndex = patternIndex + 1
                }
                
                zeta[k] = patternIndex - k
                left = k
                right = patternIndex - 1
            }
        }
    }
    return zeta
}
