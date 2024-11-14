
import UIKit
import WebKit

class TermsAndConditionsViewController: UIViewController {
    

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url : URL(string: "http://172.18.4.2:3000/index.html")!))

    }
}
