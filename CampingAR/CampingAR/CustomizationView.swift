//
//  CustomizationView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/20/21.
//

import Foundation
import SwiftUI

struct CustomizationView: View {
    @Binding var selectedObject: CampsiteObject
    
    let allOptions: [String: CampsiteObject]
    @State var currentOptions = ""
    
    var body: some View {
        TextField("Search:", text: self.$currentOptions)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        LazyVGrid(columns: [GridItem(.fixed(150), spacing: nil, alignment: nil)]) {
            ForEach(allOptions.map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 }), id: \.0) { name, object in
                VStack {
                    Text(name)
                    Image(systemName: object.iconName)
                }.border(Color.gray, width: 1).onTapGesture {
                    self.selectedObject = object
                }
            }
        }
    }
}
