//
//  RepositoryDetailViewController.swift
//  iOSLayeredSample
//
//  Created by rnishimu on 2019/08/17.
//  Copyright © 2019 rnishimu22001. All rights reserved.
//

import UIKit
import Combine

final class RepositoryDetailViewController: UIViewController {
       
    var presenter: RepositoryDetailPresenterProtocol!
    var viewModel: RepositoryDetailViewModelProtocol!
    var repositoryFullName: String = ""
    private var cancellables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RepositoryDetailPresenter(with: view)
        viewModel = RepositoryDetailViewModel(repositoryFullName: repositoryFullName)
        self.sink()
        viewModel.reload()
    }
    
    private func sink() {
        let statusCancellable = viewModel.status.sink { [weak self] status in
            DispatchQueue.asyncAtMain {
                self?.presenter.update(status: status)
            }
        }
        let contentsCancellable = viewModel.contents.sink { [weak self] contents in
            DispatchQueue.asyncAtMain {
                self?.presenter.update(contents: contents)
            }
        }
        cancellables.append(statusCancellable)
        cancellables.append(contentsCancellable)
    }
}