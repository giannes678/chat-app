//
//  Constants.swift
//  trial002
//
//  Created by Mikael Giannes M. Bernardino on 3/26/23.
//

struct K {
    static let appName = "⚡️TrialChat"
    static let contactCellIdentifier = "ContactReusableCell"
    static let cellIdentifier = "ReusableCell"
    static let contactCellNibName = "ContactCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
