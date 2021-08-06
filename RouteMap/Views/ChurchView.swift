//
//  ChurchView.swift
//  ChurchView
//
//  Created by William Finnis on 06/08/2021.
//

import SwiftUI

struct ChurchView: View {
    let church: Church
    
    var body: some View {
        Text(church.name)
    }
}
