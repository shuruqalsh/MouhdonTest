//
//  OnboardingView.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false // تخزين حالة المستخدم
    @State private var currentPage = 0 // لتتبع الصفحة الحالية
    @State private var isGenderSelectionPresented = false // حالة إعادة تعيين Root View

    var body: some View {
        ZStack {
            // تعيين الصورة كخلفية
            Image("backgroundImage") // صورة الخلفية
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geometry in
                VStack() {
                    // TabView للتنقل بين الصفحات مع تأثير السواب
                    TabView(selection: $currentPage) {
                        // الصفحة الأولى
                        VStack(alignment: .center) {
                            Image("pageOneImage") // الصورة الخاصة بالصفحة الأولى
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                                .offset(y: -100)
                            Text("تطبيق رقمي للتواصل مستوحى من البطاقات المصورة (PECS). يساعد طفلك على التعبير عن احتياجاته اليومية بسهولة، مثل الجوع أو المشاعر، عبر بطاقات بسيطة وسهلة الاستخدام")
                                .font(.system(size: 36))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .tag(0)

                        // الصفحة الثانية
                        VStack {
                            Image("pageTwoImage") // الصورة الخاصة بالصفحة الثانية
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                                .offset(y: -100)
                            Text("أضفوا صورًا، نصوصًا، وأصواتًا مخصصة تجعل البطاقات أكثر قربًا ووضوحًا لطفلكم.")
                                .font(.system(size: 36))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // إلغاء ظهور المؤشر بين الصفحات

                    // المؤشر بين الصفحات (المستطيل)
                    HStack {
                        Rectangle()
                            .fill(currentPage == 0 ? Color.white : Color(hex: "#B18F53")) // إذا كنت في الصفحة الأولى، سيكون مستطيل أبيض
                            .frame(width: currentPage == 0 ? 40 : 10, height: 10) // تحديد العرض حسب الصفحة النشطة
                            .cornerRadius(5) // التحكم في الراديوس (نصف القطر)

                        Rectangle()
                            .fill(currentPage == 1 ? Color.white : Color(hex: "#B18F53")) // إذا كنت في الصفحة الثانية، سيكون مستطيل أبيض
                            .frame(width: currentPage == 1 ? 40 : 10, height: 10) // تحديد العرض حسب الصفحة النشطة
                            .cornerRadius(5) // التحكم في الراديوس (نصف القطر)
                    }
                    .padding()

                    // زر الانتقال بين الصفحات
                    if currentPage == 0 {
                        Button(action: {
                            currentPage = 1 // الانتقال إلى الصفحة الثانية عند الضغط
                        }) {
                            Text("التالي")
                                .frame(width: 455.54, height: 70)
                                .background(Color.white)
                                .cornerRadius(32.5)
                                .font(.system(size: 36))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    } else {
                        Button(action: {
                            // إعادة تعيين Root View إلى GenderSelectionView
                            isGenderSelectionPresented = true
                        }) {
                            Text(" التالي")
                                .frame(width: 455.54, height: 70)
                                .background(Color.white)
                                .cornerRadius(32.5)
                                .font(.system(size: 36))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .fullScreenCover(isPresented: $isGenderSelectionPresented) {
                            GenderSelectionView()
                        }
                    }
                }
                .padding(100)
            }
        }
        .onAppear {
            if hasSeenOnboarding {
                // يمكن إضافة عملية الانتقال إلى الصفحة الرئيسية هنا
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

