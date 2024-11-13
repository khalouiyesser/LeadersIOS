//
//  Home.swift
//  DamLeaders
//
//  Created by Leaders on 11/11/2024.
//

import Foundation
import SwiftUI
import AVKit

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct HomeView: View {
    @State private var index: Int = 0
    @State private var data = [/* Your data here */]

    var body: some View {
        ZStack {
            // Background ScrollView content, like your PlayerScrollView
            PlayerScrollView(data: self.$data)
            
            VStack {
                // Your other content, like header, title, etc.
                Spacer() // This pushes the navbar to the bottom

                // Bottom Navbar
                HStack(spacing: 0) {
                    Button(action: { self.index = 0 }) {
                        Image("abri")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 0 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 0)

                    Button(action: { self.index = 1 }) {
                        Image("profil")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 1 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 0)

                    Button(action: {}) {
                        Image("plus")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 0)

                    Button(action: { self.index = 2 }) {
                        Image("livre")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 2 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 0)

                    Button(action: { self.index = 3 }) {
                        Image("settings")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 3 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .background(Color.white) // Background for the navbar
                .padding(.bottom, UIApplication.shared.connectedScenes
                    .compactMap { ($0 as? UIWindowScene)?.windows.first }
                    .first?.safeAreaInsets.bottom ?? 0) // Adjust for bottom safe area
            }
            .padding(.top, UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first }
                .first?.safeAreaInsets.top ?? 0) // Adjust for top safe area
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
    
struct PlayerView : View {
        
    @Binding var data : [Video]
        
    var body: some View {
        
        VStack(spacing: 0) {
                
            ForEach(data.indices, id: \.self) { index in
                
                ZStack {
                    
                    Player(player: data[index].player)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .offset(y: -5)
                    
                    if data[index].replay {
                        Button(action: {
                            data[index].replay = false
                            data[index].player.seek(to: .zero)
                            data[index].player.play()
                        }) {
                            Image(systemName: "goforward")
                                .resizable()
                                .frame(width: 55, height: 60)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.data[0].player.play()
            self.data[0].player.actionAtItemEnd = .none
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.data[0].player.currentItem, queue: .main) { (_) in
                self.data[0].replay = true
            }
        }
    }
}
    
struct Player : UIViewControllerRepresentable {
        
    var player : AVPlayer
        
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let view = AVPlayerViewController()
        view.player = player
        view.showsPlaybackControls = false
        view.videoGravity = .resizeAspectFill
        view.view.isOpaque = true // Set isOpaque to true
        
        return view
    }
        
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}
    
class Host : UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
    
struct Video : Identifiable {
    var id : Int
    var player : AVPlayer
    var replay : Bool
}
    
struct PlayerScrollView : UIViewRepresentable {
        
    func makeCoordinator() -> Coordinator {
        return PlayerScrollView.Coordinator(parent1: self)
    }
        
    @Binding var data : [Video]
        
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        let childView = UIHostingController(rootView: PlayerView(data: self.$data))
            
        childView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(data.count))
        view.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(data.count))
            
        view.addSubview(childView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        view.delegate = context.coordinator
        view.layer.masksToBounds = false // Added for layer retention
            
        return view
    }
        
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(data.count))
            
        for i in 0..<uiView.subviews.count {
            uiView.subviews[i].frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(data.count))
        }
    }
        
    class Coordinator : NSObject, UIScrollViewDelegate {
        var parent : PlayerScrollView
        var index = 0
            
        init(parent1 : PlayerScrollView) {
            parent = parent1
        }
            
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let currentIndex = Int(scrollView.contentOffset.y / UIScreen.main.bounds.height)
                
            if index != currentIndex {
                index = currentIndex
                
                for i in 0..<parent.data.count {
                    parent.data[i].player.seek(to: .zero)
                    parent.data[i].player.pause()
                }
                
                parent.data[index].player.play()
                parent.data[index].player.actionAtItemEnd = .none
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: parent.data[index].player.currentItem, queue: .main) { (_) in
                    self.parent.data[self.index].replay = true
                }
            }
        }
    }
}

