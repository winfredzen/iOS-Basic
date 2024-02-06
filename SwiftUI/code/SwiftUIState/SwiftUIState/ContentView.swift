//
//  ContentView.swift
//  SwiftUIState
//
//  Created by 王振 on 2024/1/10.
//

import SwiftUI

struct ContentView: View {
    // 表示是否在播放状态
    @State private var isPlaying = false
    
    var body: some View {
        Button {
            // Switch between the play and stop button
            isPlaying.toggle()
        } label: {
            Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                .font(.system(size: 150))
                .foregroundColor(isPlaying ? .red : .green)
        }
    }
}

#Preview {
    ContentView()
}
