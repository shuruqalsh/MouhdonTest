//
//  GenderSelectionView.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftUI

struct GenderSelectionView: View {
    var body: some View {
        NavigationView { // إضافة NavigationView
            ZStack {
                // الخلفية
                Image("backgroundImage2") // اسم الصورة الخاصة بالخلفية
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("لمن تُصمم البطاقات؟ اختر جنس طفلك للبدء") // العنوان الرئيسي
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom, 50)
                    
                    HStack(spacing: 40) { // الصور جنب بعض
                        // صورة الذكر
                        NavigationLink(destination: MaleView()) {
                            Image("MaleIcon") // استبدل بـ اسم صورة الذكر
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        
                        // صورة الأنثى
                        NavigationLink(destination: FemaleView()) {
                            Image("femaleIcon") // استبدل بـ اسم صورة الأنثى
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true) // إخفاء زر الرجوع
        }
    }
}

struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderSelectionView()
    }
}
