
import UIKit
import WebKit

class TermsAndConditionsViewController: UIViewController {
    

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url : URL(string: "http://172.18.4.2:3000/index.html")!))

    }
}
/*
import UIKit
import WebKit

class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the local HTML file
        if let filePath = Bundle.main.path(forResource: "terms", ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath)
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        } else {
            print("File not found")
        }
    }
}
*/
