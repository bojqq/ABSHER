import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Dark background
            Color.absherBackground
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Absher logo
                VStack(spacing: 16) {
                    Image("AbsherLogo")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                }
                
                Spacer()
                
                // Service availability text
                Text("خدمات متوفرة على مدار الساعة طوال الأسبوع")
                    .font(.absherBody)
                    .foregroundColor(.absherTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Loading indicator with text
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .absherMint))
                        .scaleEffect(1.2)
                    
                    Text("جار التحميل...")
                        .font(.absherBody)
                        .foregroundColor(.absherTextSecondary)
                }
                .padding(.bottom, 60)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    LoadingView()
}
