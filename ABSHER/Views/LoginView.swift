import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var stayLoggedIn: Bool = false
    
    var body: some View {
        ZStack {
            // Dark background
            Color.absherBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top navigation bar with back button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Back button action (no-op in prototype)
                    }) {
                        Text("")
                            .font(.absherBody)
                            .foregroundColor(.absherMint)
                    }
                    .padding(.trailing, 16)
                }
                .frame(height: 44)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Dual logos (Absher left, Ministry right)
                        HStack(spacing: 24) {
                            Image("AbsherLogo")
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110, height: 110)
                            
                            Image("MinistryLogo")
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110, height: 110)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .environment(\.layoutDirection, .leftToRight)
                        
                        // Login title
                        Text("تسجيل الدخول إلى أبشر")
                            .font(.absherTitle)
                            .foregroundColor(.absherTextPrimary)
                            .padding(.top, 4)
                        
                        // Login form fields
                        VStack(spacing: 20) {
                            // Username field
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("اسم المستخدم أو رقم الهوية")
                                    .font(.absherCaption)
                                    .foregroundColor(.absherTextSecondary)
                                
                                TextField("", text: $username)
                                    .font(.absherBody)
                                    .foregroundColor(.absherTextPrimary)
                                    .padding()
                                    .frame(height: 50)
                                    .background(Color.absherCardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.absherCardBorder, lineWidth: 1)
                                    )
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            // Password field
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("كلمة المرور")
                                    .font(.absherCaption)
                                    .foregroundColor(.absherTextSecondary)
                                
                                SecureField("أدخل كلمة المرور", text: $password)
                                    .font(.absherBody)
                                    .foregroundColor(.absherTextPrimary)
                                    .padding()
                                    .frame(height: 50)
                                    .background(Color.absherCardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.absherCardBorder, lineWidth: 1)
                                    )
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            // Stay logged in checkbox
                            HStack(spacing: 12) {
                                Spacer()
                                
                                Text("عدم تسجيل الخروج")
                                    .font(.absherBody)
                                    .foregroundColor(.absherTextPrimary)
                                
                                Button(action: {
                                    stayLoggedIn.toggle()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.absherCardBorder, lineWidth: 1)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(stayLoggedIn ? Color.absherMint : Color.absherCardBackground)
                                            )
                                        
                                        if stayLoggedIn {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.absherBackground)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding(.top, 24)
                        
                        // Login button
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("تسجيل الدخول")
                                .absherPrimaryButton()
                        }
                        .padding(.top, 32)
                        
                        // Forgot password link
                        Button(action: {
                            // Forgot password action (no-op in prototype)
                        }) {
                            Text("نسيت كلمة المرور")
                                .font(.absherBody)
                                .foregroundColor(.absherMint)
                        }
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    LoginView(viewModel: AppViewModel())
}
