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
    @State private var showingPasswordScreen = false // لعرض شاشة إدخال الرمز السري
    @State private var isEditMode = false // لتفعيل وضع التعديل
    @State private var recordedFileURL: URL?

    var body: some View {
        NavigationStack {
            ZStack {
                // تعيين الصورة كخلفية
                Image("backgroundImage2") // صورة الخلفية
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    // زر إضافة بطاقة جديد وزر تعديل
                    HStack {
                        Spacer() // يدفع الأزرار إلى أقصى اليمين
                        
                        // زر إضافة بطاقة جديدة
                        Button(action: {
                            showingNewCardSheet.toggle()
                        }) {
                            Image("addCardImageHome") // صورة الزر
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 50) // تعديل الأبعاد حسب الحاجة
                        }
                        .padding(.trailing)
                        .padding(.top)
                        
                        // زر تعديل
                        Button(action: {
                            if isEditMode {
                                // إنهاء وضع التعديل
                                isEditMode = false
                            } else {
                                // عرض شاشة الرقم السري لتفعيل التعديل
                                showingPasswordScreen = true
                            }
                        }) {
                            Text(isEditMode ? "إنهاء التعديل" : "تعديل")
                                .font(.title2)
                                .padding()
                                .background(isEditMode ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .sheet(isPresented: $showingPasswordScreen) {
                            PasswordScreen(isEditMode: $isEditMode) // شاشة إدخال الرقم السري
                        }
                    }
                    
                    .sheet(isPresented: $showingPasswordScreen) {
                        PasswordScreen(isEditMode: $isEditMode)
                    }
                    
                    ScrollView {
                        // محتوى المكتبات مع المسافات
                        VStack(spacing: 30) {
                            HStack(alignment: .top, spacing: 30) {
                                
                                VStack(spacing: 30) {
                                    
                                    NavigationLink(destination: LibraryGirl1()) {
                                        Image("GrayLibrary")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 400, height: 240)
                                    }
                                    
                                    NavigationLink(destination: LibraryGirl2()) {
                                        Image("PurpleLibrary")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 400, height: 240)
                                    }
                                }
                            
                                VStack(spacing: 30) {
                                    
                                    NavigationLink(destination: LibraryGirl3()){
                                        Image("LightBlueLibrary")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 400, height: 240)
                                    }
                                    
                                    NavigationLink(destination: LibraryGirl4()) {
                                        Image("GreenLibrary")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 400, height: 240)
                                    }
                                }
                                
                                VStack(spacing: 30) {
                                    NavigationLink(destination: LibraryGirl5())
                                    {
                                        Image("PinkLibrary")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 400, height: 240)
                                    }
                                    
                                    NavigationLink(destination: LibraryGirl6()) {
                                        Image("DarkBlueLibrary")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 400, height: 240)
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.top, 120)
                        
                        // Grid لعرض الكروت
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                            ForEach(cards) { card in
                                CardView(card: card, isEditMode: isEditMode) // عرض الكارد مع وضع التعديل
                            }
                        }
                        .padding()
                        .sheet(isPresented: $showingNewCardSheet) {
                            NewCard(cards: $cards) // عرض نافذة إضافة كارد جديد
                        }
                        .onAppear {
                            loadCards() // عند ظهور الشاشة، تحميل الكروت من قاعدة البيانات
                        }
                    }
                    .padding()
                    .padding(.horizontal)
                }
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

    
    
    // تفعيل أو إلغاء وضع التعديل
        private func toggleEditMode() { // (3) تغيير حالة وضع التعديل
            isEditMode.toggle()
        }
    
    
    struct CardsScreen_Previews: PreviewProvider {
        static var previews: some View {
            CardsScreen()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
