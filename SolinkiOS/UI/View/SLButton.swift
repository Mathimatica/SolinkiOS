//
//  SwiftUIView.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-03-01.
//

import SwiftUI

struct SLButton: View {
    let onClick: () -> Void
    var modifier: AnyView = AnyView(EmptyView())
    var enabled: Bool = true
    var tint: Color = .white

    @State private var isPressed = false

    var body: some View {

        Button(action: {
            onClick()
        }) {
            Image(systemName: "arrow.left")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(
                    enabled
                        ? (isPressed ? tint.opacity(0.7) : tint)
                        : Color(
                            UIColor(
                                red: 0xB0 / 255, green: 0xBE / 255,
                                blue: 0xC5 / 255, alpha: 1))
                )  // Corrected color
                .animation(.easeInOut, value: isPressed)
        }
        .frame(width: 48, height: 48)
        .background(
            enabled
                ? Color(
                    UIColor(
                        red: 0x02 / 255, green: 0x88 / 255, blue: 0xD1 / 255,
                        alpha: 1))
                : Color(
                    UIColor(
                        red: 0x01 / 255, green: 0x57 / 255, blue: 0x9B / 255,
                        alpha: 1))
        )  // Corrected color
        .clipShape(Circle())
        .buttonStyle(SLButtonStyle(isPressed: $isPressed))
        .disabled(!enabled)
        //.modifier(modifier)
    }
}

struct SLButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                isPressed = newValue  // Update isPressed with the new value
            }
    }
}

// Example usage:
struct SLButton_Previews: PreviewProvider {
    static var previews: some View {
        SLButton(onClick: { print("Button tapped") })
            .padding()
        SLButton(onClick: { print("Button tapped") }, enabled: false)
            .padding()
    }
}
