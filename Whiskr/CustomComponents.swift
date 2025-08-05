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

