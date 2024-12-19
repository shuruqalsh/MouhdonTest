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
                
                // Grid لعرض الكروت
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(cards) { card in
                            CardView(card: card) // عرض الكارد
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showingNewCardSheet) {
                    NewCard(cards: $cards) // عرض نافذة إضافة كارد جديد
                }
            }
            .onAppear {
                loadCards() // عند ظهور الشاشة، تحميل الكروت من قاعدة البيانات
            }
        }
    }
    
    // دالة لتحميل الكروت من قاعدة البيانات
    private func loadCards() {
        do {
            let fetchDescriptor = FetchDescriptor<Card>()
            let cardsFetch = try modelContext.fetch(fetchDescriptor)
            cards = cardsFetch.sorted { $0.id < $1.id }
        } catch {
            print("Error loading cards: \(error.localizedDescription)")
        }
    }
}

struct CardsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardsScreen()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
