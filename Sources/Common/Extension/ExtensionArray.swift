//
//  ExtensionArray.swift
//  GGITCommon_iOS
//
//  Created by Kelvin Leong on 03/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension Array {
    
    /**
     filteredElements will act as our filtering function that is executed during our iteration
     ```swift
     let evenNumbers = [1,2,3,4,5].filteredElements { (num) -> Bool in
     return num % 2 == 0
     }
     print(evenNumbers) // [2, 4]
     
     let dogs = ["big-dog", "small-cat", "small-dog", "medium-cat"].filteredElements { (pet) -> Bool in
     return pet.contains("dog")
     }
     print(dogs) // ["big-dog", "small-dog"]
     ```
     */
    public func filteredElements(filterFunc: (Element) -> Bool) -> [Element] {
        
        var allElements = [Element]()
        self.forEach { (element) in
            if filterFunc(element) {
                allElements.append(element)
            }
        }
        return allElements
    }
}

extension Array where Element: Numeric {
    public func sum() -> Element{
        return self.reduce(0, {$0 + $1})
    }
}

extension Array where Element == String {
    public func concatenate() -> String{
        return self.reduce("", {$0 + $1 + " "})
    }
}
