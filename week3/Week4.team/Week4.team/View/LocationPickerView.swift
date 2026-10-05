//
//  LocationPickerView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationPickerView: View {
    @Binding var selectedLocationName: String
    @Environment(\.dismiss) private var dismiss

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 10.8276, longitude: 106.7214),
            span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        )
    )
    
    @State private var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10.8276, longitude: 106.7214)
    @State private var currentAddress: String = "TTTM Gigamall, 240-242 Phạm Văn Đồng, TP. Thủ Đức"
    @State private var isResolvingAddress: Bool = false

    private let geocoder = CLGeocoder()

    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Bản đồ tương tác
                Map(position: $cameraPosition)
                    .onMapCameraChange(frequency: .continuous) { context in
                        currentCoordinate = context.region.center
                    }
                    .onMapCameraChange(frequency: .onEnd) { context in
                        reverseGeocode(coordinate: context.region.center)
                    }
                    .ignoresSafeArea(edges: .bottom)

                VStack(spacing: 0) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white).frame(width: 20, height: 20))
                        .shadow(radius: 4)
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .offset(y: -4)
                }
                .offset(y: -16)

                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                            Text("Địa chỉ đang chọn:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if isResolvingAddress {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }

                        Text(currentAddress)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            selectedLocationName = currentAddress
                            dismiss()
                        } label: {
                            Text("Xác nhận giao đến đây")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(isResolvingAddress ? Color.gray : Color.blue)
                                .cornerRadius(12)
                        }
                        .disabled(isResolvingAddress)
                    }
                    .padding()
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                    .padding()
                }
            }
            .navigationTitle("Chọn vị trí giao hàng")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
        }
    }

    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        isResolvingAddress = true
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                isResolvingAddress = false
                if let placemark = placemarks?.first {
                    var parts: [String] = []
                    
                    if let name = placemark.name { parts.append(name) }
                    if let subThoroughfare = placemark.subThoroughfare { parts.append(subThoroughfare) }
                    if let thoroughfare = placemark.thoroughfare { parts.append(thoroughfare) }
                    if let subLocality = placemark.subLocality { parts.append(subLocality) }
                    if let locality = placemark.locality { parts.append(locality) }
                    
                    if !parts.isEmpty {
                        let uniqueParts = Array(NSOrderedSet(array: parts)) as? [String] ?? parts
                        currentAddress = uniqueParts.joined(separator: ", ")
                    } else {
                        currentAddress = String(format: "Tọa độ: %.4f, %.4f", coordinate.latitude, coordinate.longitude)
                    }
                } else {
                    currentAddress = String(format: "Tọa độ: %.4f, %.4f", coordinate.latitude, coordinate.longitude)
                }
            }
        }
    }

}
