//
//  CardView.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    var body: some View {
        VStack {
            Text(card.emoji)
                .font(.system(size: 50))
            Text(card.cardDescription)
                .font(.body)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
        .padding(.bottom, 10)
    }
}
