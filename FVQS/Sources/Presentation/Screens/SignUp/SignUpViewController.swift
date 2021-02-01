import Combine
import UIKit

extension SignUpViewController {
    static func make(dependencies: AppDependencies) -> SignUpViewController {
        let router = SignUpRouterImpl.init(dependencies: dependencies)
        let model = SignUpViewModelImpl(router: router, dependencies: dependencies)
        let contoller = SignUpViewController(viewModel: model)
        router.viewController = contoller
        return contoller
    }
}

class SignUpViewController: UIViewController {
    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    private let viewModel: SignUpViewModel
    private var cancellables: [AnyCancellable] = []

    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var signUpButton: UIButton!
        
    
    // MARK: - Initializers

    init(viewModel: SignUpViewModel) {
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
        configureLoginForm()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = NSLocalizedString("Sign Up", comment: "")
    }
    
    private func configureLoginForm() {
        loginTextField.placeholder = NSLocalizedString("Login", comment: "")
        emailTextField.placeholder = NSLocalizedString("Email", comment: "")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        signUpButton.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
    }

    // MARK: - View Mode Bindings
    
    private func bindViewModel() {
        viewModel.isFormValid
            .replaceError(with: false)
            .assign(to: \UIButton.isEnabled, on: signUpButton)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func loginChangedAction() {
        viewModel.loginChanged(to: loginTextField.text ?? "")
    }
    
    @IBAction private func emailChangedAction() {
        viewModel.emailChanged(to: emailTextField.text ?? "")
    }
    
    @IBAction private func passwordChangedAction() {
        viewModel.passwordChanged(to: passwordTextField.text ?? "")
    }
    
    @IBAction private func signUpAction() {
        viewModel.signUpAction()
    }
}
