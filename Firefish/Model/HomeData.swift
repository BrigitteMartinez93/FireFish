//
//  HomeData.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import Foundation

struct HomeData {
    var id: String!
    var name: String!
    var numComments: Int!
    var datePublished: String!
    var typePost: String!
}

struct Comments {
    var id: String!
    var user: String!
    var body: String!
    var datePost: String!
}
