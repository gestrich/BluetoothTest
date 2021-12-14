//
//  ContentView.swift
//  BluetoothTest
//
//  Created by Bill Gestrich on 12/12/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Test") {
            Task {
                await OmnipodInteractor().run()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
