//
//  ServiceDetails.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

struct ServiceDetails {
    let serviceTitle: String
    let beneficiaryStatus: String
    let fees: String
    let paymentMethod: String
    let requirementsStatus: String
    let medicalCheckStatus: String
    let timeSavings: Int
    let feeAmount: Double
    let baseFee: Double
    let lateFee: Double
    let isLate: Bool
    
    init(
        serviceTitle: String,
        beneficiaryStatus: String,
        fees: String,
        paymentMethod: String,
        requirementsStatus: String,
        medicalCheckStatus: String,
        timeSavings: Int,
        feeAmount: Double,
        baseFee: Double? = nil,
        lateFee: Double = 0,
        isLate: Bool = false
    ) {
        self.serviceTitle = serviceTitle
        self.beneficiaryStatus = beneficiaryStatus
        self.fees = fees
        self.paymentMethod = paymentMethod
        self.requirementsStatus = requirementsStatus
        self.medicalCheckStatus = medicalCheckStatus
        self.timeSavings = timeSavings
        self.feeAmount = feeAmount
        self.baseFee = baseFee ?? feeAmount
        self.lateFee = lateFee
        self.isLate = isLate
    }
    
    static let mock = ServiceDetails(
        serviceTitle: "تجديد رخصة القيادة",
        beneficiaryStatus: "يوجد مخالفات مرورية",
        fees: "٢٬٧٠٠ ريال",
        paymentMethod: "جاهز للدفع عبر سداد",
        requirementsStatus: "جميع المتطلبات جاهزة وموثقة",
        medicalCheckStatus: "الفحص الطبي تم التحقق منه",
        timeSavings: 25,
        feeAmount: 2700
    )
}
