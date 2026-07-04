//
//  Networking.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Foundation
import Moya
import CombineMoya
import Combine
import Alamofire

struct Networking<API: TargetType>: NetworkingType {
    let provider: MoyaProvider<API>

    static func defaultNetworking() -> Networking {
        return Networking(provider: MoyaProvider(
            endpointClosure: endpointsClosure(),
            requestClosure: endpointResolver(),
            stubClosure: APIKeysBasedStubBehaviour,
            session: Session(interceptor: APIRequestRetrier()),
            plugins: plugins
        ))
    }
}
