import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var fnameTF: UITextField!
    @IBOutlet weak var lNameTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    // Border colors for active and inactive states
    let activeBorderColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
    let inactiveBorderColor = UIColor.lightGray

    // Placeholder labels
    private var fnamePlaceholderLabel: UILabel!
    private var lnamePlaceholderLabel: UILabel!
    private var emailPlaceholderLabel: UILabel!
    private var passwordPlaceholderLabel: UILabel!
    private var confirmPasswordPlaceholderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize icon and placeholder for each text field
        addIcon(textField: fnameTF, iconName: "person.fill")
        addIcon(textField: lNameTF, iconName: "person.fill")
        addIcon(textField: emailTF, iconName: "envelope.fill")
        addIcon(textField: passwordTF, iconName: "lock.fill")
        addIcon(textField: confirmPasswordTF, iconName: "lock.fill")
        
        setupFloatingPlaceholder(for: fnameTF, placeholderText: "First Name")
        setupFloatingPlaceholder(for: lNameTF, placeholderText: "Last Name")
        setupFloatingPlaceholder(for: emailTF, placeholderText: "Email")
        setupFloatingPlaceholder(for: passwordTF, placeholderText: "Password")
        setupFloatingPlaceholder(for: confirmPasswordTF, placeholderText: "Confirm Password")

        // Initial setup for the text fields
        setInitialBorderStyle(for: fnameTF)
        setInitialBorderStyle(for: lNameTF)
        setInitialBorderStyle(for: emailTF)
        setInitialBorderStyle(for: passwordTF)
        setInitialBorderStyle(for: confirmPasswordTF)

        // Set the text field delegates
        fnameTF.delegate = self
        lNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self

        // Check if there is initial text in the text fields and update the placeholder position
        updatePlaceholderPosition(for: fnameTF)
        updatePlaceholderPosition(for: lNameTF)
        updatePlaceholderPosition(for: emailTF)
        updatePlaceholderPosition(for: passwordTF)
        updatePlaceholderPosition(for: confirmPasswordTF)
        
        // Set up the initial state for password visibility
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true

        


        // Set up the toggle buttons inside text fields
        setupPasswordToggleButton(for: passwordTF)
        setupPasswordToggleButton(for: confirmPasswordTF)

    }
    
    // Function to add icon to text field
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
   
    func showSuccessMessage() {
              let alert = UIAlertController(title: "Success", message: "signup is done successfully!", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                  // Perform segue after the user taps OK
                  self.performSegue(withIdentifier: "toHome", sender: nil)
              }))
              present(alert, animated: true)
          }



    
    // MARK: - Toggle Password Visibility
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        // Toggle visibility of the password field
        if sender == passwordTF.rightView?.subviews.first as? UIButton {
            passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
            let imageName = passwordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
            sender.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else if sender == confirmPasswordTF.rightView?.subviews.first as? UIButton {
            confirmPasswordTF.isSecureTextEntry = !confirmPasswordTF.isSecureTextEntry
            let imageName = confirmPasswordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
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

        // Assign the placeholder label to the correct property
        switch textField {
        case fnameTF:
            fnamePlaceholderLabel = placeholderLabel
        case lNameTF:
            lnamePlaceholderLabel = placeholderLabel
        case emailTF:
            emailPlaceholderLabel = placeholderLabel
        case passwordTF:
            passwordPlaceholderLabel = placeholderLabel
        case confirmPasswordTF:
            confirmPasswordPlaceholderLabel = placeholderLabel
        default:
            break
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
            placeholderLabel?.transform = CGAffineTransform(translationX: 30, y: -textField.bounds.height / 2)
            placeholderLabel?.font = UIFont.systemFont(ofSize: 12)
            placeholderLabel?.textColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
        } else {
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
                placeholderLabel?.transform = CGAffineTransform(translationX: 10, y: -textField.bounds.height / 2-10)
                placeholderLabel?.font = UIFont.systemFont(ofSize: 12)
                placeholderLabel?.textColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
            } else if textField.text?.isEmpty ?? true {
                placeholderLabel?.transform = CGAffineTransform(translationX: 30, y: 0)
                placeholderLabel?.font = UIFont.systemFont(ofSize: 16)
                placeholderLabel?.textColor = UIColor.lightGray
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
        switch textField {
        case fnameTF:
            return fnamePlaceholderLabel
        case lNameTF:
            return lnamePlaceholderLabel
        case emailTF:
            return emailPlaceholderLabel
        case passwordTF:
            return passwordPlaceholderLabel
        case confirmPasswordTF:
            return confirmPasswordPlaceholderLabel
        default:
            return nil
        }
    }
    
    // MARK: - Validation Functions
        private func isValidName(_ name: String) -> Bool {
            let namePattern = "^[A-Za-z]{2,}$"  // Only letters, at least 2 characters
            let namePred = NSPredicate(format: "SELF MATCHES %@", namePattern)
            return namePred.evaluate(with: name)
        }
        
        private func isValidEmail(_ email: String) -> Bool {
            let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-_%+-]+\\.[A-Za-z_%+-]{2,64}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailPattern)
            return emailPred.evaluate(with: email)
        }

        private func isValidPassword(_ password: String) -> Bool {
            let passwordPattern = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
            let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
            return passwordPred.evaluate(with: password)
        }

    
        @IBAction func SingUpAction(_ sender: Any) {
            var a = 0
            guard let fname = fnameTF.text, let lname = lNameTF.text,
                  let emailText = emailTF.text, let passwordText = passwordTF.text, let confirmpasswordText = confirmPasswordTF.text else {
                return
            }

            if !isValidName(fname) {
                showAlert(message: "First name must contain only letters and be at least 2 characters long.")
                a = 1
                return
            }

            if !isValidName(lname) {
                showAlert(message: "Last name must contain only letters and be at least 2 characters long.")
                a = 1
                return
            }

            if !isValidEmail(emailText) {
                showAlert(message: "Please enter a valid email.")
                a = 1
                return
            }

            if !isValidPassword(passwordText) {
                showAlert(message: "Password must contain at least one letter, one number, one special character, and be at least 8 characters long.")
                a = 1
                return
            }
            if passwordText != confirmpasswordText {
                a = 1
                showAlert(message: "Password and confirm password do not match.")
                return
            }
            if a == 0{
                let parameters: [String: Any] = [
                    "email": emailText,
                    "password": passwordText,
                    "name": fname+lname
                ]
                    print("les parametre ; " ,parameters)

                // Perform signup request
                sendSignupRequest(parameters: parameters)
                
         
            }
            
            
      

            // Proceed with login if validation is successful
            // Example: loginUser(email: emailText, password: passwordText)
        }

        // MARK: - Helper Function to Show Alerts
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    // MARK: - Helper Function to Show Alerts


    
    
    
    
    // Sends the signup request to the server
       private func sendSignupRequest(parameters: [String: Any]) {
           guard let url = URL(string: "http://172.18.4.2:3000/auth/signup") else { return }

           do {
               let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
               print("sendSignup" ,jsonData)

               var request = URLRequest(url: url)
               request.httpMethod = "POST"
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
                           if let statusCode = jsonResponse["name"] as? String {
                               // If status code is 200, perform the segue to "home"
                               print(statusCode)
                               if !statusCode.isEmpty {
                                   print("signup is done sucessfully")
                                   if let userId = jsonResponse["name"] as? String{
                                                                  // Save userId to pass it to the next screen
                                                                  DispatchQueue.main.async {
                                                                    //  self.performSegue(withIdentifier: "home", sender: userId)
                                                                      self.showSuccessMessage()

                                                                  }
                                                              }
                               } else  {
                                   // Handle the specific action for status code 400 (e.g., Email already in use)
                                  
                                     /*      DispatchQueue.main.async {
                                               self.wrong_outlet.text = "Wrong credentials"
                                               self.wrong_outlet.setNeedsLayout()
                                               self.wrong_outlet.layoutIfNeeded()
                                           
                                       
                                   }*/
                                   print("Please enter a valid email.")
                                   
                               }
                           }
                       }
                   } catch {
                       print("Failed to parse JSON: \(error.localizedDescription)")
                   }
               }
           }
       }

    

    @IBAction func termsconditions(_ sender: Any) {
            // Trigger the segue to the Settings page
            performSegue(withIdentifier: "termsSeg", sender: nil)
    }
        


}
