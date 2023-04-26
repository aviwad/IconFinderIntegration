//
//  IconPage.swift
//  IconFinderIntegration
//
//  Created by Avi Wadhwa on 25/04/23.
//

import SwiftUI

struct IconPage: View {
    var icon: Icon
    var body: some View {
        List {
            if ((icon.vectorSizes) != nil) {
                ForEach(0..<icon.vectorSizes!.count) { index in
                    Text("Vector: size \(icon.vectorSizes![index].size)")
                }
            }
            if ((icon.rasterSizes) != nil) {
                ForEach(0..<icon.rasterSizes!.count) { index in
                    Text("Raster: size \(icon.rasterSizes![index].size)")
                }
            }

        }
            .navigationTitle("Icon Download")
    }
}

