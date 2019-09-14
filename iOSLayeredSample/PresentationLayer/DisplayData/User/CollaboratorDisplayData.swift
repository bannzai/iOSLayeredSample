//
//  UserDisplayable.swift
//  iOSLayeredSample
//
//  Created by rnishimu on 2019/08/18.
//  Copyright © 2019 rnishimu22001. All rights reserved.
//

import Foundation

struct CollaboratorDisplayData {
    
    let hasAdminBadge: Bool
    let icon: URL
    let name: String
    
    init(with collaborator: CollaboratorData) {
        hasAdminBadge = collaborator.siteAdmin
        icon = collaborator.avatarURL
        name = collaborator.login
    }
}

struct CollaboratorsDisplayData {
    let collaborators: [CollaboratorDisplayData]
    init(with collaborators: [CollaboratorData]) {
        self.collaborators = collaborators.map { CollaboratorDisplayData(with: $0) }
    }
}
