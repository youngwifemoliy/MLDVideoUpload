//
//  MLDLibraryIcon.swift
//  MLDLibrary_Swift
//
//  Created by MoliySDev on 2018/11/29.
//


import UIKit

public class MLDLibraryIcon {
    
    private static var internalBundle: Bundle?
    
    public static var bundle: Bundle {
        if nil == MLDLibraryIcon.internalBundle {
            let bundlePath = "\(Bundle(for: MLDLibraryIcon.self).resourcePath ?? "")/MLDLibrary_Swift.bundle"
            MLDLibraryIcon.internalBundle = Bundle.init(path: bundlePath)
        }
        return MLDLibraryIcon.internalBundle!
    }
    
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }

    //MLDAlertHUD
    public static var MLDHudSuccess = MLDLibraryIcon.icon("MLDHudSuccess")
    public static var MLDHudInfo = MLDLibraryIcon.icon("MLDHudInfo")
    public static var MLDHudError = MLDLibraryIcon.icon("MLDHudError")
    
    //MLDImage
    public static var normal_placeholder_image = MLDLibraryIcon.icon("normal_placeholder_h")

}
