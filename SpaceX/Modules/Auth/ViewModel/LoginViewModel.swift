//
//  LoginViewModel.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

final class LoginViewModel {
    var onAuthSuccess: (() -> Void)?

    func signInWithGoogle() {
        AuthService.shared.signInWithGoogle { [weak self] error in
            if error == nil {
                self?.onAuthSuccess?()
            }
        }
    }
}
