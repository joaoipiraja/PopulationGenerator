//
//  Model.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 27/05/23.
//

import Foundation

struct Person: Codable{
    var id: UUID = .init()
    var idade: Int
    var altura: Float
    var peso: Float
}

class ResponsePopulation: ProgressResponse, ObservableObject{
    @Published var current: Float
    @Published var total: Float
    
    required init(current: Float, total: Float) {
        self.current = current
        self.total = total
    }

}


class ResponseAverage: ProgressResponse, ObservableObject{
    @Published var current: Float
    @Published var total: Float
    
    required init(current: Float, total: Float) {
        self.current = current
        self.total = total
    }
}
