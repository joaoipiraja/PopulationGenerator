//
//  ViewModel.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 24/05/23.
//

import Foundation
import SwiftUI


struct Person: Codable{
    var id: UUID = .init()
    var idade: Int
    var altura: Float
    var peso: Float
}


class ViewModel: ObservableObject{
    
    var model: Array<Person> = []
    @Published var averageAltura: Float = 0.0
    @Published var progress: Double = 0.0
    @Published var isResponseRunning: Bool = false
    
    private func generatePerson() -> Person{
        let idade = Int.random(in: 0...100)
        let altura = Float.random(in: 1.50...2.0)
        let peso = Float.random(in: 40.0...200.0)
        return .init(idade: idade, altura: altura, peso: peso)
    }
    
    func generatePopulation(ofSize size: Int){
        
        isResponseRunning = false
        progress = 0.0
        
        self.model = (0...size).map {_ in
            return generatePerson()
        }
        isResponseRunning = true
        progress = 100.0
        averageAltura = self.model.reduce(Float(0.0), { partialResult, person in
            return partialResult + person.altura
        }) / Float(self.model.count)
    }
    
    
}
