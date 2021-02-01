import Combine
import UIKit

extension SignInViewController {
    static func make(dependencies: AppDependencies) -> SignInViewController {
        let router = SignInRouterImpl.init(dependencies: dependencies)
        let model = SignInViewModelImpl(router: router, dependencies: dependencies)
        let contoller = SignInViewController(viewModel: model)
        router.viewController = contoller
        return contoller
    }
}

class SignInViewController: UIViewController {
    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    private let viewModel: SignInViewModel
    private var cancellables: [AnyCancellable] = []

    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var signInButton: UIButton!
        
    
    // MARK: - Initializers

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    // MARK: - UI Configuration
    
    private func configureUI() {
        definesPresentationContext = true
        configureNavigationItem()
        configureSignInForm()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = NSLocalizedString("Sign In", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: ""), style: .plain, target: self, action: #selector(signUpAction))
    }
    
    private func configureSignInForm() {
        loginTextField.placeholder = NSLocalizedString("Login", comment: "")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        signInButton.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
        
        #if DEBUG
        loginTextField.text = "aliaksandr.habrusevich@cogniteq.com"
        passwordTextField.text = "hynmi9-dyqber-vIdxyh"
        viewModel.loginChanged(to: loginTextField.text ?? "")
        viewModel.passwordChanged(to: passwordTextField.text ?? "")
        #endif
    }

    // MARK: - View Mode Bindings
    
    private func bindViewModel() {
        viewModel.isFormValid
            .replaceError(with: false)
            .assign(to: \UIButton.isEnabled, on: signInButton)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func loginChangedAction() {
        viewModel.loginChanged(to: loginTextField.text ?? "")
    }
    
    @IBAction private func passwordChangedAction() {
        viewModel.passwordChanged(to: passwordTextField.text ?? "")
    }
    
    @IBAction private func signInAction() {
        viewModel.signInAction()
    }
    
    @objc private func signUpAction() {
        viewModel.signUpAction()
    }
}
