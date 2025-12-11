import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum AbsherAssetImage: String {
    case drivingLicense = "DrivingLic"
    case profilePhoto = "Me"
    
    var preferredExtensions: [String] {
        ["png", "jpeg", "jpg"]
    }
}

extension Image {
    static func absherAsset(_ asset: AbsherAssetImage) -> Image? {
        absherAsset(named: asset.rawValue, preferredExtensions: asset.preferredExtensions)
    }
    
    static func absherAsset(fileName: String) -> Image? {
        guard !fileName.isEmpty else { return nil }
        let url = URL(fileURLWithPath: fileName)
        let baseName = url.deletingPathExtension().lastPathComponent
        let ext = url.pathExtension.lowercased()
        
        if ext.isEmpty {
            return absherAsset(named: baseName, preferredExtensions: ["png", "jpeg", "jpg"])
        } else {
            return absherAsset(named: baseName, fileExtension: ext)
        }
    }
    
    static func absherAsset(named name: String, preferredExtensions: [String]) -> Image? {
        for ext in preferredExtensions {
            if let image = absherAsset(named: name, fileExtension: ext) {
                return image
            }
        }
        return nil
    }
    
    static func absherAsset(named name: String, fileExtension: String) -> Image? {
        guard let path = Bundle.main.path(
            forResource: name,
            ofType: fileExtension,
            inDirectory: "assets"
        ) else {
            return nil
        }
#if canImport(UIKit)
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        return Image(uiImage: image)
#elseif canImport(AppKit)
        guard let image = NSImage(contentsOfFile: path) else { return nil }
        return Image(nsImage: image)
#else
        return nil
#endif
    }
}

