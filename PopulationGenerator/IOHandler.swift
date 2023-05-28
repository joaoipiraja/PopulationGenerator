//
//  IOHandler.swift
//  PopulationGenerator
//
//  Created by João Victor Ipirajá de Alencar on 27/05/23.
//

import Foundation


extension FileHandle{
    func read(tillFind character: Character) -> Data{
        var jsonData = Data()

        while true {
            let buffer = self.readData(ofLength: 1)
            guard !buffer.isEmpty else {
                break
            }
            let byte = buffer.first!
            if byte == character.asciiValue {
                break
            }
            jsonData.append(buffer)
        }
        return jsonData
    }
}



class IOOperation<T: Decodable>{
    
    var offsetsSaved: Array<UInt64>
    private let fileManager = FileManager.default
    private var fileHandle: FileHandle
    
    let url: URL
    
    
    init(){
        
        let tempDir = fileManager.temporaryDirectory
        let tempFileName = "populations.json"
        self.url = tempDir.appendingPathComponent(tempFileName)
        
        if fileManager.fileExists(atPath: url.path()) {
            do {
                try fileManager.removeItem(atPath: url.path())
                print("File deleted successfully.")
            } catch {
                print("Error deleting file: \(error)")
            }
        }

        fileManager.createFile(atPath: url.path(), contents: nil, attributes: nil)
        
        self.fileHandle = try! FileHandle(forUpdating: self.url)
        self.offsetsSaved = []
        
    }
    
    func open(){

        self.offsetsSaved = []


        if fileManager.fileExists(atPath: url.path()) {
            do {
                try fileManager.removeItem(atPath: url.path())
                print("File deleted successfully.")
            } catch {
                print("Error deleting file: \(error)")
            }
        }

        fileManager.createFile(atPath: url.path(), contents: nil, attributes: nil)

        self.fileHandle = try! FileHandle(forUpdating: self.url)

    }
    
    func read(at index: Int) -> T?{
        self.fileHandle.seek(toFileOffset: self.offsetsSaved[index])
        
        let jsonData = self.fileHandle.read(tillFind: "\n")
        
        
        var population: T? = nil
        do{
            population = try JSONDecoder().decode(T.self, from: jsonData)
            if population == nil {
                print("Error \(self.offsetsSaved[index])-> Empty")
            }
        }catch{
            print("Error \(self.offsetsSaved[index])->")
            print(String(data: jsonData, encoding: .isoLatin1)!)
        }

        return population
        
    }
    
    func save(data: any DataProtocol){
        offsetsSaved.append(self.fileHandle.offsetInFile)
        try! self.fileHandle.write(contentsOf: data)
    }
    
    func close(){
        try! self.fileHandle.close()
        self.offsetsSaved = []
    }
    
    
}
