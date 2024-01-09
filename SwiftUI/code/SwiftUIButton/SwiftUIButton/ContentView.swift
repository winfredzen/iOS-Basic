//
//  ContentView.swift
//  SwiftUIButton
//
//  Created by 王振 on 2024/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Regular Button") {
                
            }
            
            Button {
                
            } label: {
                Text("Regular Button").bold()
            }
        }
    }
}

#Preview {
    ContentView()
}
