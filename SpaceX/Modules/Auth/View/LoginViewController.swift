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

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])

        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    @objc private func didTapLogin() {
        viewModel.signInWithGoogle()
    }
}
