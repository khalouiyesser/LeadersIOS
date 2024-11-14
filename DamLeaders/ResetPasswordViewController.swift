import UIKit
class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newpasswordTF: UITextField!
    @IBOutlet weak var confirmNewpasswordTF: UITextField!
    
    
    
    //var email : String = ""
    
    // Border colors for active and inactive states
    let activeBorderColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
    let inactiveBorderColor = UIColor.lightGray

    // Placeholder labels
    private var newpasswordPlaceholderLabel: UILabel!
    private var confirmNewpasswordPlaceholderLabel: UILabel!

    override func viewDidLoad() {
        addIcon(textField: newpasswordTF, iconName: "lock.fill")
        addIcon(textField: confirmNewpasswordTF, iconName: "lock.fill")
        super.viewDidLoad()

        print("dedloge" , emailSeg)
        
        func addIcon(textField: UITextField, iconName: String) {
                // Create the SF Symbol icon as an UIImageView
                 let icon = UIImage(systemName: iconName)
                let iconView = UIImageView(image: icon)
                iconView.tintColor = .gray  // Set icon color
                iconView.contentMode = .scaleAspectFit
                iconView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)  // Adjust size if needed
                // Create a container view for padding
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))  // 24 width + 10 padding
                paddingView.addSubview(iconView)
            
                // Set the container view as the left view
                textField.leftView = paddingView
                textField.leftViewMode = .always
              
            }
        
        
        
        
        // Initialize and set up custom placeholder labels
        setupFloatingPlaceholder(for: newpasswordTF, placeholderText: "New Password")
        setupFloatingPlaceholder(for: confirmNewpasswordTF, placeholderText: "Confirm Password")

        // Initial setup for the text fields
        setInitialBorderStyle(for: newpasswordTF)
        setInitialBorderStyle(for: confirmNewpasswordTF)

        // Set the text field delegates
        newpasswordTF.delegate = self
        confirmNewpasswordTF.delegate = self

        // Check if there is initial text in the text fields and update the placeholder position
        updatePlaceholderPosition(for: newpasswordTF)
        updatePlaceholderPosition(for: confirmNewpasswordTF)
        
        // Set up the initial state for password visibility
        newpasswordTF.isSecureTextEntry = true
        confirmNewpasswordTF.isSecureTextEntry = true

        // Set up the toggle buttons inside text fields
        setupPasswordToggleButton(for: newpasswordTF)
        setupPasswordToggleButton(for: confirmNewpasswordTF)
    }
    
    
    // MARK: - Set up Password Toggle Buttons Inside Text Fields
    func setupPasswordToggleButton(for textField: UITextField) {
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
        rightView.addSubview(toggleButton)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
    }
    
    // MARK: - Toggle Password Visibility
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        // Toggle visibility of the password field
        if sender == newpasswordTF.rightView?.subviews.first as? UIButton {
            newpasswordTF.isSecureTextEntry = !newpasswordTF.isSecureTextEntry
            let imageName = newpasswordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
            sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else if sender == confirmNewpasswordTF.rightView?.subviews.first as? UIButton {
            confirmNewpasswordTF.isSecureTextEntry = !confirmNewpasswordTF.isSecureTextEntry
            let imageName = confirmNewpasswordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
            sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    
    
    // MARK: - Setup Floating Placeholder
    func setupFloatingPlaceholder(for textField: UITextField, placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        textField.addSubview(placeholderLabel)
        placeholderLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 8).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true

        if textField == newpasswordTF {
            newpasswordPlaceholderLabel = placeholderLabel
        } else if textField == confirmNewpasswordTF {
            confirmNewpasswordPlaceholderLabel = placeholderLabel
        }
    }

    // MARK: - Initial Border Setup
    func setInitialBorderStyle(for textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = inactiveBorderColor.cgColor
    }

    // MARK: - UITextField Delegate Methods

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

    // MARK: - Change Border Color
    func changeBorderColor(for textField: UITextField, isActive: Bool) {
        let borderColor = isActive ? activeBorderColor : inactiveBorderColor
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = borderColor.cgColor
        }
    }
    
    // Helper function to get the correct placeholder label
    private func getPlaceholderLabel(for textField: UITextField) -> UILabel? {
        if textField == newpasswordTF {
            return newpasswordPlaceholderLabel
        } else if textField == confirmNewpasswordTF {
            return confirmNewpasswordPlaceholderLabel
        }
        return nil
    }
    
    //******************  password Validation  *****************//
    
    
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
    
    
 
    //******************  Action & Request  *****************//
    var emailSeg : String = ""
    
    
    @IBAction func saveButton(_ sender: Any) {
        var a = 0
        guard let passwordText = newpasswordTF.text, let confirmpasswordText = confirmNewpasswordTF.text else {
            return
        }
        if !isValidPassword(passwordText) {
            showAlert(message: "Password must contain at least one letter, one number, one special character, and be at least 8 characters long.")
            a = 1
            return
        }
        if passwordText != confirmpasswordText {
            showAlert(message: "New Password and confirm Newpassword do not match.")
            a = 1
            return
        }
        if a == 0{
            print(emailSeg)
            
            print(emailSeg)
            
            let parameters: [String: Any] = [
                "resetToken": emailSeg,
                "newPassword" : newpasswordTF.text!,
            ]
            sendSignupRequest(parameters: parameters)
        }
    }
    
    // Sends the signup request to the server
       private func sendSignupRequest(parameters: [String: Any]) {
           guard let url = URL(string: "http://192.168.137.70:3000/auth/reset-password") else { return }

           do {
               let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
               print("sendSignup" ,jsonData)
               print(parameters)
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

                   self.handleResponse(data: data)
               }

               // Start the request task
               task.resume()

           } catch {
               print("Error serializing JSON: \(error.localizedDescription)")
           }
       }

       // Handles the response from the server
       private func handleResponse(data: Data) {
           if let responseString = String(data: data, encoding: .utf8) {
               print("Response: \(responseString)")

               // Attempt to parse the response as JSON
               if let jsonData = responseString.data(using: .utf8) {
                   do {
                       if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                           // Check the status code
                           if let statusCode = jsonResponse["statusCode"] as? Int {
                               // If status code is 200, perform the segue to "home"
                               print(statusCode)
                               if statusCode == 200 {
                                   print("signup is done sucessfully")
                                   if let userId = jsonResponse["userId"] as? String{
                                                                  // Save userId to pass it to the next screen
                                                                  DispatchQueue.main.async {
                                                                      self.performSegue(withIdentifier: "home", sender: userId)
                                                                  }
                                                              }
                               } else if statusCode == 400  || statusCode ==   401  {
                                   // Handle the specific action for status code 400 (e.g., Email already in use)
                                  
                                     /*      DispatchQueue.main.async {
                                               self.wrong_outlet.text = "Wrong credentials"
                                               self.wrong_outlet.setNeedsLayout()
                                               self.wrong_outlet.layoutIfNeeded()
                                           
                                       
                                   }*/
                                   print("Please enter a valid email.")
                                   
                               }else {
                                   print("50000000")
                               }
                           }
                       }
                   } catch {
                       print("Failed to parse JSON: \(error.localizedDescription)")
                   }
               }
           }
       }
    
}
