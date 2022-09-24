//
//  MapPresenter.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//

import Foundation

protocol MapViewProtocol: AnyObject {

}

protocol MapPresenterProtocol {
    func requestLocation()
}

final class MapPresenter: MapPresenterProtocol {

    weak var view: MapViewProtocol?

    func requestLocation() {
        ()

    }
}
