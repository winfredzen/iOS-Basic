//
//  ExerciseView.swift
//  SwiftUIStacks
//
//  Created by 王振 on 2024/1/8.
//

import SwiftUI

struct ExerciseView: View {
    var body: some View {
        //        ZStack {
        //
        //            PricingView2(title: "Basic", price: "$9", textColor: .white, bgColor: .purple, icon: "burst.fill")
        //                .padding()
        //                .offset(x: 0, y: 180)
        //
        //            PricingView2(title: "Pro", price: "$19", textColor: .white, bgColor: Color(red: 255/255, green: 183/255, blue: 37/255), icon: "dial")
        //                .padding()
        //                .scaleEffect(0.95)
        //
        //            PricingView2(title: "Team", price: "$299", textColor: .white, bgColor: Color(red: 62/255, green: 63/255, blue: 70/255), icon: "wand.and.rays")
        //                .padding()
        //                .scaleEffect(0.9)
        //                .offset(x: 0, y: -180)
        //        }
        
        VStack {
            PricingView2(title: "Team", price: "$299", textColor: .white, bgColor: Color(red: 62/255, green: 63/255, blue: 70/255), icon: "wand.and.rays")
                .scaleEffect(0.9)
                .offset(x: 0, y: 100)
            
            PricingView2(title: "Pro", price: "$19", textColor: .white, bgColor: Color(red: 255/255, green: 183/255, blue: 37/255), icon: "dial")
                .scaleEffect(0.95)
                .offset(x: 0, y: 50)
            
            PricingView2(title: "Basic", price: "$9", textColor: .white, bgColor: .purple, icon: "burst.fill")

        }
        
    }
}

#Preview {
    ExerciseView()
}


struct PricingView2: View {
    
    var title: String
    var price: String
    var textColor: Color
    var bgColor: Color
    var icon: String?
    
    var body: some View {
        VStack {
            
            if let icon = icon {
                
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(textColor)
                
            }
            
            Text(title)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(textColor)
            Text(price)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundColor(textColor)
            Text("per month")
                .font(.headline)
                .foregroundColor(textColor)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .padding(40)
        .background(bgColor)
        .cornerRadius(10)
    }
}
