//
//  ContentView.swift
//  Landmarks
//
//  Created by 王振 on 2019/12/20.
//  Copyright © 2019 curefun. All rights reserved.
//

import SwiftUI

struct LandmarkDetail: View {
    
    var landmark: Landmark
    
    var body: some View {
        VStack {
            
            MapView(coordinate: landmark.locationCoordinate)
                .edgesIgnoringSafeArea(.top) //延伸到屏幕顶部
                .frame(height: 300)
            
            CircleImage(image: landmark.image).offset(y: -130).padding(.bottom, -130)
            
            VStack(alignment:.leading) {
                Text(landmark.name).font(.title)
                HStack {
                    Text(landmark.park).font(.subheadline)
                    Spacer()
                    Text(landmark.state).font(.subheadline)
                }
            }
            .padding()
            
            Spacer() //将内容推到top
        }
        .navigationBarTitle(Text(landmark.name), displayMode: .inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: landmarkData[0])
    }
}
