//
//  CardsScreen.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftUI
import SwiftData

struct CardsScreen: View {
    @Environment(\.modelContext) private var modelContext // للحصول على السياق
    @State private var cards: [Card] = [] // لتخزين الكروت المسترجعة
    @State private var showingNewCardSheet = false // لعرض الـ Sheet الخاصة بإضافة Card جديد
    @State private var recordedFileURL: URL?
    
    
    
    var body: some View {
        ZStack {
            // تعيين الصورة كخلفية
            Image("backgroundImage2") // صورة الخلفية
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            
            VStack {
                
                // زر إضافة بطاقة جديد في أعلى يمين الشاشة
                HStack {
                    Spacer() // يدفع الزر إلى اليمين
                    Button(action: {
                        showingNewCardSheet.toggle()
                    }) {
                        Image("addCardImageHome") // صورة الزر
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50) // تعديل الأبعاد حسب الحاجة
                    }
                    .padding(.trailing) // إبعاد الزر عن الحافة اليمنى
                    .padding(.top)     // إبعاد الزر عن الحافة العلوية
                }
                
                
                ScrollView {
                    // محتوى المكتبات مع المسافات
                    VStack(spacing: 30) { // تحديد المسافة بين المكتبات بـ 20
                        HStack(alignment: .top, spacing: 30) {
                            VStack(spacing: 30) { // المسافة بين الأزرار في العمود الأول
                                Button(action: {
                                    showingNewCardSheet.toggle()
                                }) {
                                    Image("GrayLibrary")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                }
                                
                                Button(action: {
                                    showingNewCardSheet.toggle()
                                }) {
                                    Image("PurpleLibrary")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                }
                            }
                            
                            VStack(spacing: 30) { // المسافة بين الأزرار في العمود الثاني
                                Button(action: {
                                    showingNewCardSheet.toggle()
                                }) {
                                    Image("LightBlueLibrary")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                }
                                
                                Button(action: {
                                    showingNewCardSheet.toggle()
                                }) {
                                    Image("GreenLibrary")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                }
                            }
                            
                            VStack(spacing: 30) { // المسافة بين الأزرار في العمود الثالث
                                Button(action: {
                                    showingNewCardSheet.toggle()
                                }) {
                                    Image("PinkLibrary")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                }
                                
                                Button(action: {
                                    showingNewCardSheet.toggle()
                                }) {
                                    Image("DarkBlueLibrary")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                }
                            }
                        }
                    }
                    .padding() // إضافة مسافة حول المكتبات
                    .padding(.top, 120)
                    
                    
                    
                    // Grid لعرض الكروت
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                        ForEach(cards) { card in
                            CardView(card: card) // عرض الكارد
                        }
                    }
                    .padding()
                    
                    .sheet(isPresented: $showingNewCardSheet) {
                        NewCard(cards: $cards) // عرض نافذة إضافة كارد جديد
                    }
                    
                    .onAppear {
                        loadCards() // عند ظهور الشاشة، تحميل الكروت من قاعدة البيانات
                    }
                } .padding() // نفس البادينج للشبكة
                    .padding(.horizontal)
            }
        }
    }
    
    // دالة لتحميل الكروت من قاعدة البيانات
    private func loadCards() {
        do {
            let fetchDescriptor = FetchDescriptor<Card>()
            let cardsFetch = try modelContext.fetch(fetchDescriptor)
            
            // التحقق من وجود الملفات الصوتية
            cards = cardsFetch.map { card in
                if let path = card.audioFilePath, !FileManager.default.fileExists(atPath: path) {
                    print("الملف الصوتي غير موجود للمسار: \(path)")
                }
                return card
            }
        } catch {
            print("Error loading cards: \(error.localizedDescription)")
        }
    }
    
    
    struct CardsScreen_Previews: PreviewProvider {
        static var previews: some View {
            CardsScreen()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
