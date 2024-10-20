//
//  ContentView.swift
//  Cat App
//
//  Created by James Robinson on 15/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CatViewModel()

    var body: some View {
        if viewModel.catImages.isEmpty {
            ProgressView("Loading Cats...")
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.catImages.indices, id: \.self) { index in
                        CatImageView(catImage: viewModel.catImages[index])
                            .frame(height: UIScreen.main.bounds.height)
                            .onAppear {
                                if index == viewModel.catImages.count - 3 {
                                    viewModel.fetchMoreCats()
                                }
                            }
                            .scrollTargetLayout()
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
