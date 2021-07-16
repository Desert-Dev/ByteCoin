//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        // 1. Create URL
        if let coinURL = URL(string: "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=F5A495B8-659F-427D-A539-157A74A037B1") {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Create a new data task for the URLSession (dataTask = "Creates a task that retrieves the contents of the specified URL, then calls a handler upon completion.")

            let task = session.dataTask(with: coinURL) { data, response, error in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: Double(round(100*price)/100))  // Round total to 2 decimals (To round to 3, we add a 0 to both 100s')
                    }
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
