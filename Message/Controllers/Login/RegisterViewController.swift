//
//  RegisterViewController.swift
//  Message
//
//  Created by Sahil Patel on 11/22/20.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.label.cgColor
        field.placeholder = "Email Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
        
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.label.cgColor
        field.placeholder = "First Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.label.cgColor
        field.placeholder = "Last Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.label.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
        
    }()
    
    private let registerButton:UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add")
        let config = UIImage.SymbolConfiguration(weight: .ultraLight)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.label.cgColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Register"
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeDown))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        //add subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePicture))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    @objc private func didTapChangeProfilePicture(){
        presesntPhotoActionSheet()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (view.width-size)/2,
                                 y: 40,
                                 width: size,
                                 height: size)
        
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: lastNameField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: passwordField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        registerButton.frame = CGRect(x: 30,
                                      y: emailField.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        
        imageView.layer.cornerRadius = imageView.width/2.0
        
    }
    
    @objc private func registerButtonTapped(){
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              password.count >= 6 else{
            alertUserRegisterError()
            return
        }
        //firebase login!
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exsists in
            guard let strongSelf = self else {
                return
            }
            guard !exsists else {
                //user already exists
                strongSelf.alertUserRegisterError(message: "A user already with that email already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {authResult, error in
                
                guard authResult != nil, error == nil else {
                    print("error creating user")
                    strongSelf.alertUserRegisterError(message: "A user already exists with that email")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
        
        
    }
    
    private func alertUserRegisterError(message: String = "Please enter all information") {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    /*@objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }*/
    @objc private func respondToSwipeDown(){
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
            print("done on first name")
        }
        else if textField == lastNameField {
            passwordField.becomeFirstResponder()
            print("done on last name")

        }
        else if textField == passwordField {
            print("done on passowrd name")

            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            print("done on email name")
            registerButtonTapped()
        }
        else {
            print ("I have no idea")
        }
        return true
    }
}
extension RegisterViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presesntPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)

    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.imageView.image = selectedImage
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }
}

