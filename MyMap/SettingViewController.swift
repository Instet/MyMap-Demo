//
//  SettingViewController.swift
//  MyMap
//
//  Created by Руслан Магомедов on 24.09.2022.
//

import UIKit

class SettingViewController: UIViewController {

    private lazy var settingView: SettingsMapView = {
        let view = SettingsMapView {
            self.dismiss(animated: true)
        }
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        self.modalPresentationStyle = .custom


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenView))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        view.addSubview(settingView)

        NSLayoutConstraint.activate([
            settingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            settingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            settingView.heightAnchor.constraint(equalToConstant: 200)

        ])
    }
    @objc private func hiddenView() {
        dismiss(animated: true)
    }


    


}
