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


/* ******************* with right buttons ************************** */

struct Home: View {
    @State private var index: Int = 0
    @State var top = 0
    @State var data = [
        Video(id: 0, player: AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video1", ofType: "mp4")!)), replay: false),
        Video(id: 1, player: AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video2", ofType: "mp4")!)), replay: false),
        Video(id: 2, player: AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video3", ofType: "mp4")!)), replay: false),
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) { // Align VStack to bottom trailing
                    // Main video scroll view
                    PlayerScrollView(data: self.$data, videoHeight: geometry.size.height * 1.08)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Overlay for right-side buttons
                    VStack(spacing: 35) {
                        Spacer() // Pushes buttons to the bottom
                        

                        
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "suit.heart.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                Text("22K")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "message.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("1021")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Share")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {}) {
                            Image("images")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 70) // Fine-tune distance from the bottom
                    .padding(.trailing)
                }
                
                // Bottom Navbar occupying 15% of the screen height
                HStack {
                    Button(action: { self.index = 0 }) {
                        Image("abri")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 0 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)                            .padding(.bottom, 20)

                    }
                    Button(action: { self.index = 1 }) {
                        Image("profil")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 1 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)                            .padding(.bottom, 20)

                    }
                    Button(action: {}) {
                        Image("plus_1")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding(.horizontal)
                            .padding(.bottom, 25)
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976).opacity(1)) // Adjust opacity as needed (0.0 to 1.0)
                            .clipShape(Circle())
                    }
                    Button(action: { self.index = 2 }) {
                        Image("livre")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 2 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)
                            .padding(.bottom, 20)

                    }
                    /*NavigationLink(destination: Settings()) {
                                    Button(action: { self.index = 3 }) {
                                        Image("settings")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(self.index == 3 ? .white : Color.white.opacity(0.35))
                                            .padding(.horizontal)
                                            .padding(.bottom, 20)
                                    }
                                }*/
                    NavigationLink(destination: Settings()) {
                        Image("settings")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(self.index == 3 ? .white : Color.white.opacity(0.35))
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }.simultaneousGesture(TapGesture().onEnded {
                        self.index = 3
                    })

                }
                .frame(maxWidth: .infinity) // Ensure full width
                .frame(height: geometry.size.height * 0.1) // 15% for the navbar
                .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                //.background(Color.white) // Background color for the navbar
            }
            .background(Color.blue)
            .edgesIgnoringSafeArea(.bottom) // Ensure the navbar is not affected by safe area
        }
    }
}



struct PlayerView : View {
    
    @Binding var data : [Video]
    
    var body: some View{
        
        VStack(spacing: 0){
            
            ForEach(data.indices , id: \.self) { index in
                
                ZStack {
                                 
                                 Player(player: data[index].player)
                                     .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                     .offset(y: -5)
                                 
                                 if data[index].replay { // Corrected reference
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
                         // Play the first video automatically on appear
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
    
    func makeUIViewController(context: Context) -> AVPlayerViewController{
        let view = AVPlayerViewController()
        view.player = player
        view.showsPlaybackControls = false
        view.videoGravity = .resizeAspectFill
        return view
    }
    
    /*func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }*/
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if uiViewController.player != player {
            uiViewController.player = player
            player.play()
        }
    }

}

class Host : UIHostingController<ContentView>{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

struct Video : Identifiable {
    var id : Int
    var player : AVPlayer
    var replay : Bool
}


struct PlayerScrollView: UIViewRepresentable {
    @Binding var data: [Video]
    var videoHeight: CGFloat // Pass the dynamic video height from the parent view

    func makeCoordinator() -> Coordinator {
        return PlayerScrollView.Coordinator(parent1: self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        let childView = UIHostingController(rootView: PlayerView(data: self.$data))

        // Set the child view's height dynamically based on the passed videoHeight
        childView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: videoHeight * CGFloat(data.count))
        view.contentSize = CGSize(width: UIScreen.main.bounds.width, height: videoHeight * CGFloat(data.count))

        view.addSubview(childView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        view.delegate = context.coordinator

        return view
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: videoHeight * CGFloat(data.count))
        
        for i in 0..<uiView.subviews.count {
            uiView.subviews[i].frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: videoHeight * CGFloat(data.count))
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: PlayerScrollView
        var index = 0

        init(parent1: PlayerScrollView) {
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
