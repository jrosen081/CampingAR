//
//  CampingObjectView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import SwiftUI

struct CampingObjectView: View {
    let allObjects = Array(0..<10)
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(allObjects) { _ in
                    Image(systemName: "pencil").resizable().onDrag {
                        return NSItemProvider(item: nil, typeIdentifier: "my type")
                    }.frame(width: 100, height: 100, alignment: .center)
                        
                }
            }
        }.frame(height: 100)
    }
}

extension Int: Identifiable {
    public var id: Self {
        return self
    }
}

struct CampingObjectView_Previews: PreviewProvider {
    static var previews: some View {
        CampingObjectView()
    }
}
