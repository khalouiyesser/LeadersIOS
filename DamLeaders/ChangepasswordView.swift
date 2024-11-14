import SwiftUI

struct ChangePasswordView: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var showOldPassword: Bool = false
    @State private var showNewPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var alertMessage: String? = nil
    @State private var isAlertPresented: Bool = false

    private let activeBorderColor = Color.blue
    private let inactiveBorderColor = Color.gray

    var body: some View {
        VStack {
            // Old Password Field
            CustomTextField(
                text: $oldPassword,
                placeholder: "Old Password",
                isSecure: !showOldPassword,
                showPasswordToggle: true,
                borderColor: oldPassword.isEmpty ? inactiveBorderColor : activeBorderColor,
                togglePasswordVisibility: { showOldPassword.toggle() }
            )

            // New Password Field
            CustomTextField(
                text: $newPassword,
                placeholder: "New Password",
                isSecure: !showNewPassword,
                showPasswordToggle: true,
                borderColor: newPassword.isEmpty ? inactiveBorderColor : activeBorderColor,
                togglePasswordVisibility: { showNewPassword.toggle() }
            )

            // Confirm New Password Field
            CustomTextField(
                text: $confirmNewPassword,
                placeholder: "Confirm Password",
                isSecure: !showConfirmPassword,
                showPasswordToggle: true,
                borderColor: confirmNewPassword.isEmpty ? inactiveBorderColor : activeBorderColor,
                togglePasswordVisibility: { showConfirmPassword.toggle() }
            )

            // Confirm Button
            Button(action: confirmAction) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
            }

        }
        .padding()
    }

    private func confirmAction() {
        guard isValidPassword(newPassword) else {
            alertMessage = "Password must contain at least one letter, one number, one special character, and be at least 8 characters long."
            isAlertPresented = true
            return
        }
        
        guard newPassword == confirmNewPassword else {
            alertMessage = "New Password and confirm New password do not match."
            isAlertPresented = true
            return
        }

        // Simulate network request or any other action
        sendSignupRequest()
    }

    private func sendSignupRequest() {
        // Prepare parameters for the request
        let parameters: [String: Any] = [
            "email": "admin12@gmail.com",
            "oldPassword": oldPassword,
            "newPassword": confirmNewPassword
        ]
        print("Sending request with parameters: \(parameters)")

        // Your network call here...
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordPattern = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        return passwordPred.evaluate(with: password)
    }
}

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var showPasswordToggle: Bool
    var borderColor: Color
    var togglePasswordVisibility: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                    .padding(.vertical, 12)
            }
            HStack {
                SecureField("", text: $text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .padding(.horizontal)

                if showPasswordToggle {
                    Button(action: togglePasswordVisibility) {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}

