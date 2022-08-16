//
//  ViewModel.swift
//  SwiftUIAPICall
//
//  Created by Caroline LaDouce on 8/16/22.
//

import Foundation
import SwiftUI

// 3.
// Create a model that matches the courses in JSON response
// Make the course object Hashable so that we can
// do a for-loop over it in the content view
// Make it Codable so that the struct can be used as a mapping from the JSON response

// 4.
// It's important to add the properties in the JSON response to the course object
// The JSON contains an array with objects contained in curly braces
// Each of the objects in curly braces have a "name" and "image" property
// and each of the properties are of type string
// Property names must be spelled correctly AND are case sensitive
// An error in creating this model will result in an error when trying to convert the data from the API call to an object

struct Course: Hashable, Codable {
    let name: String
    let image: String
}


class ViewModel: ObservableObject {
    // 7. Introduce a published property on the ViewModel object called "courses"
    // Every time the courses array is updated, the view will be instructed to update itself
    @Published var courses: [Course] = []
    
    func fetch() {
        // 1. Create URL object
        guard let url = URL(string: "https://iosacademy.io/api/v1/courses/index.php") else {
            return
        }
        
        // 2. Perform API Call
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            
            // 5. Convert to JSON --> convert the data into an object
            do {
                // 6. This line means:
                // "Try to use JSONDecoder to decode an array of course objects from the data"
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                // 8.
                // Update published properties on the main queue because it triggers a UI update and UI updates should be performed on the main queue
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            }
            catch {
                print(error)
            }
        }
        
        // 9. task.resume() "kicks off" the API call
        task.resume()
    }
    
}
