//
//  SettingsMap.swift
//  MyMap
//
//  Created by Руслан Магомедов on 24.09.2022.
//

import UIKit

final class SettingsMapView: UIView {

    var callback: () -> Void


    static let arrayLayers = ["standart_layer".localized,
                              "hybrid_layer".localized,
                              "relief_layer".localized]

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "settings".localized
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var hiddenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hiddenView), for: .touchUpInside)
        return button
    }()


    private lazy var settingsLayers: UISegmentedControl = {
        let segment = UISegmentedControl(items: SettingsMapView.arrayLayers)
        segment.selectedSegmentTintColor = UIColor(named: "barTintColor")
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(changeLayer), for: .valueChanged)
        return segment
    }()

    init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
        setupSettings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.addSubview(settingsLayers)
        contentView.addSubview(hiddenButton)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            settingsLayers.topAnchor.constraint(equalTo: hiddenButton.bottomAnchor, constant: 5),
            settingsLayers.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            settingsLayers.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            settingsLayers.heightAnchor.constraint(equalToConstant: 50),

            hiddenButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            hiddenButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            hiddenButton.heightAnchor.constraint(equalToConstant: 30),
            hiddenButton.widthAnchor.constraint(equalToConstant: 30),

            titleLabel.centerYAnchor.constraint(equalTo: hiddenButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])


    }

    @objc private func hiddenView() {
        callback()


    }

    private func setupSettings() {
        let layer = UserDefaults.standard.object(forKey: "Settings") as? String ?? "standart_layer".localized
        if layer == "standart_layer".localized {
            settingsLayers.selectedSegmentIndex = 0
        } else if layer == "hybrid_layer".localized {
            settingsLayers.selectedSegmentIndex = 1
        } else if layer == "hybrid_layer".localized {
            settingsLayers.selectedSegmentIndex = 2
        }
    }

    @objc func changeLayer() {
        let index = settingsLayers.selectedSegmentIndex
        let temp = SettingsMapView.arrayLayers[index]
        UserDefaults.standard.set(temp, forKey: "Settings")
        NotificationCenter.default.post(name: Notification.Name("setup"), object: nil)

    }



}
