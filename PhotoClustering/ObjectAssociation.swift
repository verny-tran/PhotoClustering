//
//  ObjectAssociation.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import Foundation

final class ObjectAssociation<T: Any> {
    private let policy: objc_AssociationPolicy

    /// `Initialize` an `object association`
    ///
    /// - Parameter policy: An `association policy` that will be used when `linking objects`.
    ///
    internal init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    /// Accesses `associated object`.
    ///
    /// - Parameter index: An object whose `associated object` is to be `accessed`.
    ///
    /// - Returns: The `generic` associated object at `index`.
    ///
    internal subscript(index: AnyObject) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as? T }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, self.policy) }
    }
}
