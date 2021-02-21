//
//  EntityTypes.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/20/21.
//

import Foundation
import RealityKit

enum EntityType : Hashable {
    case sleepingBag, bench, campfire, cooler, grill(Int), table, tent(Int), wood, chair
    
    var anchor: HasAnchoring & CustomAnchor {
        switch self {
        case .sleepingBag:
            return try! Sleepingbag1.loadScene()
        case .bench:
            return try! Bench1.loadScene()
        case .campfire:
            return try! Campfire1.loadScene()
        case .cooler:
            return try! Cooler1.loadScene()
        case .grill(let value):
            return try! value == 0 ? Grill1.loadScene() : Grill2.loadScene()
        case .table:
            return try! Table1.loadScene()
        case .tent(let value):
            return try! value == 0 ? Tent1.loadScene() : Tent2.loadScene()
        case .wood:
            return try! Wood1.loadScene()
        case .chair:
            return try! Bench1.loadScene()
        }
    }
}

protocol CustomAnchor {
    var entity: Entity? { get }
}

extension CustomAnchor {
    var collisionEntity: HasCollision? { return entity as? HasCollision }
}

extension Bench1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.bench
    }
}

extension Sleepingbag1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.sleepingbag
    }
}

extension Campfire1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.campfire
    }
}

extension Cooler1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.cooler
    }
}

extension Grill1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.grill
    }
}

extension Grill2.Scene: CustomAnchor {
    var entity: Entity? {
        return self.grill
    }
}

extension Table1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.table
    }
}

extension Tent2.Scene: CustomAnchor {
    var entity: Entity? {
        return self.tent
    }
}

extension Tent1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.tent
    }
}

extension Wood1.Scene: CustomAnchor {
    var entity: Entity? {
        return self.logs
    }
}


