//
//  ScreenshotButtonView.swift
//  CampingAR
//
//  Created by Samuel Xifaras on 2/21/21.
//

import Foundation
import SwiftUI

struct ScreenshotButtonView: View {
    @Binding var shouldTakeScreenshot: Bool
    
    var body: some View {
        Button(action: {
            self.shouldTakeScreenshot = true
        }) {
        Image(systemName: "camera")
            .resizable()
            .frame(width: 50, height: 40)
            .padding()
//            .foregroundColor(Color.black)
            .background(Color.white)
            .clipShape(Circle())
//        Text("Capture")
//            .frame(width: 100, height: 100)
//            .foregroundColor(Color.black)
//            .background(Color.gray)
//            .clipShape(Circle())
//        }
        }
    }
}
