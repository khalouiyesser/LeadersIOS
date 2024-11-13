import UIKit
/*
class HomeViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var navBar: UITabBar!
    @IBOutlet weak var settingsButton: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UITabBar delegate
        navBar.delegate = self

        // Optionally, set a custom image for the setting button
        /*if let settingButton = settingButton {
            settingButton.image = UIImage(named: "settings") // Replace with your image name
        }*/
    }

    // MARK: - UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == settingsButton {
            // Trigger the segue to the Settings page
            performSegue(withIdentifier: "settings", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            // Pass any data to the SettingsViewController if needed
        }
    }
}
*/
