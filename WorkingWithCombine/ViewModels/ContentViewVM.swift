//
//  ContentViewVM.swift
//  WorkingWithCombine
//
//  Created by Kinney Kare on 2/25/21.
//

import Combine
import SwiftUI

class ContentViewVM: ObservableObject {
    @Published var time = ""
    @Published var users = [User]()
    
    //private var anyCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    //we need a time formatter
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .medium
        return df
    }()
    
    init() {
        setupPublishers()
    }
    
    private func setupPublishers() {
        setupTimerPublisher()
        setupDataTaskPublisher()
    }
    
    private func setupDataTaskPublisher() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        //To access the data task publisher look at the next line of code.
        URLSession.shared.dataTaskPublisher(for: url)
            //since we can fail trying to get this url we need to "tryMap"
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                //we are returning data which will be of type JSON so we need to create a JSON formattor model.
                return data
            }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { users in
                self.users = users
            }
            .store(in: &cancellables)
    }
    
    private func setupTimerPublisher() {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { value in
                self.time = self.formatter.string(from: value)
            }
            .store(in: &cancellables)
    }
    
}
