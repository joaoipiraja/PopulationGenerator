//
//  BigToBatches.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 27/05/23.
//

import Foundation


protocol ProgressResponse {
    var current: Float {get set}
    var total: Float {get set}
    init(current: Float, total: Float)
}


class Division <I, R: ProgressResponse>{
    func bigToBatches(size: Int, content: @escaping () -> I, completion: @escaping (Array<I>, R) -> ()) async{
        let batchSize = 1000
        let numBatches = Int(size/batchSize)
        
        for batchIndex in 0..<numBatches{
            let batchStartIndex = batchIndex * batchSize
            let batchEndIndex = min((batchIndex + 1) * batchSize, size)
            let batchCount = batchEndIndex - batchStartIndex
            
            await withTaskGroup(of: I.self, body: { group -> () in
                for _ in 0..<batchCount{
                    group.addTask {
                        content()
                    }
                }
                
                var results: Array<I> = .init()
                
                for await r in group{
                    results.append(r)
                }
                
                completion(results, .init(current: Float(batchIndex + 1) * Float(batchSize), total: Float(size)))
            })
        }
    }
}
