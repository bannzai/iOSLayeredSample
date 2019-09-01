//
//  CollaboratorsClient.swift
//  iOSLayeredSample
//
//  Created by rnishimu on 2019/08/17.
//  Copyright © 2019 rnishimu22001. All rights reserved.
//

import Foundation

protocol CollaboratorsClientInterface {
    func requestCollaborators(repository fullName: String, completion: @escaping ((Result<[Collaborator], Error>, URLResponse?) -> Void))
}

struct CollaboratorsClient: CollaboratorsClientInterface, GitHubAPIRequestable {
    
    let requester: HTTPRequestable
    
    init(requester: HTTPRequestable = HTTPRequester()) {
        self.requester = requester
    }
    
    func requestCollaborators(repository fullName: String, completion: @escaping ((Result<[Collaborator], Error>, URLResponse?) -> Void)) {
        let url = APIURLSetting.collaborators(with: fullName)
        guard let components = URLComponents(string: url) else {
            completion(.failure(RequestError.badURL), nil)
            return
        }
        
        guard let requestURL = components.url else {
            completion(.failure(RequestError.badURL), nil)
            return
        }
        
        let request = addAccept(request: URLRequest(url: requestURL))
        
        requester.request(with: request) { result, response in
            switch result {
            case .failure(let error):
                completion(.failure(error), response)
            case .success(let data):
                guard let users = try? JSONDecoder().decode([Collaborator].self, from: data) else {
                    completion(.failure(RequestError.dataEncodeFailed), response)
                    return
                }
                completion(.success(users), response)
            }
        }
    }
}
