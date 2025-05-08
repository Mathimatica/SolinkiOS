//
//  testing.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-04-02.
//

import Foundation
import SwiftUI

struct TestView: View {
    var body: some View {
            VStack(spacing: 16) {
                
                Text("This is my list")
                    .multilineTextAlignment(.center).font(.largeTitle)
                
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(0..<50) { index in
                            Text("Item \(index)")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .font(.body)
                        }
                    }
                    //.padding()
                }
                .frame(maxHeight: .infinity) // Takes remaining space
                
                // Footer button
                Button(action: {
                    print("Button tapped")
                }) {
                    Text("Footer Button")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
}

#Preview {
    TestView()
}
