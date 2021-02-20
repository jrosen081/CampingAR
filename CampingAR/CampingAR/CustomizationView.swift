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
        VStack {
            TextField("Search:", text: self.$currentOptions)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: nil, alignment: nil), count: 3)) {
                ForEach(validObjects, id: \.0) { name, object in
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text(name)
                            Image(object.iconName).resizable().frame(maxHeight: 100)
                            Spacer()
                            
                        }
                        Spacer()
                    }.overlay(self.rectangle)
                    .padding().onTapGesture {
                        self.selectedObject = object
                    }
                }
            }
            Spacer()
        }.padding()
    }
    
    var rectangle: some View {
        RoundedRectangle(cornerRadius: 10).stroke(Color.gray)
    }
}
