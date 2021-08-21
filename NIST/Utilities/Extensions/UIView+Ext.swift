//
//  UIView+Ext.swift
//  NIST
//
//  Created by Miguel Fraire on 7/29/21.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    func pinToEdges(of superview: UIView){
        translatesAutoresizingMaskIntoConstraints                               = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive             = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive     = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive   = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive       = true
    }
}
