import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, data: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "85D45D5B-A936-4C11-B46F-256704F1096C"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {

        //1. Create a URL
        if let url = URL(string: urlString) {

            //2. create a URL Session
            let session = URLSession(configuration: .default)

            //3.give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let data = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRate(self, data: data)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }

    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let currency = decodedData.asset_id_quote
            let coin = CoinModel(currency: currency, rate: lastPrice)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
