//
//  MapView.swift
//  DFComponents
//
//  Created by ahmed maher on 03/02/2025.
//

import SwiftUI
import MapKit


struct MapView: View {
    @State private var userLocation: CLLocationCoordinate2D
    @State private var position: MapCameraPosition

    init() {
          let defaultLocation = CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357) // Cairo
          _userLocation = State(initialValue: defaultLocation)
          _position = State(initialValue: .camera(
              MapCamera(centerCoordinate: defaultLocation,
                        distance: 40000,  // Zoom level
                        heading: 0,
                        pitch: 0)
          ))
      }

    var body: some View {

        MapReader{ reader in
            Map(
                  position: $position,
                  interactionModes: .all
              ) {

                  Annotation("You", coordinate: userLocation) {
                      Image(systemName: "mappin.circle.fill")
                          .foregroundColor(.red)
                          .font(.title)
                  }
              }

            .onTapGesture(perform: { screenCoord in
                if let convertedLocation = reader.convert(screenCoord, from: .local) {
                      userLocation = convertedLocation
                      print("\(userLocation.latitude), \(userLocation.longitude)")
                  } else {
                      print("⚠️ Conversion failed!")
                  }

            })
            .onAppear{
                userLocation =  CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357)
                position = .camera(
                    MapCamera(centerCoordinate:
                                userLocation,
                              distance: 100000,
                              heading: 0,
                              pitch: 0)
                )

            }
            
        }

    }

}



#Preview {
    MapView()
}
