//
//  main.swift
//  SwiftTest
//
//  Created by 胡金友 on 2017/12/10.
//

import Foundation

print("Hello, World!")

class TestClass {
    subscript(value:Any) -> TestClass {
        return self["\(value)"]
    }
    
    subscript(value:String) -> TestClass {
        return self
    }
}

class TestSubClass : TestClass {
    override subscript(value:String) -> TestSubClass {
        print("sub value : \(value)")
        return self
    }
}


let cls = TestSubClass()

print("cls : \(cls[434.23]["33434"][3434])")
