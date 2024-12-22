//
//  NewCard.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftUI
import SwiftData
import AVFoundation


struct Recording: Identifiable {
    var id: UUID = UUID()
    var title: String
    var filePath: URL
    var date: Date
}



struct NewCard: View {
    @Environment(\.modelContext) private var modelContext // للحصول على السياق
    @Environment(\.dismiss) private var dismiss // بيئة للإغلاق
    @Binding var cards: [Card] // لإعادة تحميل الكروت بعد إضافة كارد جديد
    @State private var emoji: String = ""
    @State private var description: String = ""
    @State private var selectedColorIndex: Int = 0 // اختيار اللون الافتراضي
    @State private var selectedImage: String = "PurpleLibrary" // اختيار الصورة الافتراضية
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var recordings: [Recording] = []
    @State private var recordedFileURL: URL? // (3) متغير لتخزين مسار ملف الصوت
    
    
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false
    
    
    
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
                VStack {
                    Button(action: toggleRecording) {
                        HStack {
                            Image(systemName: isRecording ? "stop.circle.fill" : "record.circle")
                                .resizable()
                                .frame(width: 40, height: 40) // التحكم بحجم الأيقونة
                                .foregroundColor(isRecording ? .red : .black) // تغيير لون الأيقونة حسب الحالة
                            Text(isRecording ? "اوقف التسجيل" : " سجل صوت المكتبة ")
                                .font(.system(size: 36))
                                .foregroundColor(.black) // لون النص
                        }
                        .padding()
                        .frame(width: 500, height: 120) // التحكم بأبعاد الزر
                        .background(Color.clear) // خلفية شفافة
                        .overlay(
                            RoundedRectangle(cornerRadius: 60)
                                .stroke(Color(.sRGB, red: 255/255, green: 174/255, blue: 26/255, opacity: 1.0), lineWidth: 3)
                            
                            // لون الحدود باستخدام RGB
                        )
                    }
                    .padding()
                    
                    if let fileURL = recordedFileURL {
                        Button(action: togglePlayback) {
                            HStack {
                                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                Text(isPlaying ? "ايقاف التشغيل" : "معاينة الصوت")
                                    .font(.system(size: 36))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(width: 500, height: 120)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 60)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                        }
                        .padding()
                    }

               
                }
                .padding()
                .onAppear {
                    setupAudioSession()
                    requestMicrophonePermission()
                }
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
                            
                            let audioPath = recordedFileURL?.path // تحويل مسار الملف إلى نص
                            let newCard = Card(emoji: emoji, cardDescription: description, audioFilePath: audioPath)
                            
                            
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
    
    
    func togglePlayback() {
        guard let fileURL = recordedFileURL else { return }

        if isPlaying {
            audioPlayer?.stop()
            isPlaying = false
        } else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                audioPlayer?.play()
                isPlaying = true
                DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration ?? 0)) {
                    isPlaying = false
                }
            } catch {
                print("Failed to play recording: \(error.localizedDescription)")
            }
        }
    }

    
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() { // (1) بدء التسجيل مع حد زمني
        let fileName = UUID().uuidString + ".m4a"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            recordedFileURL = fileURL // (2) تخزين مسار الملف
            isRecording = true

            // (3) إيقاف التسجيل تلقائيًا بعد 5 ثوانٍ
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.stopRecording()
            }

            print("Started recording at: \(fileURL.path)")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    func getDocumentsDirectory() -> URL { // (13) دالة للحصول على مسار المجلد
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    

    
    
    func playRecording(url: URL) {
        print("Attempting to play recording from: \(url)")
        
        // Check if the file exists
        if !FileManager.default.fileExists(atPath: url.path) {
            print("File does not exist at \(url.path)")
            return
        }
        
        if isPlaying {
            print("Stopping playback")
            audioPlayer?.stop()
            isPlaying = false
        } else {
            do {
                print("Starting playback for file: \(url.lastPathComponent)")
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = PlaybackDelegate(onPlaybackEnd: {
                    isPlaying = false
                    print("Playback finished")
                })
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("Failed to play recording: \(error.localizedDescription)")
            }
        }
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if !granted {
                print("Microphone access denied")
            }
        }
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            print("Audio session setup successful")
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    class PlaybackDelegate: NSObject, AVAudioPlayerDelegate {
        let onPlaybackEnd: () -> Void
        
        init(onPlaybackEnd: @escaping () -> Void) {
            self.onPlaybackEnd = onPlaybackEnd
        }
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            onPlaybackEnd()
        }
    }
    
    
    struct NewCard_Previews: PreviewProvider {
        @State static var mockCards: [Card] = [] // Create a mock array of cards
        
        static var previews: some View {
            NewCard(cards: $mockCards) // Pass the mock array as a binding
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
