//
//  RepositoryCommunityProfileClient.swift
//  iOSLayeredSample
//
//  Created by rnishimu on 2019/08/17.
//  Copyright © 2019 rnishimu22001. All rights reserved.
//

import Foundation

protocol RepositoryCommunityProfileClientProtocol {
    func requestProfile(repository fullName: String, completion: @escaping ((Result<CommunityProfile, Error>, URLResponse?) -> Void))
}

final class RepositoryCommunityProfileClient: RepositoryCommunityProfileClientProtocol, APIRequestable {
    let configuration: URLSessionConfiguration = .default
    
    func requestProfile(repository fullName: String, completion: @escaping ((Result<CommunityProfile, Error>, URLResponse?) -> Void)) {
        let url = APIURLSetting.communityProfile(with: fullName)
        guard let components = URLComponents(string: url) else {
            completion(.failure(RequestError.badURL), nil)
            return
        }
        
        guard let requestURL = components.url else {
            completion(.failure(RequestError.badURL), nil)
            return
        }
        
        request(with: URLRequest(url: requestURL)) { result, response in
            switch result {
            case .failure(let error):
                completion(.failure(error), response)
            case .success(let data):
                guard let users = try? JSONDecoder().decode(CommunityProfile.self, from: data) else {
                    completion(.failure(RequestError.dataEncodeFailed), response)
                    return
                }
                completion(.success(users), response)
            }
        }
    }
}
