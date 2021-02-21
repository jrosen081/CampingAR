//
//  CustomizationView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/20/21.
//

import Foundation
import SwiftUI

struct CustomizationView: View {
    @Binding var selectedObject: CampsiteObject?
    
    let allOptions: [String: CampsiteObject]
    @State var currentOptions = ""
    
    var validObjects: [(String, CampsiteObject)] {
        allOptions.map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 }).filter { string, _ in
            return string.lowercased().contains(currentOptions.lowercased()) || currentOptions.isEmpty
        }
    }
    
    var body: some View {
        ZStack {
            Color(hue: 0.108, saturation: 0.1, brightness: 0.96)
            VStack {
                TextField("Search:", text: self.$currentOptions)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).background(Color.white).foregroundColor(Color.black)
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0, alignment: nil), count: 3)) {
                            ForEach(validObjects, id: \.0) { name, object in
                                HStack {
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        Text(name).foregroundColor(.black)
                                        Image(object.iconName.replacingOccurrences(of: "Unfilled", with: "Filled")).resizable().frame(width: 100, height: 100)
                                        Spacer()
                                        
                                    }
                                    Spacer()
                                }.overlay(self.rectangle).foregroundColor(.black)
                                .padding(10).onTapGesture {
                                    self.selectedObject = object
                                }
                            }
                        }
                    }
                    if validObjects.isEmpty {
                        VStack {
                            Image("oops")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 200, height: 200)
                            Text("Nothing matched that name, try again :)").foregroundColor(.black)
                        }
                    }
                }
            }.padding()
        }

    }
    
    var rectangle: some View {
        RoundedRectangle(cornerRadius: 10).stroke(Color(hue: 0.08, saturation: 1, brightness: 0.84))
    }
}
