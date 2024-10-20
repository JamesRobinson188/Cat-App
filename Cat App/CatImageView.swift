//
//  CatImageView.swift
//  Cat App
//
//  Created by James Robinson on 15/10/2024.
//

import SwiftUI

struct CatImageView: View {
    let catImage: CatImage

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            AsyncImage(url: URL(string: catImage.url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .padding()
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
