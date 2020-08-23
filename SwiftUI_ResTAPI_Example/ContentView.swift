//
//  ContentView.swift
//  SwiftUI_ResTAPI_Example
//
//  Created by wisdom nwokocha on 23/08/2020.
//  Copyright © 2020 wisdom nwokocha. All rights reserved.
//

import SwiftUI

let todosEndpoint = "https://jsonplaceholder.typicode.com/todos/"

// JSON returned by "https://jsonplaceholder.typicode.com/todos/":
//    [
//        {
//            "userId": 1,
//            "id": 1,
//            "title": "delectus aut autem",
//            "completed": false
//        },
//        {
//            "userId": 1,
//            "id": 2,
//            "title": "quis ut nam facilis et officia qui",
//            "completed": false
//        },
//        ...
//    ]

struct Todo: Codable, Identifiable {
    let userId, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: CodingKey {
        case userId, id, title, completed
    }
}

typealias Todos = [Todo]

class TodoDownloader: ObservableObject {
    @Published var todos: Todos = [Todo]()

    init() {
        guard let url = URL(string: todosEndpoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let data = data else { return }
                let todos = try JSONDecoder().decode(Todos.self, from: data)
                DispatchQueue.main.async {
                    self.todos = todos
                }
            } catch {
                print("Error decoding JSON: ", error)
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var todoData: TodoDownloader = TodoDownloader()

    var body: some View {
        NavigationView {
            List(self.todoData.todos) { todo in
                Text(todo.title)
            }
        .navigationBarTitle(Text("Rest Api List"))
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
