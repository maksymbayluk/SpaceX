//
//  LoginViewController.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//

import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func didTapSignIn() {
        viewModel.signInWithGoogle()
    }
}
