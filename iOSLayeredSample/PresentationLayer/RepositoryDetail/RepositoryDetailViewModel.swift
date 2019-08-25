//
//  RepositoryDetailViewModel.swift
//  iOSLayeredSample
//
//  Created by rnishimu on 2019/08/18.
//  Copyright © 2019 rnishimu22001. All rights reserved.
//

import Combine

protocol RepositoryDetailViewModelProtocol {
    var status: CurrentValueSubject<ContentsStatus, Never> { get }
    var contents: CurrentValueSubject<[Displayable], Never> { get }
    var repositoryFullName: String { get }
}

final class RepositoryDetailViewModel: RepositoryDetailViewModelProtocol {
    let status: CurrentValueSubject<ContentsStatus, Never> = .init(.initalized)
    let contents: CurrentValueSubject<[Displayable], Never> = .init([])
    let useCase: RepositoryDetailUseCaseProtocol
    
    let repositoryFullName: String
    
    init(repositoryFullName: String,
         useCase: RepositoryDetailUseCaseProtocol = RepositoryDetailUseCase()) {
        self.repositoryFullName = repositoryFullName
        self.useCase = useCase
    }
    
    func reload() {
        status.value = .loading
        useCase.reload(repository: repositoryFullName)
    }
    
    private func update() {
        self.contentsUpdate()
        self.updateStatus()
    }
    
    /// コンテンツのステータスの更新状態を見て通知が必要か、どのデータを更新させるかを決める
    func contentsUpdate() {
        var contents: [Displayable] = []
        if let profile = useCase.profile {
            contents.append(CommunityProfileDisplayData(with: profile))
        }
        if let release = useCase.latestRelease {
            let status = ReleaseStatus(isDraft: release.draft, isPrerelease: release.prerelease)
            contents.append(ReleaseDisplayData(with: release, status: status))
        }
        if !useCase.collaborators.isEmpty {
            let collaboratorList = useCase.collaborators.map { CollaboratorDisplayData(with: $0) }
            contents.append(CollaboratorsDisplayData(collaborators: collaboratorList))
        }
        if useCase.shouldShowLoadingFooter {
            contents.append(LoadingDisplayable())
        }
        guard !contents.isEmpty else { return }
        self.contents.value = contents
    }
    
    func updateStatus() {
        var status: ContentsStatus
        defer {
            // 同値の場合は更新なし
            if self.status.value != status {
                self.status.value = status
            }
        }
        guard !self.useCase.isLoading else {
            status = .loading
            return
        }
        guard !self.useCase.isError else {
            status = .error
            return
        }
        status = .browsable
    }
}

extension RepositoryDetailViewModel: RepositoryDetailUseCaseDelegate {
    func repositoryDetailUseCase(_ useCase: RepositoryDetailUseCaseProtocol, didLoad latestRelease: Release?, collaborators: [Collaborator]) {
        self.update()
    }
    
    func repositoryDetailUseCase(_ useCase: RepositoryDetailUseCaseProtocol, didLoad profile: CommunityProfile?) {
        
        self.update()
    }
}