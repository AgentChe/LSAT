//
//  Observable+Utils.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
