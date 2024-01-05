//
//  ContentView.swift
//  SwiftUIText
//
//  Created by 王振 on 2024/1/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition.")
            .fontWeight(.bold)
            .font(.title)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .lineSpacing(10)
            .padding()
            .rotationEffect(.degrees(45))
    }
}

#Preview {
    ContentView()
}
