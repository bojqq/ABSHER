import SwiftUI
import Foundation

struct LicenseHeaderCard: View {
    let profile: UserProfile
    let serviceTitle: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            licenseBanner
            infoSection
            chipsRow
        }
        .padding(16)
        .absherCardStyle()
    }
    
    private var infoSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(serviceTitle)
                .font(.absherHeadline)
                .foregroundColor(.absherTextPrimary)
            
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(profile.name)
                        .font(.absherBody)
                        .foregroundColor(.absherTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text(profile.idNumber)
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                
                profileImageView
            }
        }
    }
    
    private var chipsRow: some View {
        HStack(spacing: 8) {
            Spacer()
            
            Text("Driving License")
                .font(.absherCaption)
                .foregroundColor(.absherGreen)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(Color.absherGreen.opacity(0.15))
                .clipShape(Capsule())
            
            Text("SA")
                .font(.absherCaption)
                .foregroundColor(.absherTextSecondary)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(Color.absherCardBorder.opacity(0.3))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder
    private var profileImageView: some View {
        if let image = loadProfileImage() {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.absherCardBorder, lineWidth: 1)
                )
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 24))
                .foregroundColor(.absherGreen)
                .frame(width: 52, height: 52)
                .background(Color.absherGreen.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
    
    private var licenseBanner: some View {
        GeometryReader { proxy in
            Group {
                if let licenseImage = Image.absherAsset(.drivingLicense) {
                    licenseImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height * 2,
                            alignment: .top
                        )
                        .clipped()
                } else {
                    Color.absherCardBackground
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
        }
        .frame(height: 76)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    private func loadProfileImage() -> Image? {
        guard let resource = profile.profileImage, !resource.isEmpty else {
            return nil
        }
        
        return Image.absherAsset(fileName: resource)
    }
}

#Preview {
    LicenseHeaderCard(
        profile: .init(
            name: "إلياس محمد ناصر البدوي الغامدي",
            idNumber: "١١٢٩٣٤٥١٩٣",
            profileImage: "Me.png"
        ),
        serviceTitle: "تجديد رخصة القيادة"
    )
    .padding()
    .background(Color.absherBackground)
    .environment(\.layoutDirection, .rightToLeft)
}

