//
//  ForgotPasswordViewController.swift
//  DamLeaders
//
//  Created by Mac Mini 9 on 5/11/2024.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {

    
    

    @IBOutlet weak var otpSMS: UITextField!
    @IBOutlet weak var otpMail: UITextField!
    
    // Border colors for active and inactive states
    let activeBorderColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
    let inactiveBorderColor = UIColor.lightGray
    
    var code :Int!
    var email : String!

    // Placeholder labels
    private var newpasswordPlaceholderLabel: UILabel!
    private var confirmNewpasswordPlaceholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addIcon(textField: otpMail, iconName: "envelope.fill")
        addIcon(textField: otpSMS, iconName: "message.fill")

        // Initialize and set up custom placeholder labels
        setupFloatingPlaceholder(for: otpMail, placeholderText: "Send OTP via E-mail")
        setupFloatingPlaceholder(for: otpSMS, placeholderText: "Send OTP via SMS")
        // Initial setup for the text fields
        setInitialBorderStyle(for: otpMail)
        setInitialBorderStyle(for: otpSMS)

        // Set the text field delegates
        otpMail.delegate = self
        otpSMS.delegate = self

        // Check if there is initial text in the text fields and update the placeholder position
        updatePlaceholderPosition(for: otpMail)
        updatePlaceholderPosition(for: otpSMS)
        
        
        
    }
    
    func addIcon(textField: UITextField, iconName: String) {
            // Create the SF Symbol icon as an UIImageView
             let icon = UIImage(systemName: iconName)
            let iconView = UIImageView(image: icon)
            iconView.tintColor = .gray
            iconView.contentMode = .scaleAspectFit
            iconView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)  // Adjust size if needed
            // Create a container view for padding
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))  // 24 width + 10 padding
            paddingView.addSubview(iconView)
        
            // Set the container view as the left view
            textField.leftView = paddingView
            textField.leftViewMode = .always
          
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

        if textField == otpMail {
            newpasswordPlaceholderLabel = placeholderLabel
        } else if textField == otpSMS {
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
        if textField == otpMail {
            return newpasswordPlaceholderLabel
        } else if textField == otpSMS {
            return confirmNewpasswordPlaceholderLabel
        }
        return nil
    }
    
    
    
    // MARK: - Validation Functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }

    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phonePattern = "^[0-9]{8,15}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phonePattern)
        return phonePred.evaluate(with: phoneNumber)
    }
    
    // Function to restrict text field input to only numeric characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Apply numeric-only validation for the otpSMS field
        if textField == otpSMS {
            // Allow only numeric characters
            let characterSet = CharacterSet(charactersIn: "0123456789")
            let filtered = string.rangeOfCharacter(from: characterSet.inverted)
            
            // If the replacement string contains non-numeric characters, return false to prevent the change
            if filtered != nil {
                return false
            }

            // Restrict the input to 15 characters maximum
            if let currentText = textField.text, currentText.count >= 15 && !string.isEmpty {
                return false // Reject input if there's already 15 characters
            }
        }
        
        // Allow all characters for otpMail (email input)
        return true
    }





    // Continue button action to validate fields
    @IBAction func continueAction(_ sender: Any) {
        
        
        guard let emailText = otpMail.text,let smsText = otpSMS.text else {
            
            return
        }

        // Check if at least one field is valid
        if isValidEmail(emailText) &&  smsText.isEmpty {
            
            
            let parameters: [String: Any] = [
                "email": emailText,
            ]
            email = emailText
            sendSignupRequest(parameters: parameters)
            
            
            
            // Proceed with OTP sending if either email or phone number is valid
            // Example: sendOTP(email: emailText, phone: smsText)
        } else {
            // Show alert if neither field is valid
            showAlert(message: "Please enter a valid email or phone number.")
        }
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otp"{
            if let (email, code) = sender as? (String, Int) {
                let destination = segue.destination as! OtpViewController
                destination.email = email
                destination.otp = code
                print(code,"________________________________")
            } else {
                print("Sender does not contain the expected data")
            }
        }
    }

    // Helper function to show alerts
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // Sends the signup request to the server
       private func sendSignupRequest(parameters: [String: Any]) {
           guard let url = URL(string: "http://192.168.236.55:3000/auth/forgot-password") else { return }

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
           struct ForgotPasswordData: Decodable {
               let code: Int
               let user : String
               
           }
           if let responseString = String(data: data, encoding: .utf8) {
               print("Response: \(responseString)")
               
               
              // code = responseString.codingKey[]

               // Attempt to parse the response as JSON
               if let jsonData = responseString.data(using: .utf8) {
                   print ("_______________________________>1")

                   do {
                       if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                           // Vérifier le code de statut
                           print ("_______________________________>2")
                        
                           if let statusCode = jsonResponse["statusCode"] as? Int {
                               print("Status Code: \(statusCode)")
                               print ("_______________________________>33")

                               if statusCode == 200 {
                                   print("Inscription réussie")
                                   
                                   // Extraire l'ID utilisateur et effectuer la transition si disponible
                                  /* if let userId = jsonResponse["userId"] as? String {
                                       DispatchQueue.main.async {
                                           self.performSegue(withIdentifier: "home", sender: userId)
                                       }
                                   }*/
                                   
                                   // Décoder le JSON pour obtenir d'autres informations (ex: code)
                                  // if let jsonData = responseString.data(using: .utf8) {
                               //    if  let yesser = try JSONDecoder().decode(ForgotPasswordData.self, from: jsonData){
                                   if let code = jsonResponse["code"] as? Int ,
                                      let email = jsonResponse["email"] as? String {
                                       
                                       print("---------------------------------------")
                                       DispatchQueue.main.async {
                                           self.performSegue(withIdentifier: "otp", sender: (email ,code))
                                       }
                                   }
                                   
                               } else if statusCode == 400 || statusCode == 401 {
                                   // Gérer le cas des codes de statut 400 ou 401
                                   print("Veuillez entrer un email valide.")
                                   DispatchQueue.main.async {
                                       self.showAlert(message: "Email non existant.")
                                       // Ou activer les modifications d'interface utilisateur
                                       // self.wrong_outlet.text = "Identifiants incorrects"
                                       // self.wrong_outlet.setNeedsLayout()
                                       // self.wrong_outlet.layoutIfNeeded()
                                   }
                               }
                           }
                       }
                   } catch {
                       print("Échec de l'analyse JSON: \(error.localizedDescription)")
                   }
               }

           }
       }
    
     
    
    

}
