//
//  SupplementaryDescriptor.swift
//  Swifty
//
//  Created by Vadym Pavlov on 03.11.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public struct SupplementaryDescriptor {

    public enum Kind {
        case header
        case footer

        var value: String {
            switch self {
            case .header: return UICollectionElementKindSectionHeader
            case .footer: return UICollectionElementKindSectionFooter
            }
        }
    }

    public let kind: Kind
    public let identifier: String
    public let register: CollectionItemRegistration?
    public let configure: (UICollectionReusableView) -> ()

    public init<Element: UICollectionReusableView>(kind: Kind, identifier: String? = nil, register: CollectionItemRegistration? = nil, configure: @escaping (Element) -> ()) {
        self.kind = kind
        self.identifier = identifier ?? String(describing: Element.self)
        self.register = register
        self.configure = { element in
            configure(element as! Element)
        }
    }
}
