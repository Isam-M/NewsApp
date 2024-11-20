//
//  SetupView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import SwiftUI

import SwiftUI

struct SetupView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Manage Categories", destination: CategoryManagerView())
            }
            .navigationTitle("Setup")
        }
    }
}

#Preview {
    SetupView()
}
