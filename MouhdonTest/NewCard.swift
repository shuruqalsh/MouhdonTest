//
//  NewCard.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftUI
import SwiftData

struct NewCard: View {
    @Environment(\.modelContext) private var modelContext // للحصول على السياق
    @Environment(\.dismiss) private var dismiss // بيئة للإغلاق
    @Binding var cards: [Card] // لإعادة تحميل الكروت بعد إضافة كارد جديد
    @State private var emoji: String = ""
    @State private var description: String = ""
    @State private var selectedColorIndex: Int = 0 // اختيار اللون الافتراضي
        @State private var selectedImage: String = "PurpleLibrary" // اختيار الصورة الافتراضية
    
    // مصفوفة الألوان المرتبطة بالصور
     let colorsAndImages: [(color: Color, image: String)] = [
         (Color(hex: "#EAD4EA"), "PurpleLibrary"), // بنفسجي
         (Color(hex: "#D6F5D9"), "GreenLibrary"), // أخضر فاتح
         (Color(hex: "#BEE8FE"), "LightBlueLibrary"), // أزرق فاتح
         (Color(hex: "#C2D9F2"), "DarkBlueLibrary"), // أزرق غامق
         (Color(hex: "#FFE6DC"), "PinkLibrary"), // وردي
         (Color(hex: "#E5EAE3"), "GrayLibrary")  // رمادي
     ]
    
    
    var body: some View {
       
        ZStack {
            Color(hex: "FFF6E8") // لون الخلفية للشاشة بالكامل
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    // البطاقة الرئيسية
                    Image(selectedImage) // الصورة المرتبطة بالاختيار
                        .resizable()
                        .scaledToFill()
                        .frame(width:400 , height: 240) // أبعاد البطاقة
                        .clipped()
                        .cornerRadius(20) // إضافة الزوايا الدائرية إذا لزم الأمر
                    
                    // النص والصورة فوق البطاقة
                    VStack(spacing: 5) {
                        Image("Face") // الوجه المبتسم
                            .resizable()
                            .scaledToFit()
                            .offset(y: 10)
                    
                    }
                    .frame(width: 300, height: 200) // نفس أبعاد البطاقة
                    .allowsHitTesting(false) // منع التأثير على التفاعلات مع البطاقة
                }

                TextField("ادخل ايموجي", text: $emoji)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .keyboardType(.default)
                
    
                
                TextField("انقر لكتابة اسم لمكتبة", text: $description)
                    .font(.body)
                    .padding()
                    .keyboardType(.default)
                
                          HStack(spacing: 15) {
                              ForEach(colorsAndImages.indices, id: \.self) { index in
                                  Circle()
                                      .fill(colorsAndImages[index].color) // [9] عرض الدائرة بلون معين
                                      .frame(width: 50, height: 50) // [10] حجم الدائرة
                                      .overlay(
                                          Circle()
                                              .stroke(selectedColorIndex == index ? Color.black : Color.clear, lineWidth: 3) // [11] تمييز الدائرة المختارة
                                      )
                                      .onTapGesture {
                                          selectedColorIndex = index // [12] تحديث اللون المختار
                                          selectedImage = colorsAndImages[index].image // [13] تحديث الصورة بناءً على اللون
                                      }
                              }
                          }
                HStack(spacing: 20) {
                    // زر الإلغاء
                    Button("الغاء") {
                        dismiss() // إغلاق الشيت عند الضغط
                    }
                    .font(.system(size: 36))
                    .bold()
                    .padding()
                    .frame(width: 206, height: 85)
                    .cornerRadius(42.5)
                    .background( Color(hex: "FFA707"))
                    .foregroundColor(.black)
                    .cornerRadius(42.5)
                    
                    // زر الحفظ
                    Button("حفظ") {
                        if !emoji.isEmpty && !description.isEmpty {
                            // إنشاء كارد جديد
                            let newCard = Card(emoji: emoji, cardDescription: description)
                            
                            // إضافة الكارد إلى الـ modelContext
                            modelContext.insert(newCard)
                            
                            // حفظ التغييرات في الـ modelContext
                            do {
                                try modelContext.save()
                                
                                // بعد حفظ الكارد، نحدث قائمة الكروت في الـ parent view
                                cards.append(newCard)
                                
                                // إعادة تعيين القيم المدخلة
                                emoji = ""
                                description = ""
                                dismiss() // إغلاق الشيت بعد الحفظ
                            } catch {
                                print("Error saving card: \(error.localizedDescription)")
                            }
                        }
                    }
                    .padding()
                    .font(.system(size: 36))
                    .bold()
                    .frame(width: 206, height: 85)
                    .cornerRadius(42.5)
                    .background( Color(hex: "A2FFAB"))
                    .bold()
                    .foregroundColor(.black)
                    .cornerRadius(42.5)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct NewCard_Previews: PreviewProvider {
    @State static var mockCards: [Card] = [] // Create a mock array of cards
    
    static var previews: some View {
        NewCard(cards: $mockCards) // Pass the mock array as a binding
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
