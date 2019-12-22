//
//  Observable+Ext.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 23/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> { return map { _ in }}
}

extension ObservableType {
    func mapToVoid() -> Observable<Void> { return map { _ in } }
}
