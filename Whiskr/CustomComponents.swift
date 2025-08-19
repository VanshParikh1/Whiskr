//
//  CustomComponents.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-04.
//

import SwiftUI

struct CustomDatePicker: UIViewRepresentable {
    @Binding var date: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(context.coordinator, action: #selector(Coordinator.updateDate(sender:)), for: .valueChanged)
        picker.setValue(UIColor.whiskred, forKeyPath: "textColor") // works 😌
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(date: $date)
    }

    class Coordinator: NSObject {
        var date: Binding<Date>
        init(date: Binding<Date>) {
            self.date = date
        }

        @objc func updateDate(sender: UIDatePicker) {
            self.date.wrappedValue = sender.date
        }
    }
}

struct CloseButton: View {
    let action: () -> Void
    let title: String
    
    init(title: String = "Close", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.white)
                .foregroundColor(.whiskred)
                .cornerRadius(30)
                .padding(.horizontal)
                .shadow(color: Color.whiskred.opacity(0.3), radius: 6, x: 0, y: 4)
        }
    }
}

