//
//  ContentLayer.swift
//  flint
//
//  Created by Dylan Karunanayake on 26/11/2026.
//

import SwiftUI

// The layer on which the usable launcher content sits
struct ContentLayer: View {
    var body: some View {
        ConcentricRectangle()
            .fill(.black.opacity(0.125))
            .overlay(
                Text("flint")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
            )
    }
}
