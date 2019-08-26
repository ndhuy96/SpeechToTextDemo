//
//  RecordingManuallyViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/22/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class RecordingManuallyViewController: UIViewController {

    // properties
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tbvMain: UITableView!
    
    @IBOutlet private weak var leftView: UIView!
    @IBOutlet private weak var rightView: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    
    @IBOutlet weak var btnLanguageSelectionLeft: UIButton!
    @IBOutlet weak var btnLanguageSelectionRight: UIButton!
    
    @IBOutlet var txtvTextDetected: [UITextView]!
    // vars
    private var isRecording: Bool = false
    private var viewModel: RecordManualViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
        config()
    }
    
    private func config() {
        // config tableview
        viewModel = RecordManualViewModel()
        tbvMain.delegate = viewModel
        tbvMain.dataSource = viewModel
        tbvMain.rowHeight = UITableView.automaticDimension
        tbvMain.estimatedRowHeight = 20
        tbvMain.tableFooterView = UIView(frame: .zero)
        tbvMain.separatorStyle = .none
        tbvMain.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        viewModel.didChanged = { [weak self] errorMessage in
            guard let self = self else { return }
            if let errorMessage = errorMessage {
                self.showAlert(title: "Error", message: errorMessage)
                print(errorMessage)
            } else {
                self.tbvMain.reloadData()
                
                // Scroll To Bottom
                let indexPath = IndexPath(
                    row: self.tbvMain.numberOfRows(inSection:  self.tbvMain.numberOfSections - 1) - 1,
                    section: self.tbvMain.numberOfSections - 1)
                guard indexPath.row >= 0 else { return }
                self.tbvMain.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        // config button select language
        self.btnLanguageSelectionLeft.setTitle(LanguageHelper.shared.getCurrentSpeakerLeft().name, for: .normal)
        self.btnLanguageSelectionRight.setTitle(LanguageHelper.shared.getCurrentSpeakerRight().name, for: .normal)
    }
    
    private func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLeftButtonTapped))
        leftButton.addGestureRecognizer(longPressGesture)
        
        let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(handleRightButtonTapped))
        rightButton.addGestureRecognizer(longPressGesture2)
    }
    
    
}

// MARK: - Button handler
extension RecordingManuallyViewController {
    
    @IBAction func btnLanguageSelectionLeftDidPressed(_ sender: Any) {
        let vc = ListLanguagesVC.instantiate()
        vc.languageSelectionMode = .SpeakerLeft
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        vc.didChangedLanguage = { [weak self] givenData in
            guard let self = self else { return }
            self.btnLanguageSelectionLeft.setTitle(LanguageHelper.shared.getCurrentSpeakerLeft().name, for: .normal)
        }
    }
    @IBAction func btnLanguageSelectionRightDidPressed(_ sender: Any) {
        let vc = ListLanguagesVC.instantiate()
        vc.languageSelectionMode = .SpeakerRight
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        vc.didChangedLanguage = { [weak self] givenData in
            guard let self = self else { return }
            self.btnLanguageSelectionRight.setTitle(LanguageHelper.shared.getCurrentSpeakerRight().name, for: .normal)
        }
    }
    
    func handleLanguageSelection () {
        
    }
    
    @objc
    private func handleLeftButtonTapped(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            animationButtonWhenStopTranslating()
        }
        else if sender.state == .began {
            animationButtonWhenTranslating(leftView)
        }
    }
    
    @objc
    private func handleRightButtonTapped(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            animationButtonWhenStopTranslating()
        }
        else if sender.state == .began {
            animationButtonWhenTranslating(rightView)
        }
    }
    
    private func animationButtonWhenTranslating(_ view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
            self.addPulse(view)
        })
        isRecording = true
    }
}

// MARK: - View Animation
extension RecordingManuallyViewController {
    func addPulse(_ view: UIView){
        let pulse = Pulsing(radius: 300, position: view.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = UIColor(red: 255.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
        
        self.view.layer.insertSublayer(pulse, below: view.layer)
    }
    
    func removePulse() {
        if let sublayers = view.layer.sublayers {
            for layer in sublayers {
                if layer.name == "pulsingLayer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    private func animationButtonWhenStopTranslating() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
        })
        removePulse()
        isRecording = false
    }
}


extension RecordingManuallyViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
