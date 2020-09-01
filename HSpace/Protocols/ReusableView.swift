//
//  ReusableView.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

protocol ReusableView where Self: UIView {
    static var viewClassIdentifier: String { get }
    var viewClassIdentifier: String { get }
}

extension ReusableView {
    static var viewClassIdentifier: String {
        NSStringFromClass(self).components(separatedBy: .punctuationCharacters).last!
    }
    
    var viewClassIdentifier: String {
        Self.viewClassIdentifier
    }
}

extension ReusableView where Self: UITableViewCell {
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: viewClassIdentifier, for: indexPath) as! Self
    }
}

extension ReusableView where Self: UICollectionViewCell {
    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableCell(withReuseIdentifier: viewClassIdentifier, for: indexPath) as! Self
    }
}
