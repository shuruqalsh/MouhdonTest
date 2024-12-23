//
//  PasswordScreen.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 21/06/1446 AH.
//

import Foundation
import SwiftUI

struct PasswordScreen: View {
    @Binding var isEditMode: Bool // للتحكم في وضع التعديل
    @State private var inputPassword: String = "" // النص المدخل
    @State private var showError: Bool = false // التحكم في عرض رسالة الخطأ

    var body: some View {
        VStack {
            Text("أدخل الرمز السري")
                .font(.largeTitle)
                .padding()

            SecureField("الرمز السري", text: $inputPassword) // حقل إدخال الرمز
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if showError {
                Text("الرمز السري غير صحيح")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }

            Button("تأكيد") {
                if PasswordManager.shared.isPasswordValid(inputPassword) {
                    isEditMode = true // تفعيل وضع التعديل
                } else {
                    showError = true // عرض الخطأ
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
