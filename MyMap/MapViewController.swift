//
//  MapViewController.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//


import UIKit
import MapKit


class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    let presenter: MapPresenterProtocol
    let locationService = LocationService()
    let annotation = MKPointAnnotation()



    private lazy var mapKitView: MKMapView = {
        let view = MKMapView()
        if #available(iOS 16, *) {
            view.preferredConfiguration.elevationStyle = .realistic
        } else {
            view.mapType = .standard
        }
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(presenter: MapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        locationService.delegate = self


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        locationService.startLocation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPin))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

    }

    private func setupLayout() {
        view.addSubview(mapKitView)
        NSLayoutConstraint.activate([
            mapKitView.topAnchor.constraint(equalTo: view.topAnchor),
            mapKitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showCurrentGeolocation(_ location: CLLocationCoordinate2D) {
        mapKitView.setCenter(location, animated: false)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapKitView.setRegion(region, animated: true)
        mapKitView.showsUserLocation = true

    }

    private func requestLocation(_ location: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            if self.locationService.locationManager.authorizationStatus == .authorizedWhenInUse {
                self.showCurrentGeolocation(location)
            }
        }
    }


    @objc private func addPin(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapKitView)
        let coordinate = mapKitView.convert(location, toCoordinateFrom: mapKitView)
        annotation.coordinate = coordinate
        mapKitView.addAnnotation(annotation)


    }








}


// MARK: - MapViewProtocol
extension MapViewController: MapViewProtocol {


}



// MARK: - LocationServiceDelegate
extension MapViewController: LocationServiceDelegate {

    func didUpdateLocation(withLocation location: CLLocationCoordinate2D) {
        requestLocation(location)
    }


    func alertError() {
        let alertController = UIAlertController(title: "Attention",
                                                message: "The application requires access to geolocation",
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) {_ in

            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

            if  UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

    }

}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKAnnotationView()
    }

}
