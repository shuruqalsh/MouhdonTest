//
//  PasswordManager.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 21/06/1446 AH.
//

import Foundation

class PasswordManager {
    static let shared = PasswordManager() // Singleton لتسهيل الوصول

    private init() {}

    // الرقم السري
    let correctPassword = "1701" // الرقم السري الإنجليزي

    // تحويل الأرقام العربية إلى أرقام إنجليزية
    private func convertArabicToEnglish(_ input: String) -> String {
        let arabicDigits = ["٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4", "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"]
        var converted = input
        arabicDigits.forEach { arabic, english in
            converted = converted.replacingOccurrences(of: arabic, with: english)
        }
        return converted
    }

    // دالة التحقق من صحة الرقم السري
    func isPasswordValid(_ input: String) -> Bool {
        let normalizedInput = convertArabicToEnglish(input) // تحويل الإدخال إلى أرقام إنجليزية
        return normalizedInput == correctPassword // مقارنة الإدخال بالرقم السري
    }
}
