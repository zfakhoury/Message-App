//
//  User.swift
//  Message App
//
//  Created by Zouhair Fakhoury on 13/10/2024.
//

import Foundation
import SwiftUI

struct User: Decodable {
    let bio: String
    let firstName: String
    let lastName: String
    let picURL: String
}

extension User {
    static var previewUser: User {
        User(
            bio: "Hello, I'm Zouhair",
            firstName: "Zouhair",
            lastName: "Fakhoury",
            picURL: "https://media.licdn.com/dms/image/D4E12AQG0hyhZmq0AyQ/article-cover_image-shrink_600_2000/0/1700488940348?e=2147483647&v=beta&t=eZtDe_xSbm65L-mR1tnM8vnfMpM3aWcSe8rw8o7sjSs"
        )
    }
}
