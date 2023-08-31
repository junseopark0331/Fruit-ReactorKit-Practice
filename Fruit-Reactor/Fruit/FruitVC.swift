import UIKit
import ReactorKit
import RxCocoa

class FruitViewController: UIViewController {
    
    private lazy var appleButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("사과", for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var bananaButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("바나나", for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var grapeButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("포도", for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "선택되어진 과일 없음"
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews:
                                    [appleButton,bananaButton,grapeButton, selectedLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    let disposeBag = DisposeBag()
    let fruitReact = FruitReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind(reactor: fruitReact)
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func bind(reactor: FruitReactor) {
        appleButton.rx.tap.map { FruitReactor.Action.apple }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bananaButton.rx.tap.map { FruitReactor.Action.banana }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        grapeButton.rx.tap.map { FruitReactor.Action.grapes }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.fruitName }
            .distinctUntilChanged()
            .map{ $0 }
            .subscribe(onNext: { val in
                self.selectedLabel.text = val
            })
            .disposed(by: disposeBag)
        
        reactor.state.map {$0.isLoading}
            .distinctUntilChanged()
            .map{ $0 }
            .subscribe(onNext: {val in
                if val == true {
                    self.selectedLabel.text = "로딩중입니다."
                }
                
            })
            .disposed(by: disposeBag)
    }
    
}

