//
//  MapViewController.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//


import UIKit
import Foundation
import MapKit


class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    let presenter: MapPresenterProtocol
    let annotation = MKPointAnnotation()

    private lazy var mapKitView: MKMapView = {
        let view = MKMapView()
        view.showsCompass = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var centrGeoButton: UIButton = {
        let buttom = UIButton(type: .custom)
        buttom.setImage(UIImage(systemName: "location.fill")?.applyingSymbolConfiguration(.init(pointSize: 30)), for: .normal)
        buttom.tintColor = UIColor(named: "barTintColor")
        buttom.backgroundColor = .white
        buttom.layer.cornerRadius = 25
        buttom.layer.borderWidth = 0.5
        buttom.layer.borderColor = UIColor(named: "barTintColor")?.cgColor
        buttom.addTarget(self, action: #selector(tapCentr), for: .touchUpInside)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()


    private lazy var clearButton: UIButton = {
        let buttom = UIButton(type: .custom)
        buttom.setImage(UIImage(systemName: "trash.circle")?.applyingSymbolConfiguration(.init(pointSize: 50)), for: .normal)
        buttom.tintColor = UIColor(named: "barTintColor")
        buttom.backgroundColor = .white
        buttom.layer.cornerRadius = 25
        buttom.layer.borderWidth = 0.5
        buttom.layer.borderColor = UIColor(named: "barTintColor")?.cgColor
        buttom.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()

    private lazy var settingButton: UIButton = {
        let buttom = UIButton(type: .custom)
        buttom.setImage(UIImage(systemName: "square.3.layers.3d.top.filled")?.applyingSymbolConfiguration(.init(pointSize: 30)), for: .normal)
        buttom.tintColor = UIColor(named: "barTintColor")
        buttom.backgroundColor = .white
        buttom.layer.cornerRadius = 25
        buttom.layer.borderWidth = 0.5
        buttom.layer.borderColor = UIColor(named: "barTintColor")?.cgColor
        buttom.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()


    init(presenter: MapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayers()
        setupLayout()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPin))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(forName: Notification.Name("setup"), object: nil, queue: .main) { _ in
            self.setLayers()
        }

        let date = Date()
        let dateFormated = DateFormatter()
        dateFormated.dateStyle = .full
        dateFormated.timeStyle = .full
        dateFormated.locale = Locale.current
        print(dateFormated.string(from: date) + "\n---------------")

    }

    func setLayers() {
        let segment = UserDefaults.standard.object(forKey: "Settings") as? String ?? SettingsMapView.arrayLayers[0]
        if segment == SettingsMapView.arrayLayers[0] {
            if #available(iOS 16, *) {
                self.mapKitView.preferredConfiguration.elevationStyle = .realistic
            }
            self.mapKitView.mapType = .standard
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        } else if segment == SettingsMapView.arrayLayers[1] {
            self.mapKitView.mapType = .hybrid
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        } else if segment == SettingsMapView.arrayLayers[2] {
            self.mapKitView.mapType = .satellite
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]

        }



    }

    private func setupLayout() {
        view.addSubview(mapKitView)
        mapKitView.addSubview(centrGeoButton)
        mapKitView.addSubview(clearButton)
        mapKitView.addSubview(settingButton)

        NSLayoutConstraint.activate([
            mapKitView.topAnchor.constraint(equalTo: view.topAnchor),
            mapKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            centrGeoButton.bottomAnchor.constraint(equalTo: mapKitView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            centrGeoButton.trailingAnchor.constraint(equalTo: mapKitView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            centrGeoButton.heightAnchor.constraint(equalToConstant: 50),
            centrGeoButton.widthAnchor.constraint(equalToConstant: 50),

            clearButton.heightAnchor.constraint(equalToConstant: 50),
            clearButton.widthAnchor.constraint(equalToConstant: 50),
            clearButton.trailingAnchor.constraint(equalTo: mapKitView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            clearButton.bottomAnchor.constraint(equalTo: centrGeoButton.topAnchor, constant: -10),

            settingButton.heightAnchor.constraint(equalToConstant: 50),
            settingButton.widthAnchor.constraint(equalToConstant: 50),
            settingButton.trailingAnchor.constraint(equalTo: mapKitView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingButton.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -10),

        ])
    }

    private func showCurrentGeolocation(_ location: CLLocationCoordinate2D) {
        mapKitView.setCenter(location, animated: true)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapKitView.setRegion(region, animated: true)
        mapKitView.showsUserLocation = true

    }


    @objc private func addPin(gestureRecognizer: UITapGestureRecognizer) {
        mapKitView.removeAnnotations(mapKitView.annotations)
        let location = gestureRecognizer.location(in: mapKitView)
        let coordinate = mapKitView.convert(location, toCoordinateFrom: mapKitView)
        annotation.coordinate = coordinate
        mapKitView.addAnnotation(annotation)

    }

    @objc private func tapCentr() {
        guard let userLocation = presenter.location else { return }
        showCurrentGeolocation(userLocation)
    }

    @objc private func clearAction() {
        mapKitView.removeAnnotations(mapKitView.annotations)
        mapKitView.overlays.forEach { mapKitView.removeOverlay($0) }

    }

    @objc private func settingAction() {
        let settingVC = SettingViewController()
        present(settingVC, animated: true)
    }
}


// MARK: - MapViewProtocol
extension MapViewController: MapViewProtocol {

    func requestLocation(_ location: CLLocationCoordinate2D) {
        presenter.requestLocation {
            self.showCurrentGeolocation(location)
        }
    }

    func alertErrorMap() {
        let alertController = UIAlertController(title: "alert_title".localized,
                                                message: "alert_message".localized,
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "setting_alert".localized, style: .default) {_ in

            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

            if  UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }

        }
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .cancel) { _ in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

    }

}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5.0
        return renderer
    }


    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        mapView.overlays.forEach { mapView.removeOverlay($0) }
        guard let coordinate = self.presenter.location else { return }
        let annotationUser = annotation.coordinate
        let startPoint = MKPlacemark(coordinate: coordinate)
        let sourseMapItem = MKMapItem(placemark: startPoint)
        let endPoint = MKPlacemark(coordinate: annotationUser)
        let destinationMapItem = MKMapItem(placemark: endPoint)

        let request = MKDirections.Request()
        request.source = sourseMapItem
        request.destination = destinationMapItem
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { responce, error in
            if error != nil {
                return
            }
            guard let responce = responce, let route = responce.routes.first else { return }
            mapView.addOverlay(route.polyline, level: .aboveRoads)
            let routeRect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(routeRect), animated: true)
        }
    }

}
