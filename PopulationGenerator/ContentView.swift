//
//  ContentView.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 24/05/23.
//

import SwiftUI

struct ContentView: View {
    
 
    @ObservedObject var viewModel: ViewModel = .init()
    
    var body: some View {
        VStack {
            List{
                HStack{
                    Text("Media de Alturas")
                    Spacer()
                    Text("\(viewModel.averageAltura)")
                }
               
            }
            ProgressView("Barra de progresso", value: viewModel.progress, total: 100.00).padding()
            Button("Rodar") {
                viewModel.generatePopulation(ofSize: 100000000)
            }.disabled(viewModel.isResponseRunning)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
