//
//  ContentView.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 24/05/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    
 
    @ObservedObject var viewModel: ViewModel = .init()
    @ObservedObject var responsePop: ResponsePopulation = .init(current: 0, total: 0)
    @State var isFinishedPop: Bool = false
    @State private var cancellables:Set<AnyCancellable> = .init()
    
    func createOtherSink(){
        isFinishedPop = false
        self.viewModel.pop.subjectPop =  .init()

        self.viewModel.pop.subjectPop
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                    case .finished:
                        self.isFinishedPop = true
                        break
                }
            } receiveValue: { response in
                self.responsePop.current = response.current
                self.responsePop.total = response.total
            }.store(in: &self.cancellables)

    }
    
    
    var body: some View {
        VStack {
            List{
                HStack{
                    Text("Media de Alturas")
                    Spacer()
                    Text("\(viewModel.averageAltura)")
                }
               
            }
            if(!isFinishedPop){
                
                
                ProgressView("Barra de progresso - \(String(format: "%.1f", self.responsePop.current))/ \(String(format: "%.1f", self.responsePop.total))", value: self.responsePop.current, total: self.responsePop.total).padding()
            }
           
            Button("Rodar") {
                createOtherSink()
                Task{
                    await self.viewModel.run()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
