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

    func request(_ target: API) -> AnyPublisher<Any, MoyaError> {
        return provider.requestPublisher(target)
            .mapJSON()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func requestWithoutMapping(_ target: API) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(target)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func requestObject<T: Decodable>(
        _ target: API,
        type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, MoyaError> {
        return provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map(T.self, using: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func requestArray<T: Decodable>(
        _ target: API,
        type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<[T], MoyaError> {
        return provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map([T].self, using: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

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
