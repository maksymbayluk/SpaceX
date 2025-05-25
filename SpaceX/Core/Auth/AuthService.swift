//
//  AuthService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import Network
import UIKit

// MARK: - AuthError

enum AuthError: Error {
    case missingClientID
    case noRootViewController
    case missingUserData
    case userNotFound
    case userDeleted
    case unknownError

    var localizedDescription: String {
        switch self {
        case .missingClientID: return "Firebase client ID is missing"
        case .noRootViewController: return "Could not find root view controller"
        case .missingUserData: return "Google user data is incomplete"
        case .userNotFound: return "User not found in Firebase"
        case .userDeleted: return "User account has been deleted"
        case .unknownError: return "An unknown error occurred"
        }
    }
}

// MARK: - AuthService

final class AuthService {
    static let shared = AuthService()

    func checkAuthenticationStatus(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, nil)
            return
        }

        Task {
            let hasInternet = await InternetService.shared.checkInternetStatus()

            if !hasInternet {
                completion(true, nil)
                return
            }

            user.reload { error in
                if let error = error as NSError? {
                    switch error.code {
                    case AuthErrorCode.userDisabled.rawValue,
                         AuthErrorCode.userNotFound.rawValue:
                        try? Auth.auth().signOut()
                        completion(false, nil)
                    default:
                        completion(false, error)
                    }
                } else {
                    completion(true, nil)
                }
            }
        }
    }

    func signInWithGoogle(completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(AuthError.missingClientID)
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController else
        {
            completion(AuthError.noRootViewController)
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                completion(error)
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(AuthError.missingUserData)
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(error)
                    return
                }

                guard let firebaseUser = authResult?.user else {
                    completion(AuthError.userNotFound)
                    return
                }

                firebaseUser.reload { error in
                    if let error = error as NSError? {
                        completion(error.code == AuthErrorCode.userNotFound.rawValue
                            ? AuthError.userDeleted
                            : error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
}
