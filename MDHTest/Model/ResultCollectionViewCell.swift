import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func downloadPhoto(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let strongSelf = self else { return }
            
            guard let data = data, let image = UIImage(data: data), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                UIView.transition(with: strongSelf.imageView, duration: 0.3, options: [.transitionCrossDissolve]) {
                    strongSelf.imageView.image = image
                }
            }
        }.resume()
    }
}
