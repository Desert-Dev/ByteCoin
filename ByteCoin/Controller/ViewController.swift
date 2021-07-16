//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }


}

// MARK:- Functions for populating UIPicker

extension ViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
}

// MARK:- Functions for UIPicker Delegate

extension ViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // "This method expects a String as an output. The String is the title for a given row. When the PickerView is loading up, it will ask its delegate for a row title and call the above method once for every row. So when it is trying to get the title for the first row, it will pass in a row value of 0 and a component (column) value of 0."
        return coinManager.currencyArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // "This will get called every time when the user scrolls the picker. When that happens it will record the row number that was selected."
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        currencyLabel.text = selectedCurrency
    }
    
}


// MARK:- CoinManagerDelegate Functions

extension ViewController : CoinManagerDelegate {
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: Double) {
        DispatchQueue.main.async {
            print("Coin = \(coin)")
            self.bitcoinLabel.text = String(coin)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
