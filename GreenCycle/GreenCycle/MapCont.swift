//
//  MapCont.swift
//  GreenCycle
//
//  Created by 김민경 on 12/2/23.
//

import UIKit
import NMapsMap
import CoreLocation

class MapCont: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let cameraPosition = NMFCameraPosition()

    var currentLocation:CLLocationCoordinate2D!
    var findLocation:CLLocation!
    let geocoder = CLGeocoder()
    
    var longitude_HVC = 0.0
    var latitude_HVC = 0.0
    
    
    @IBOutlet var mapView: NMFMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.allowsZooming = true // 줌 가능
        mapView.allowsScrolling = true // 스크롤 가능
        
        // delegate 설정
        locationManager.delegate = self
        // 사용자에게 허용 받기 alert 띄우기
        self.locationManager.requestWhenInUseAuthorization()
        requestAuthorization()

        // 내 위치 가져오기
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // 위도, 경도 가져오기
        let latitude = locationManager.location?.coordinate.latitude ?? 0
        let longitude = locationManager.location?.coordinate.longitude ?? 0

        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15.0)
        mapView.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn

        // 마커
        let new_marker = NMFMarker()
        
        new_marker.position = NMGLatLng(lat:latitude,lng: longitude)
        new_marker.iconImage = NMFOverlayImage(name: "MarkerImage")

        new_marker.width = 50
        new_marker.height = 50
        
        new_marker.mapView = mapView
        
        new_marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            print("마커 클릭")
            
            // MapDetailController로 화면 전환
            if let mapDetailController = self.storyboard?.instantiateViewController(withIdentifier: "MapDetailController") as? MapContDetail {
                // 필요한 경우 데이터를 전달하려면 여기에서 설정
                mapDetailController.modalPresentationStyle = .fullScreen
                self.present(mapDetailController, animated: true, completion: nil)
            }
            
            return true
        }
        
        print(latitude)
        print(longitude)

        // Do any additional setup after loading the view.
    }
    
    
    private func requestAuthorization() {

        //정확도 검사
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //앱 사용할때 권한요청

        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            print("restricted n denied")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("권한있음")
            locationManagerDidChangeAuthorization(locationManager)
        default:
            locationManager.startUpdatingLocation()
            print("default")
        }

        locationManagerDidChangeAuthorization(locationManager)

        if(latitude_HVC == 0.0 || longitude_HVC == 0.0){
            print("위치를 가져올 수 없습니다.")
        }

    }

    @objc func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            if let currentLocation = locationManager.location?.coordinate{
                print("coordinate")
                longitude_HVC = currentLocation.longitude
                latitude_HVC = currentLocation.latitude
            }
        }
        else{
            print("else")
        }
    }

    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude_HVC =  location.coordinate.latitude
            longitude_HVC = location.coordinate.longitude
        }
    }

}

