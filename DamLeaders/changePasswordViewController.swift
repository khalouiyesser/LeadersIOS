import UIKit
import SwiftUI

// SwiftUI Wrapper to present UIKit ChangePasswordViewController
struct ChangePasswordViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> changePasswordViewController {
        return changePasswordViewController() // Initialize your UIKit view controller here
    }
    
    func updateUIViewController(_ uiViewController: changePasswordViewController, context: Context) {
        // Handle any updates to the UIKit controller here (if necessary)
    }
}

class changePasswordViewController: UIViewController, UITextFieldDelegate {
    
    
       @IBOutlet weak var oldPasswordTF: UITextField!
       @IBOutlet weak var newPasswordTF: UITextField!
       @IBOutlet weak var confirmNewPasswordTF: UITextField!
       
       // Placeholder labels for floating effect
       private var oldPasswordPlaceholderLabel: UILabel?
       private var newPasswordPlaceholderLabel: UILabel?
       private var confirmNewPasswordPlaceholderLabel: UILabel?
       
       // Colors for active and inactive border
       private let activeBorderColor = UIColor.systemBlue
       private let inactiveBorderColor = UIColor.lightGray
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Ensure text fields are connected
           guard let oldPasswordTF = oldPasswordTF,
                 let newPasswordTF = newPasswordTF,
                 let confirmNewPasswordTF = confirmNewPasswordTF else {
               print("Error: Text fields are not connected.")
               return
           }
           
           // Add icons to text fields
           addIcon(textField: oldPasswordTF, iconName: "lock.fill")
           addIcon(textField: newPasswordTF, iconName: "lock.fill")
           addIcon(textField: confirmNewPasswordTF, iconName: "lock.fill")
           
           // Initialize and set up custom placeholder labels
           setupFloatingPlaceholder(for: oldPasswordTF, placeholderText: "Old Password")
           setupFloatingPlaceholder(for: newPasswordTF, placeholderText: "New Password")
           setupFloatingPlaceholder(for: confirmNewPasswordTF, placeholderText: "Confirm Password")
           
           // Initial setup for the text fields
           setInitialBorderStyle(for: oldPasswordTF)
           setInitialBorderStyle(for: newPasswordTF)
           setInitialBorderStyle(for: confirmNewPasswordTF)
           
           // Set the text field delegates
           oldPasswordTF.delegate = self
           newPasswordTF.delegate = self
           confirmNewPasswordTF.delegate = self
           
           // Check if there is initial text in the text fields and update the placeholder position
           updatePlaceholderPosition(for: oldPasswordTF)
           updatePlaceholderPosition(for: newPasswordTF)
           updatePlaceholderPosition(for: confirmNewPasswordTF)
           
           // Set up the initial state for password visibility
           oldPasswordTF.isSecureTextEntry = true
           newPasswordTF.isSecureTextEntry = true
           confirmNewPasswordTF.isSecureTextEntry = true
           
           // Set up the toggle buttons inside text fields
           setupPasswordToggleButton(for: oldPasswordTF)
           setupPasswordToggleButton(for: newPasswordTF)
           setupPasswordToggleButton(for: confirmNewPasswordTF)
    }
    
    // Adds an icon to the left side of the text field
    func addIcon(textField: UITextField, iconName: String) {
        let icon = UIImage(systemName: iconName)
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
        paddingView.addSubview(iconView)
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    // Sets up the password visibility toggle button
    func setupPasswordToggleButton(for textField: UITextField) {
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
        rightView.addSubview(toggleButton)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
    }
    
    // Toggles password visibility for the given text field
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        if let textField = [oldPasswordTF, newPasswordTF, confirmNewPasswordTF].first(where: { $0.rightView?.subviews.contains(sender) == true }) {
            textField.isSecureTextEntry.toggle()
            let imageName = textField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
            sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    // Sets up a floating placeholder
    func setupFloatingPlaceholder(for textField: UITextField, placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.addSubview(placeholderLabel)
        placeholderLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 8).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        
        if textField == oldPasswordTF {
            oldPasswordPlaceholderLabel = placeholderLabel
        } else if textField == newPasswordTF {
            newPasswordPlaceholderLabel = placeholderLabel
        } else if textField == confirmNewPasswordTF {
            confirmNewPasswordPlaceholderLabel = placeholderLabel
        }
    }
    
    // Sets the initial border style for text fields
    func setInitialBorderStyle(for textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = inactiveBorderColor.cgColor
    }
    
    // UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animatePlaceholder(for: textField, isEditing: true)
        changeBorderColor(for: textField, isActive: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animatePlaceholder(for: textField, isEditing: false)
        changeBorderColor(for: textField, isActive: false)
    }
    
    // MARK: - Update Placeholder Position if Text Exists
    func updatePlaceholderPosition(for textField: UITextField) {
        let placeholderLabel = getPlaceholderLabel(for: textField)
        
        if let text = textField.text, !text.isEmpty {
            // Animate the placeholder to the top and right if text exists
            placeholderLabel?.transform = CGAffineTransform(translationX: 30, y: -textField.bounds.height / 2)
            placeholderLabel?.font = UIFont.systemFont(ofSize: 12)
            placeholderLabel?.textColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
        } else {
            // Otherwise, reset the placeholder to the border position with the right offset
            placeholderLabel?.transform = CGAffineTransform(translationX: 30, y: 0)
            placeholderLabel?.font = UIFont.systemFont(ofSize: 16)
            placeholderLabel?.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Animate Placeholder Movement
    func animatePlaceholder(for textField: UITextField, isEditing: Bool) {
        let placeholderLabel = getPlaceholderLabel(for: textField)
        
        UIView.animate(withDuration: 0.3) {
            if isEditing {
                // Move placeholder label up and to the right to create a floating effect
                placeholderLabel?.transform = CGAffineTransform(translationX: 10, y: (-textField.bounds.height / 2)-10)
                placeholderLabel?.font = UIFont.systemFont(ofSize: 12)
                placeholderLabel?.textColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
            } else {
                if textField.text?.isEmpty ?? true {
                    // Return placeholder to original position with right offset if text is empty
                    placeholderLabel?.transform = CGAffineTransform(translationX: 30, y: 0)
                    placeholderLabel?.font = UIFont.systemFont(ofSize: 16)
                    placeholderLabel?.textColor = UIColor.lightGray
                }
            }
        }
    }
    
    // Changes the border color of the text field
    func changeBorderColor(for textField: UITextField, isActive: Bool) {
        let borderColor = isActive ? activeBorderColor : inactiveBorderColor
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = borderColor.cgColor
        }
    }
    
    // Helper function to get the correct placeholder label
    private func getPlaceholderLabel(for textField: UITextField) -> UILabel? {
        if textField == oldPasswordTF {
            return oldPasswordPlaceholderLabel
        } else if textField == newPasswordTF {
            return newPasswordPlaceholderLabel
        } else if textField == confirmNewPasswordTF {
            return confirmNewPasswordPlaceholderLabel
        }
        return nil
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordPattern = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        return passwordPred.evaluate(with: password)
    }
    
    
    // MARK: - Helper Function to Show Alerts
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let passwordText = newPasswordTF.text, let confirmpasswordText = confirmNewPasswordTF.text else {
            return
        }
        if !isValidPassword(passwordText) {
            showAlert(message: "Password must contain at least one letter, one number, one special character, and be at least 8 characters long.")
            return
        }
        if passwordText != confirmpasswordText {
            showAlert(message: "New Password and confirm Newpassword do not match.")
            return
        }
        
        if !passwordText.isEmpty {
            // Prepare parameters for the request
            print("ifff mte3 action")
            let parameters: [String: Any] = [
                "email": "admin12@gmail.com",
                "oldPassword": passwordText,
                "newPassword": confirmpasswordText
            ]
            print("les parametre ; " ,parameters)
            
            // Perform signup request
            sendSignupRequest(parameters: parameters)
            
            // Trigger the segue to the Settings page
            performSegue(withIdentifier: "cnrmfChngPsswd", sender: nil)
            
        }
    }
        
        // MARK: - Navigation
        /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "cnrmfChngPsswd" {
                // Pass any data to the SettingsViewController if needed
            }
        }*/
    
    // Sends the signup request to the server
    private func sendSignupRequest(parameters: [String: Any]) {
        guard let url = URL(string: "http://192.168.137.70:3000/auth/change-password") else { return }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            print("sendSignup", jsonData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print(jsonData)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                self.handleResponse(data: data, response: response, error: error)

            }
            
            // Start the request task
            task.resume()
            
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse?, error: Error?) {
        // Check if there’s an error in the response
        if let error = error {
            print("Request failed with error: \(error.localizedDescription)")
            return
        }
        
        // Check if we have a valid HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                print("Server returned an error status.")
                DispatchQueue.main.async {
                    self.showAlert(message: "Server error: \(httpResponse.statusCode)")
                }
                return
            }
        }
        
        // Attempt to parse the response as JSON
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
            
            if let jsonData = responseString.data(using: .utf8) {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        print(jsonResponse)
                        
                        // Proceed as before if JSON is correct
                        if let user = jsonResponse["user"] as? [String: Any],
                           let userName = user["name"] as? String {
                            print("User's name: \(userName)")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "home", sender: nil)
                            }
                            print("Signup is done successfully")
                            
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: "Email Already in Use")
                            }
                            print("Please enter a valid email.")
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error.localizedDescription)")
                }
            }
        }
    }

           
       
        
}

