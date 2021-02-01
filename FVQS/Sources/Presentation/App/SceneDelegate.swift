import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    // MARK: Public

    var window: UIWindow?

    // MARK: Private

    private var router: AppRouter?
    private let dependencies: AppDependencies = AppDependenciesImpl()

    // MARK: - UIWindowSceneDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            self.router = AppRouter(window: window)
            router?.start(with: dependencies)
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        router?.goToRandomQuote(dependencies: dependencies)
    }
}

