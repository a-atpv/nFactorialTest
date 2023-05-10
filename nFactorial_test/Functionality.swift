import Foundation
class Logic {
    var words = ["aldiyar", "aruzhan", "ermek", "zhalgas", "beibit", "nurlan" , "eltai"]
    var bigramsInDict = [String:Int]()
    var existedBigrams = Set<String>()
    var bigrams = [Bigram]()
    func readNames() {
        if let fileText = readTextFromFile(named: "File", withExtension: "rtf") {

            var a = fileText.components(separatedBy: "\n")
            for i in 1...9{
                a.removeFirst()
            }
            words = a
        }
    }
    
    func getBigrams() {
        for word in words{
            for i in 0...word.count {
                var a = ""
                if i == 0 {
                    a = "^" + String(word[i])
                }else if word[i+1] == "\\"{
                    a = String(word[i]) + "$"
                } else {
                    a = String(word[i]) + String(word[i+1])
                }
                addBigram(bigram: a)
                existedBigrams.insert(a)
                
                if word[i+1] == "\\" {
                    break
                }
            }
        }
    }
    
    func addBigram(bigram: String) {
        if !existedBigrams.contains(bigram) {
            bigramsInDict[bigram] = 1
        }else {
            bigramsInDict[bigram]! += 1
        }
    }
    
    func readTextFromFile(named fileName: String, withExtension fileExtension: String) -> String? {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
            do {
                let text = try String(contentsOfFile: filePath, encoding: .utf8)
                return text
            } catch {
                print("Error reading file: \(error)")
                return nil
            }
        } else {
            print("File not found.")
            return nil
        }
    }
    
    func translate(){
        for (i,j) in bigramsInDict {
            var a = Bigram(name: i, number: j)
            bigrams.append(a)
        }
    }
    
    func prepareData(){
        readNames()
        getBigrams()
        translate()
    }
    
}


