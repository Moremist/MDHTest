import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        setupButton()
    }
    
    func setupButton() {
        searchButton.layer.cornerRadius = 10
        searchButton.addTarget(self, action: #selector (searchButtonPressed), for: .touchUpInside)
    }
    
    @objc func searchButtonPressed() {
        
        if searchTextField.text != "" {
            let vc = storyboard?.instantiateViewController(identifier: "resultsViewController") as! ResultsViewController
            vc.userRequestText = searchTextField.text!
            present(vc, animated: true, completion: nil)
        }
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchButtonPressed()
        return true
    }
}
