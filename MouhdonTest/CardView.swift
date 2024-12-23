//
//  CardView.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//
import SwiftUI
import AVFoundation

struct CardView: View {
    var card: Card
    @State private var audioPlayer: AVAudioPlayer? // (1) متغير لتشغيل الصوت
    @State private var isPlaying = false // (2) حالة التشغيل
    @State private var showEditScreen = false // (3) متغير لعرض شاشة التعديل
    var isEditMode: Bool // (4) تحديد إذا كان في وضع التعديل أم لا

    var body: some View { // (5) تعريف نوع الإرجاع بـ some View
        ZStack { // (6) استخدام ZStack لتداخل المحتوى
            VStack {
                Text(card.emoji) // (7) عرض الرمز النصي (emoji)
                    .font(.system(size: 50))
                Text(card.cardDescription) // (8) عرض وصف الكارد
                    .font(.body)
                    .padding(.top, 5)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(width: 400, height: 240) // (9) تحديد حجم البطاقة
            .background(Image("GrayLibrary") // (10) استخدام صورة خلفية
                .resizable()
                .scaledToFill()
                .clipped()
            )
            .padding(.bottom, 10)

            // (11) إظهار أزرار التعديل والحذف فقط في وضع التعديل
            if isEditMode {
                HStack {
                    Spacer()
                    // زر التعديل
                    Button(action: {
                        showEditScreen = true // (12) تفعيل شاشة التعديل عند الضغط
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(10)

                    // زر الحذف
                    Button(action: {
                        deleteCard() // (13) استدعاء دالة الحذف
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(10)
                }
            }
        }
        .onTapGesture { // (14) تشغيل الصوت عند الضغط على البطاقة
            if !isEditMode { // (15) الصوت يعمل فقط إذا لم يكن في وضع التعديل
                playAudio(for: card)
            }
        }
        .sheet(isPresented: $showEditScreen) { // (16) عرض شاشة التعديل
            NewCard(cards: .constant([])) // (17) شاشة التعديل (يمكن ربطها بالكارد لاحقًا)
        }
    }

    func playAudio(for card: Card) { // (18) تشغيل الصوت عند الطلب
        guard let audioPath = card.audioFilePath else { return } // (19) التحقق من وجود المسار الصوتي
        let fileURL = URL(fileURLWithPath: audioPath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL) // (20) تهيئة مشغل الصوت
            audioPlayer?.play() // (21) تشغيل الصوت
            isPlaying = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration ?? 0)) {
                isPlaying = false // (22) تحديث حالة التشغيل بعد انتهاء الصوت
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)") // (23) التعامل مع الأخطاء
        }
    }

    func deleteCard() { // (24) وظيفة لحذف الكارد
        print("Card deleted: \(card.id)") // (25) هنا يمكنك استبدالها بمنطق الحذف الفعلي
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        // (26) بيانات اختبار (Mock Data)
        let mockCard = Card(
            emoji: "🎵",
            cardDescription: "This is a sample card description.",
            audioFilePath: Bundle.main.path(forResource: "sample", ofType: "mp3") // اسم ملف الصوت التجريبي
        )

        // (27) تمرير بيانات الاختبار إلى CardView
        return CardView(card: mockCard, isEditMode: true)
            .previewDevice("iPad Pro (12.9-inch) (6th generation)") // (28) المحاكي المطلوب
    }
}
