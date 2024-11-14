
import UIKit
class OtpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackOtp: UIStackView!
    @IBOutlet weak var numberTF1: UITextField!
    @IBOutlet weak var numberTF2: UITextField!
    @IBOutlet weak var numberTF3: UITextField!
    @IBOutlet weak var numberTF4: UITextField!
    @IBOutlet weak var numberTF5: UITextField!
    @IBOutlet weak var numberTF6: UITextField!
    
    var otp: Int?
    var resetToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("resetToken", resetToken)
        print("--------otp--------", otp)
      
        // Apply custom styling to each text field
        customizeTextField(numberTF1)
        customizeTextField(numberTF2)
        customizeTextField(numberTF3)
        customizeTextField(numberTF4)
        customizeTextField(numberTF5)
        customizeTextField(numberTF6)
        
        // Set the delegate for each text field
        numberTF1.delegate = self
        numberTF2.delegate = self
        numberTF3.delegate = self
        numberTF4.delegate = self
        numberTF5.delegate = self
        numberTF6.delegate = self
    }
    
    // Helper function to apply the same styling to each text field
    func customizeTextField(_ textField: UITextField) {
        textField.textColor = UIColor.blue
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.backgroundColor = UIColor(red: 219/255, green: 211/255, blue: 255/255, alpha: 0.2)
        textField.layer.borderColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    // Function to restrict text field input to only numeric characters and enforce 1 character per field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: "0123456789")
        if string.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false
        }

        if let currentText = textField.text, currentText.count >= 1 && !string.isEmpty {
            return false
        }
        
        // After valid input, move to the next text field
        if string.count == 1 {
            let textFields = [numberTF1, numberTF2, numberTF3, numberTF4, numberTF5, numberTF6]
            if let index = textFields.firstIndex(of: textField), index < textFields.count - 1 {
                DispatchQueue.main.async {
                    textFields[index + 1]?.becomeFirstResponder()
                }
            }
        }
        
        return true
    }
    
    // Continue button action to trigger validation
    @IBAction func continueAction(_ sender: Any) {
        let textFields = [numberTF1, numberTF2, numberTF3, numberTF4, numberTF5, numberTF6]
        
        // Affiche la valeur de chaque champ pour vérifier l'entrée
        for (index, textField) in textFields.enumerated() {
            print("Text Field \(index + 1): \(textField?.text ?? "nil")")
        }

        // Combine les valeurs en une seule chaîne
        let codeOtpEnter = textFields.compactMap { $0?.text }.joined()
        print("OTP Entered: \(codeOtpEnter)")

        if  otp == Int(codeOtpEnter) {
            // Utiliser otpValue pour la vérification
          //  print("OTP as integer: \(otp)")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "newPassword", sender: self.resetToken)
            }
        } else {
            print("Invalid OTP input")
            showAlert(message: "Invalid OTP input")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPassword" {
            if let resetToken = sender as? String {
                let destination = segue.destination as! ResetPasswordViewController
                destination.emailSeg = resetToken
                print(resetToken, "________________________________")
            } else {
                print("Sender does not contain the expected data")
            }
        }
    }
    
    // Helper function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


/*import UIKit
class OtpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackOtp: UIStackView!
    @IBOutlet weak var numberTF1: UITextField!
    @IBOutlet weak var numberTF2: UITextField!
    @IBOutlet weak var numberTF3: UITextField!
    @IBOutlet weak var numberTF4: UITextField!
    @IBOutlet weak var numberTF5: UITextField!
    @IBOutlet weak var numberTF6: UITextField!
    
    var otp : Int?
    var resetToken : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("resetToken",resetToken as Any)
        print("--------otp--------", otp)
      
        
        // Apply custom styling to each text field
        customizeTextField(numberTF1)
        customizeTextField(numberTF2)
        customizeTextField(numberTF3)
        customizeTextField(numberTF4)
        customizeTextField(numberTF5)
        customizeTextField(numberTF6)
        
        // Set the delegate for each text field
        numberTF1.delegate = self
        numberTF2.delegate = self
        numberTF3.delegate = self
        numberTF4.delegate = self
        numberTF5.delegate = self
        numberTF6.delegate = self
    }
    
    // Helper function to apply the same styling to each text field
    func customizeTextField(_ textField: UITextField) {
        textField.textColor = UIColor.blue
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.backgroundColor = UIColor(red: 219/255, green: 211/255, blue: 255/255, alpha: 0.2)
        textField.layer.borderColor = UIColor(red: 19/255, green: 1/255, blue: 96/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    // Function to restrict text field input to only numeric characters and enforce 1 character per field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only numeric characters
        let characterSet = CharacterSet(charactersIn: "0123456789")
        let filtered = string.rangeOfCharacter(from: characterSet.inverted)
        
        // If the replacement string contains non-numeric characters, return false to prevent the change
        if filtered != nil {
            return false
        }

        // Allow only one numeric character per text field
        if let currentText = textField.text, currentText.count >= 1 && !string.isEmpty {
            return false // Reject input if there's already one character
        }
        
        // After valid input, move to the next text field
        if string.count == 1 {  // Check if user entered a character
            if let textFields = [numberTF1, numberTF2, numberTF3, numberTF4, numberTF5, numberTF6] as? [UITextField] {
                if let index = textFields.firstIndex(of: textField), index < textFields.count - 1 {
                    // Move to the next text field after the input
                    DispatchQueue.main.async {
                        textFields[index + 1].becomeFirstResponder()
                    }
                }
            }
        }
        
        return true
    }
    
    // Continue button action to trigger validation
    @IBAction func continueAction(_ sender: Any) {
        
        /*let codeOtpEnter = (numberTF1.text ?? "") + (numberTF2.text ?? "") + (numberTF3.text ?? "") + (numberTF4.text ?? "") + (numberTF5.text ?? "") + (numberTF6.text ?? "")*/
        let text1 = numberTF1.text ?? ""
        let text2 = numberTF2.text ?? ""
        let text3 = numberTF3.text ?? ""
        let text4 = numberTF4.text ?? ""
        let text5 = numberTF5.text ?? ""
        let text6 = numberTF6.text ?? ""

        let codeOtpEnter = text1 + text2 + text3 + text4 + text5 + text6


        if let otp = Int(codeOtpEnter) {
            // Use otpInt as your integer representation of the OTP
            print("OTP as integer: \(otp)")
            print(<#T##items: Any...##Any#>)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "newPassword", sender: self.resetToken)
            }
            
        } else {
            print("Invalid OTP input")
            showAlert(message: "Invalid OTP input")
        }

        
        
       /* if validateTextFields() {
            
        
            // Proceed with further action (e.g., OTP verification)
        }*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  print(email ?? <#default value#>)
        if segue.identifier == "newPassword"{
            if let email = sender as? String {
                let destination = segue.destination as! ResetPasswordViewController
                destination.emailSeg = resetToken
              //  destination.otp = code
                print(email,"________________________________")
            } else {
                print("Sender does not contain the expected data")
            }
        }
    }
    
    // Function to validate that each text field contains exactly one number
    func validateTextFields() -> Bool {
        // Iterate over all the text fields
        let textFields = [numberTF1, numberTF2, numberTF3, numberTF4, numberTF5, numberTF6]
        
        for textField in textFields {
            if let text = textField?.text, !text.isEmpty {
                // Count the number of numeric characters
                let numberCount = text.filter { $0.isNumber }.count
                
                // If the count is not exactly 1, show an alert
                if numberCount != 1 {
                    showAlert(message: "Each field must contain exactly one number.")
                    return false
                }
            } else {
                showAlert(message: "All fields must be filled.")
                return false
            }
        }
        
        return true
    }

    // Helper function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

*/

