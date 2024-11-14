import SwiftUI

struct Settings: View {
    @State private var isDarkMode = false
    @State private var showUIKitPage = false
    
    var body: some View {
        VStack {
            // ZStack pour positionner l'image et le texte en haut à gauche
            ZStack(alignment: .topLeading) {
                // Background Gradient
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "130160"), Color(hex: "36353C")]), // Utilisation des couleurs hexadécimales
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 180)
                
                VStack(spacing: 8) {
                    // Profile image
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                         .padding(.leading,-80) // Espacement de la gauche

                    
                    // User name and email
                    Text("Shayma Ouerhani")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading,-20) // Espacement de la gauche

                    Text("shayma.ouerhani@esprit.tn")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading,20) // Espacement de la gauche

                    
                }
                .padding(.top, 30) // Espacement du haut
            }
            .padding()
            
            // Settings options
            VStack(spacing: 16) {
                // Dark mode toggle
                Toggle(isOn: $isDarkMode) {
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.gray)
                        Text("Dark Mode")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                // Password option
               /*NavigationLink(destination: ChangePasswordViewControllerWrapper()) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        Text("Password")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }*/
                Button(action: {
                            showUIKitPage.toggle()  // This will trigger the sheet presentation
                        }) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                Text("Password")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        .sheet(isPresented: $showUIKitPage) {
                            ChangePasswordViewControllerWrapper() // The UIKit view controller to present
                        }
            
                // Logout option
                NavigationLink(destination: Text("Logout")) {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.gray)
                        Text("Logout")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Bottom navigation bar
           
           
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationTitle("My Profile V1")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}



// Sends the signup request to the server
   private func sendSignupRequest(parameters: [String: Any]) {
       guard let url = URL(string: "http://192.168.236.55:3000/auth/signup") else { return }

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

            handleResponse(data: data)
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
                               if jsonResponse["name"] is String{
                                   // Save userId to pass it to the next
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


