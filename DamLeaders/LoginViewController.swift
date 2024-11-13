//
//  LoginViewController.swift
//  DamLeaders
//
//  Created by Mac Mini 9 on 5/11/2024.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    let activeBorderColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0)
    let inactiveBorderColor = UIColor.lightGray
    
    // Placeholder labels
    private var newpasswordPlaceholderLabel: UILabel!
    private var confirmNewpasswordPlaceholderLabel: UILabel!
    
    override func viewDidLoad() {
        addIcon(textField: email, iconName: "envelope.fill")
        addIcon(textField: passwordTF, iconName: "lock.fill")
        //togglePasswordVisibilityButton.tintColor = UIColor(red: 130/255, green: 160/255, blue: 255/255, alpha: 1.0)
        
        super.viewDidLoad()
        
        
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
        
        // Initialize and set up custom placeholder labels
        setupFloatingPlaceholder(for: email, placeholderText: "Email")
        setupFloatingPlaceholder(for: passwordTF, placeholderText: "Password")
        // Initial setup for the text fields
        setInitialBorderStyle(for: email)
        setInitialBorderStyle(for: passwordTF)
        
        // Set the text field delegates
        email.delegate = self
        passwordTF.delegate = self
        
        // Check if there is initial text in the text fields and update the placeholder position
        updatePlaceholderPosition(for: email)
        updatePlaceholderPosition(for: passwordTF)
        
        
        // Set up the initial state for password visibility
        passwordTF.isSecureTextEntry = true
        
        // Set up the toggle buttons inside text fields
        setupPasswordToggleButton(for: passwordTF)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
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
        if sender == passwordTF.rightView?.subviews.first as? UIButton {
            passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
            let imageName = passwordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
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
        
        if textField == email {
            newpasswordPlaceholderLabel = placeholderLabel
        } else if textField == passwordTF {
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
        if textField == email {
            return newpasswordPlaceholderLabel
        } else if textField == passwordTF {
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
    
    // MARK: - Helper Function to Show Alerts
   private func showAlert(message: String) {
       let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
       present(alert, animated: true, completion: nil)
   }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        
        guard let emailText = email.text, let passwordText = passwordTF.text else {
            return
        }
        
        /* if isValidEmail(emailText) {
         showAlert(message: "Please enter a valid email.")
         return
         }*/
        
        if passwordText.isEmpty {
            showAlert(message: "Password is empty")
            return
        }
        
        if /*isValidEmail(emailText) && */!passwordText.isEmpty {
            // Prepare parameters for the request
            print("ifff mte3 action")
            let parameters: [String: Any] = [
                "email": emailText,
                "password": passwordText
            ]
            print("les parametre ; " ,parameters)
            
            // Perform signup request
            sendSignupRequest(parameters: parameters)
            
            
        }
        
        // Proceed with login if validation is successful
        // Example: loginUser(email: emailText, password: passwordText)
    }
    
    
        
        
        // Sends the signup request to the server
         private func sendSignupRequest(parameters: [String: Any]) {
         guard let url = URL(string: "http://172.18.4.2:3000/auth/login") else { return }
         do {
         let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
         print("sendSignup", jsonData)
         
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
            
            if let jsonData = responseString.data(using: .utf8) {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        print(jsonResponse)
                        
                        if let user = jsonResponse["user"] as? [String: Any], let userName = user["name"] as? String {
                            print("User's name: \(userName)")
                            
                            DispatchQueue.main.async {
                                // Vérification de l'existence du AppDelegate et du contexte
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    let context = appDelegate.persistentContainer.viewContext
                                    
                                    // Créer la vue SwiftUI et lui passer le contexte
                                    let swiftUIView = Home()  // Remplacez avec la vue que vous souhaitez afficher
                                    
                                    // Assurez-vous que le contexte est bien passé à l'environnement SwiftUI
                                    let hostController = UIHostingController(rootView: swiftUIView.environment(\.managedObjectContext, context))
                                    
                                    // Vérification de l'existence de navigationController
                                    if let navigationController = self.navigationController {
                                        navigationController.pushViewController(hostController, animated: true)
                                    } else {
                                        print("NavigationController is nil.")
                                        self.showAlert(message: "La navigation échoue car il n'y a pas de NavigationController.")
                                    }
                                } else {
                                    print("AppDelegate not found or invalid!")
                                    self.showAlert(message: "Une erreur est survenue lors de la récupération du contexte.")
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: "Erreur de connexion. Vérifiez vos informations.")
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showAlert(message: "Erreur de traitement de la réponse.")
                    }
                }
            }
        }
    }

        
    /*  yesser

    // Sends the signup request to the server
       private func sendSignupRequest(parameters: [String: Any]) {
           guard let url = URL(string: "http://172.18.4.2:3000/auth/login") else { return }

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
                                
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error.localizedDescription)")
                }
            }
        }}*/
        
    }
