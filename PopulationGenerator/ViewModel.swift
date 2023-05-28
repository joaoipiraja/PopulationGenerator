//
//  ViewModel.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 24/05/23.
//

import Foundation
import SwiftUI
import Combine



class PopulationGenerator: ObservableObject{
    var ioOperaation: IOOperation<Array<Person>> = .init()
    var subjectPop: PassthroughSubject<ResponsePopulation, Never> = .init()
    let division = Division<Person, ResponsePopulation>()
    
    private func generatePerson() -> Person{
        let idade = Int.random(in: 0...100)
        let altura = Float.random(in: 1.50...2.0)
        let peso = Float.random(in: 40.0...200.0)
        return .init(idade: idade, altura: altura, peso: peso)
    }
    
    
    func generatePopulation(ofSize size: Int) async{
        
        let separator: Character = "\n"

        await self.division.bigToBatches(size: size, content: {
            return self.generatePerson()
        }, completion: { persons, respPop in
            let data = try! JSONEncoder().encode(persons) + String(separator).data(using: .utf8)!
            self.ioOperaation.save(data: data)
            self.subjectPop.send(respPop)
        })
        subjectPop.send(completion: .finished)
        
    }
    
    
}


class ViewModel: ObservableObject{
    
    var pop: PopulationGenerator = .init()
    @Published var averageAltura: Float = 0.0
    let size = 100000000000
    
    func run() async{
        await self.pop.generatePopulation(ofSize: size)
    }
    
    
}
