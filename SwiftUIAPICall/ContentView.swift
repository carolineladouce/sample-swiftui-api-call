//
//  ContentView.swift
//  SwiftUIAPICall
//
//  Created by Caroline LaDouce on 8/16/22.
//

import SwiftUI

// 13.
// Create a custom view called URLImage
// It will handle showing a placeholder image as well as kicking off the fetch of the image with URL
struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    // If we have the data, show image
    // If we don't have the data, show the placeholder image
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
                .background(Color.gray)
        } else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(Color.gray)
                .onAppear() {
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}


struct ContentView: View {
    // 10. Create an instance of the ViewModel
    // Annotated as StateObject so that it maintains it state across ContentView reloads
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // 12. Perform a loop of the courses array to then show
                // the content of the model
                ForEach(viewModel.courses, id: \.self) { course in
                    HStack {
                        URLImage(urlString: course.image)
                        Text(course.name)
                            .bold()
                    }
                    .padding(3)
                }
            }
            .navigationTitle("Courses")
            .onAppear {
                // 11. This gives us our array of courses
                viewModel.fetch()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
