//
//  PasswordScreen.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 21/06/1446 AH.
import SwiftUI

struct PasswordScreen: View {
    @Binding var isEditMode: Bool // للتحكم في وضع التعديل
    @State private var digit1: String = "" // الحقل الأول
    @State private var digit2: String = "" // الحقل الثاني
    @State private var digit3: String = "" // الحقل الثالث
    @State private var digit4: String = "" // الحقل الرابع
    @FocusState private var focusedField: Int? // لتحديد الحقل النشط
    @State private var showError: Bool = false // للتحكم في عرض رسالة الخطأ
    @Environment(\.dismiss) private var dismiss // لإغلاق الشاشة

    var body: some View {
        VStack(spacing: 20) {
            // العنوان
            Text("أدخل الرمز السري")
                .font(.largeTitle)
                .padding()

            // مربعات إدخال الرقم السري
            HStack(spacing: 15) {
                TextField("", text: $digit1)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.title)
                    .focused($focusedField, equals: 0)
                    .onChange(of: digit1) { _ in moveToNextField(current: 0) }
                    .onTapGesture { focusedField = 0 }

                TextField("", text: $digit2)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.title)
                    .focused($focusedField, equals: 1)
                    .onChange(of: digit2) { _ in moveToNextField(current: 1) }
                    .onTapGesture { focusedField = 1 }

                TextField("", text: $digit3)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.title)
                    .focused($focusedField, equals: 2)
                    .onChange(of: digit3) { _ in moveToNextField(current: 2) }
                    .onTapGesture { focusedField = 2 }

                TextField("", text: $digit4)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.title)
                    .focused($focusedField, equals: 3)
                    .onTapGesture { focusedField = 3 }
            }

            // التلميح (Hint)
            Text("Hint: الرقم السري هو 1701")
                .font(.footnote)
                .foregroundColor(.gray)

            // رسالة الخطأ
            if showError {
                Text("الرمز السري غير صحيح")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }

            // الأزرار: تأكيد وإلغاء
            HStack(spacing: 20) {
                // زر التأكيد
                Button("تأكيد") {
                    validatePassword()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // زر الإلغاء
                Button("إلغاء") {
                    dismiss()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            focusedField = 0
        }
    }

    // التنقل التلقائي بين الحقول
    private func moveToNextField(current: Int) {
        if current < 3 && getFieldValue(current: current).count == 1 {
            focusedField = current + 1
        }
    }

    // جلب قيمة الحقل بناءً على رقمه
    private func getFieldValue(current: Int) -> String {
        switch current {
        case 0: return digit1
        case 1: return digit2
        case 2: return digit3
        case 3: return digit4
        default: return ""
        }
    }

    // التحقق من صحة الرقم السري
    private func validatePassword() {
        let enteredPassword = digit1 + digit2 + digit3 + digit4
        if enteredPassword == "1701" {
            isEditMode = true
            dismiss()
        } else {
            showError = true
            resetFields()
        }
    }

    // إعادة تعيين الحقول عند خطأ
    private func resetFields() {
        digit1 = ""
        digit2 = ""
        digit3 = ""
        digit4 = ""
        focusedField = 0
    }
}
