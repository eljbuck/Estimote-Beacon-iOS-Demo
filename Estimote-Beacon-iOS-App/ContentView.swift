//
//  ContentView.swift
//  Estimote-Beacon-iOS-Demo
//
//  Created by Ethan Buck on 7/11/24.
//

import SwiftUI
import EstimoteUWB

struct ContentView: View {
    @StateObject var uwbManagerExample = EstimoteUWBManagerExample()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("UWB Beacon Test App")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: CalibrateView(uwbManager: uwbManagerExample)) {
                    Text("Calibrate")
                }
                
                NavigationLink(destination: RoamView(uwbManager: uwbManagerExample)) {
                    Text("Roam")
                }
                
                NavigationLink(destination: TestView(uwbManager: uwbManagerExample)) {
                    Text("Test")
                }
            }
            .navigationTitle("UWB Beacon Test App")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalibrateView: View {
    @ObservedObject var uwbManager: EstimoteUWBManagerExample
    
    var body: some View {
        Text("Calibrate View")
            .font(.title)
            .padding()
            .onAppear {
                // Start scanning when view appears
                uwbManager.startScanning()
            }
            .onDisappear {
                // Stop scanning when view disappears
                uwbManager.stopScanning()
            }
    }
}

//struct CalibrateView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalibrateView()
//    }
//}

struct RoamView: View {
    @ObservedObject var uwbManager: EstimoteUWBManagerExample
    
    var body: some View {
        Text("Roam View")
            .font(.title)
            .padding()
            .onAppear {
                // Start scanning when view appears
                uwbManager.startScanning()
            }
            .onDisappear {
                // Stop scanning when view disappears
                uwbManager.stopScanning()
            }
    }
}

//struct RoamView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoamView()
//    }
//}

struct TestView: View {
    @ObservedObject var uwbManager: EstimoteUWBManagerExample
    
    var body: some View {
        Text("Test View")
            .onAppear {
                uwbManager.startScanning()
            }
            .onDisappear {
                uwbManager.stopScanning()
            }
    }
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}

class EstimoteUWBManagerExample: NSObject, ObservableObject {
    private var uwbManager: EstimoteUWBManager?
    
    override init() {
        super.init()
        setupUWB()
    }
    
    private func setupUWB() {
        uwbManager = EstimoteUWBManager(delegate: self,
                                        options: EstimoteUWBOptions(shouldHandleConnectivity: true,
                                                                    isCameraAssisted: false))
    }
    
    func startScanning() {
        uwbManager?.startScanning()
    }
    
    func stopScanning() {
        uwbManager?.stopScanning()
    }
}

extension EstimoteUWBManagerExample: EstimoteUWBManagerDelegate {
    func didUpdatePosition(for device: EstimoteUWBDevice) {
        print("Position updated for device: \(device)")
    }
    
    func didDiscover(device: UWBIdentifiable, with rssi: NSNumber, from manager: EstimoteUWBManager) {
        print("Discovered device: \(device.publicIdentifier) rssi: \(rssi)")
        // Optionally, you can handle connection logic here
    }
    
    func didConnect(to device: UWBIdentifiable) {
        print("Successfully connected to: \(device.publicIdentifier)")
    }
    
    func didDisconnect(from device: UWBIdentifiable, error: Error?) {
        print("Disconnected from device: \(device.publicIdentifier)- error: \(String(describing: error))")
    }
    
    func didFailToConnect(to device: UWBIdentifiable, error: Error?) {
        print("Failed to connect to: \(device.publicIdentifier) - error: \(String(describing: error))")
    }
}
