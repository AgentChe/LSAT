//
//  Single+Utils.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import RxSwift

extension PrimitiveSequenceType where Trait == SingleTrait {
    func mapToVoid() -> Single<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
