//
//  CardView.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//
import SwiftUI
import AVFoundation
import SwiftUI
import AVFoundation

struct CardView: View {
    var card: Card
    @State private var audioPlayer: AVAudioPlayer? // (1) متغير لتشغيل الصوت
    @State private var isPlaying = false // (2) حالة التشغيل

    var body: some View { // (3) تعريف نوع الإرجاع بـ some View
        VStack {
            Text(card.emoji)
                .font(.system(size: 50))
            Text(card.cardDescription)
                .font(.body)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 400, height: 240)
        .background(Image("GrayLibrary") // اسم الصورة التي تريد استخدامها كخلفية
            .resizable()
            .scaledToFill() // لجعل الصورة تغطي الخلفية بالكامل
            .clipped() )
        .padding(.bottom, 10)
        .onTapGesture { // (4) تشغيل الصوت عند الضغط على البطاقة
            playAudio(for: card)
        }
    }

    func playAudio(for card: Card) { // (5) تشغيل الصوت عند الطلب
        guard let audioPath = card.audioFilePath else { return } // تحقق من وجود المسار
        let fileURL = URL(fileURLWithPath: audioPath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL) // تهيئة مشغل الصوت
            audioPlayer?.play()
            isPlaying = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration ?? 0)) {
                isPlaying = false
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)") // طباعة أي خطأ
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        // بيانات اختبار (Mock Data)
        let mockCard = Card(
            emoji: "🎵",
            cardDescription: "This is a sample card description.",
            audioFilePath: Bundle.main.path(forResource: "sample", ofType: "mp3") // اسم ملف الصوت التجريبي
        )

        // تمرير بيانات الاختبار إلى CardView
        return CardView(card: mockCard)
            .previewDevice("iPad Pro (12.9-inch) (6th generation)") // المحاكي المطلوب
    }
}
