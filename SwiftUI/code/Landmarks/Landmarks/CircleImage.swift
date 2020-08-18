//
//  CircleImage.swift
//  Landmarks
//
//  Created by 王振 on 2019/12/20.
//  Copyright © 2019 curefun. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image.init("turtlerock")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
