//
//  ProactiveAlert.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

struct ProactiveAlert {
    let iconName: String
    let title: String
    let serviceType: String
    let daysRemaining: Int
    let message: String
    let actionText: String
    
    static let mock = ProactiveAlert(
        iconName: "bell.fill",
        title: "تنبيه استباقي",
        serviceType: "تجديد رخصة القيادة",
        daysRemaining: 180,
        message: "رخصة قيادتك على وشك الانتهاء خلال 180 يومًا",
        actionText: "اضغط للموافقة والدفع الآن"
    )
}
