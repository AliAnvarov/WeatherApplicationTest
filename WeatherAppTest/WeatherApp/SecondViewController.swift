import UIKit


protocol  ChangeCityDelegate {
    func userEnteredNewCityName(city: String?)
}

class SecondViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?

    @IBOutlet weak var cityNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        
        delegate?.userEnteredNewCityName(city: cityNameText.text)
        self.dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
