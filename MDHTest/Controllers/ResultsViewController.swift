import UIKit
import Kingfisher

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    private let collectionViewCellID = "resultCell"
    private var isLoading = false
    
    let api = API()
    var resultArray : [Result] = []

    var currentPage = 0

    var userRequestText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        downloadPhotosFrom(Page: currentPage, complition: {} )
    }
    
    func downloadPhotosFrom(Page: Int, complition: @escaping () -> ()) {
        nextPage()
        DispatchQueue.global(qos: .userInteractive).async {
            self.api.fetchPhotos(for: self.userRequestText, page: self.currentPage) { data in
                guard let data = data else {
                    return
                }
                self.resultArray += data.results
                DispatchQueue.main.async {
                    complition()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func nextPage() {
        currentPage += 1
    }
}

extension ResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! ResultCollectionViewCell
        
        cell.imageView.image = nil
        
        let photoURLString = resultArray[indexPath.row].urls.small
        guard let photoURL = URL(string: photoURLString) else {
            return cell
        }
        
        cell.imageView.kf.setImage(with: photoURL, placeholder: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    
    
}

extension ResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension ResultsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoading {
            let pos = scrollView.contentOffset.y
            if pos > (collectionView.contentSize.height - 300 - scrollView.frame.size.height) {
                isLoading = true
                self.downloadPhotosFrom(Page: currentPage) {
                    self.isLoading = false
                }
            }
        }
    }
}
