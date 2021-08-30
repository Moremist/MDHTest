import Foundation

struct API {
    let accessKey = "y6GBW3R-3Wmm_Uetd_BHLds5wWLAn39Ik7LjHqGnR_c"
    
    let searchURLString = "https://api.unsplash.com/search/photos"
    let pageURLString = "?page="
    let requestURLString = "&query="
    
    func fetchPhotos(for request: String, page: Int ,compition: @escaping (UnsplashData?) -> () ) {
        guard let url = URL(string: searchURLString + pageURLString + String(page) + requestURLString + request) else {
            return
        }
        var urlRequest:URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            do {
                if let data = data {
                    let collection = try JSONDecoder().decode(UnsplashData.self, from: data)
                    compition(collection)
                }
            } catch let error {
                print(error)
            }

        }.resume()
    }
}
