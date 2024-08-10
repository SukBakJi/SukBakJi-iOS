//
//  NetworkResult.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
