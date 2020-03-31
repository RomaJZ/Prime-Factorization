//
//  MadAppGang_TestTests.swift
//  MadAppGang TestTests
//
//  Created by Roma Filipenko on 29.03.2020.
//  Copyright © 2020 Roma&Co. All rights reserved.
//

import XCTest
@testable import MadAppGang_Test

class MadAppGang_TestTests: XCTestCase {

    var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        sut = ViewController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNumberShouldBePositive() {

        let x = -373

        let factors = sut.factor(x: x)

        XCTAssert(factors.isEmpty, "Number should be positive!")
    }

    func testNumberCouldNotBeEqualToZero() {

        let x = 0

        let factors = sut.factor(x: x)

        XCTAssert(factors.isEmpty, "Number could not be equal to 0!")
    }

    func testNumberCouldNotBeEqualToOne() {

        let x = 1

        let factors = sut.factor(x: x)

        XCTAssert(factors.isEmpty, "Number could not be equal to 1!")
    }

    func testMultiplicationOfFactorsShouldGiveInitialNumber() {

        let x = 1372

        let factors = sut.factor(x: x)

        let number = factors.reduce(1) { $0 * $1 }

        XCTAssert(x == number, "Multiplication of factors should give initial number!")
    }

    func testFactorsShouldBePrime() {

        let x = 243787123

        let factors = sut.factor(x: x)

        var isPrime = true

        for factor in factors {

            guard factor != 2, factor != 3 else { continue }

            let sqrtOfFactor = Int(sqrt(Double(factor)))

            for num in 2...sqrtOfFactor {

                if factor % num == 0 {
                    isPrime = false
                    break
                }
            }
            guard isPrime else { break }
        }

        XCTAssert(isPrime, "Multiplication of factors should give initial number!")
    }
    
    func testPerformance() {
        
        let xArr = (0..<100).map { _ in Int.random(in: 2...(Int.max/1000)) }
        measure {
            
            for x in xArr {
                _ = sut.factor(x: x)
                print(x)
            }
        }
    }
}
