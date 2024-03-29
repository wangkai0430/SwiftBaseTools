//
//  UIKit+Extension.swift
//  SwiftBaseTools
//
//  Created by yons on 2019/6/11.
//  Copyright © 2019年 yons. All rights reserved.
//

import UIKit

protocol NibLoadable {}
extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}

protocol RegisterCellFromNib {}
extension RegisterCellFromNib {
    static var identifier: String {
        return "\(self)"
    }
    static var nib: UINib? {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}

extension UITableView {
    // 注册cell的方法
    func wk_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.identifier)
        } else {
            register(cell, forCellReuseIdentifier: T.identifier)
        }
    }
    
    func wk_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    // 注册cell的方法
    func wk_registerCell<T: UICollectionViewCell>(cell: T.Type)
        where T: RegisterCellFromNib {
            if let nib = T.nib {
                register(nib, forCellWithReuseIdentifier: T.identifier)
            } else {
                register(cell, forCellWithReuseIdentifier: T.identifier)
            }
    }
    
    // 从缓存池出队已经存在的cell
    func wk_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 注册头部
    func wk_registerSupplementaryHeaderView<T: UICollectionReusableView>(reusableView: T.Type) where T: RegisterCellFromNib {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        }
    }
    
    /// 获取可重用的头部
    func wk_dequeueReusableSupplementaryHeaderView<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
