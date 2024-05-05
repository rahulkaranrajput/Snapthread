//
//  Constraints.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit

class Constraints {
    static func centerHorizontally(_ view: UIView, in superview: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
    }
    
    static func centerVertically(_ view: UIView, in superview: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    static func center(_ view: UIView, in superview: UIView) {
        centerHorizontally(view, in: superview)
        centerVertically(view, in: superview)
    }
    
    static func pinEdges(of view: UIView, to superview: UIView, with insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
