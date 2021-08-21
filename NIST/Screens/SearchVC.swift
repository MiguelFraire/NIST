//
//  SearchVC.swift
//  NIST
//
//  Created by Miguel Fraire on 7/29/21.
//

import UIKit

class SearchVC: UIViewController {

    private let topImageContainerView   = UIView()
    private let logoImageView           = UIImageView()
    private let searchTextField         = NTextField()
    private let searchButton            = NButton(backgroundColor: .brandGreen, title: "Search")
    
    private var isInputAvailable: Bool { return !searchTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubviews(topImageContainerView, searchTextField, searchButton)
        configureTopImageContainerView()
        configureLogoImageView()
        configureTextField()
        configureSearchButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    //MARK: - Configurations
    
    private func configureTopImageContainerView() {
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        topImageContainerView.addSubview(logoImageView)
    }
    
    private func configureLogoImageView(){
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.logo
        logoImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func configureTextField() {
        searchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: -40),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureSearchButton() {
        searchButton.addTarget(self, action: #selector(pushImageGridVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func pushImageGridVC() {
        guard isInputAvailable else {
            presentAlertOnMainThread(title: "Empty Text Field", message: "Please enter a search term. We need to know what to look for.", buttonTitle: "Okay")
            return
        }
        
        let input = searchTextField.text!
        let regex = NSRegularExpression("^[A-Za-z]+$")
        
        if !regex.matches(input) {
            self.presentAlertOnMainThread(title: "Bad Stuff Happened", message: NError.invalidQuery.rawValue , buttonTitle: "Okay")
            return
        }
        
        searchTextField.resignFirstResponder()
        let imageGridVC = ImageGridVC(searchTerm: input)
        navigationController?.pushViewController(imageGridVC, animated: true)
    }
}
//MARK: - Extensions

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        pushImageGridVC()
        return true
    }
}

extension NSRegularExpression {
    
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
