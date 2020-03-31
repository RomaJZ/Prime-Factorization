//
//  ViewController.swift
//  MadAppGang Test
//
//  Created by Roma Filipenko on 29.03.2020.
//  Copyright © 2020 Roma&Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Text outlets
    
    @IBOutlet weak var numberString: UITextField!
    @IBOutlet weak var factorsString: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Checks for string
    
    func checkString() -> Int? {
        
        let textNumber = numberString.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textNumber == "" {
            
            let alertController = UIAlertController(title: "Empty field!", message: "Please, enter number", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                           
                self?.numberString.text = ""
            }
            alertController.addAction(action)
            
            self.present(alertController, animated: true)
        }
        
        if Int(textNumber!) == nil {
            
            let alertController = UIAlertController(title: "Not an integer!", message: "Please, enter integer number", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                
                self?.numberString.text = ""
            }
            alertController.addAction(action)
            
            self.present(alertController, animated: true)
        }
        
        let number = Int(textNumber!)
        
        return number
    }
    
    //MARK: UI of factorization
    
    @IBAction func factorize(_ sender: UIButton) {
        
        factorsString.text?.removeAll()
        
        guard let number = checkString() else { return }
        
        guard number != 0 else {
            factorsString.text =  """
                            You can't factorize 0!
                            It's not prime number
                            itself either.
                            """
            numberString.text = ""
            return
        }
        
        guard number > 0 else {
            factorsString.text = "You can't factorize negative number!"
            numberString.text = ""
            return
        }
        
        guard number != 1 else {
            factorsString.text =  """
                            You can't factorize 1!
                            It's not prime number
                            itself either.
                            """
            numberString.text = ""
            return
        }
        
        factor(x: number).forEach { factorsString.text?.append(contentsOf: "\($0) ") }
    }
    
    //MARK: Factorization
    
    func factor(x: Int) -> [Int] {
        
        guard x != 0 else { return [] }

        guard x > 0 else { return [] }

        guard x != 1 else { return [] }
        
        var x = x
        
        let start = Date()

        var factors: [Int] = []
        factors.reserveCapacity(Int(sqrt(Double(x))))
        
        var divisor = 2
        
        while x >= (divisor * divisor) {
                
            while x % divisor == 0 {

                factors.append(divisor)
                x /= divisor
            }
            
            divisor += divisor == 2 ? 1 : 2
            
            // If divisor very large, it is more efficient to use Brent variant of Pollard's Rho algorithm
            
//            if divisor > 1000000 {
//                factors.append(contentsOf: factorPolard(n: x))
//            }
        }
        
        if x > 1 {
            factors.append(x)
        }
        
        print("Time:", Date().timeIntervalSince(start) * 1000, "ms")

        return factors
    }
    
    //MARK: Pollard's Rho algorithm
    
    // Unfortunately, due to lack of performance while using custom BigInt, it is more efficient to use so called Trial Division algorithm. With few upgrades it is very efficient, and sometimes faster than Pollard's Rho algorithm. Nevertheless, if using Python or C++ it is usually significantly faster on larger numbers
    
    func factorPollard(x: Int) -> [Int] {
        
        guard x != 0 else { return [] }

        guard x > 0 else { return [] }

        guard x != 1 else { return [] }
        
        var n = x
        
        var factors: [Int] = []
        factors.reserveCapacity(Int(sqrt(Double(n))))
        
        let start = Date()
        
        while n > 1 {
            
            while n % 2 == 0 {
                
                factors.append(2)
                n /= 2
            }
            
            var y = BInt(Int.random(in: 1...n-1))
            let c = BInt(Int.random(in: 1...n-1))
            let m = BInt(Int.random(in: 1...n-1))
            
            var g: BInt = 1
            var r: BInt = 1
            var q: BInt = 1
            
            var k: BInt = 0
            var ys: BInt = 0
            let x = y
            
            while g == 1 {
                
                for _ in 1...r {
                    y = (((y * y) % n) + c) % n
                }
                
                while k < r, g == 1 {
                    
                    ys = y
                    
                    for _ in 1...min(m, r-k) {
                        
                        y = (((y * y) % n) + c) % n
                        q = q * (abs(x-y)) % n
                    }
                    g = gcd(q, BInt(n))
                    k = k + m
                }
                r *= 2
            }
            
            if g == n {
                
                while true {
                    
                    ys = (((ys * ys) % n) + c) % n
                    g = gcd(abs(x-ys), BInt(n))
                    
                    if g > 1 {
                        break
                    }
                }
            }
            factors.append(Int(g))
            n /= Int(g)
        }
        print("Time:", Date().timeIntervalSince(start) * 1000, "ms")
        
        return factors
    }
    
    func gcd(_ a: BInt, _ b: BInt) -> BInt {
        
        let r = a % b
        
        if r != 0 {
            
            return gcd(b, r)
            
        } else {
            return b
        }
    }
}
