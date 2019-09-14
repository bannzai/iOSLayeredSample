//
//  CommunityProfileRepository.swift
//  iOSLayeredSample
//
//  Created by rnishimu on 2019/08/25.
//  Copyright © 2019 rnishimu22001. All rights reserved.
//

protocol CommunityProfileRepositoryProtocol {
    func reload(repository fullName: String, completion: @escaping ((Result<CommunityProfile, Error>) -> Void))
}

struct CommunityProfileRepository: CommunityProfileRepositoryProtocol {
    let client: CommunityProfileClientProtocol = CommunityProfileClient()
    
    func reload(repository fullName: String, completion: @escaping ((Result<CommunityProfile, Error>) -> Void)) {
        client.requestProfile(repository: fullName) { result, _ in
            completion(result)
        }
    }
}
