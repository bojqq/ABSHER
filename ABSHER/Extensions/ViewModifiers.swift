import SwiftUI

// MARK: - Card Styles

struct AbsherCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.absherCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.absherCardBorder, lineWidth: 1)
            )
    }
}

struct ProactiveAlertCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [Color.absherOrange.opacity(0.3), Color.absherCardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.absherOrange, lineWidth: 2)
            )
            .shadow(color: Color.absherOrange.opacity(0.3), radius: 8, y: 4)
    }
}

// MARK: - Button Styles

struct AbsherPrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.absherHeadline)
            .foregroundColor(.absherBackground)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.absherMint)
            .cornerRadius(12)
    }
}

// MARK: - View Extensions

extension View {
    func absherCardStyle() -> some View {
        modifier(AbsherCardStyle())
    }
    
    func proactiveAlertCardStyle() -> some View {
        modifier(ProactiveAlertCardStyle())
    }
    
    func absherPrimaryButton() -> some View {
        modifier(AbsherPrimaryButton())
    }
}
