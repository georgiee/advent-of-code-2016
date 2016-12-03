import Foundation

public typealias Triangle = Array<(Int, Int, Int)>;

public func transposeTuples(tuples: Triangle) -> Triangle{
    var i = 0;
    var result: Triangle = [];
    
    let totalGroupCount = (tuples.count - tuples.count%3); //ensure complete groups of 3, drop rest
    print("processing \(totalGroupCount) \(tuples.count )");
    
    repeat {
        
        let tupleGroup = [tuples[i], tuples[i+1], tuples[i+2]];
        
        let tuple1 = (tupleGroup[0].0, tupleGroup[1].0, tupleGroup[2].0);
        result.append(tuple1);
        
        let tuple2 = (tupleGroup[0].1, tupleGroup[1].1, tupleGroup[2].1)
        result.append(tuple2);
        
        let tuple3 = (tupleGroup[0].2, tupleGroup[1].2, tupleGroup[2].2)
        result.append(tuple3);
        
        i += 3
    } while i < totalGroupCount;
    
    return result;
}

public func readTextFile(filename: String) -> Array<(Int, Int, Int)> {
    var result: Array<(Int, Int, Int)> = [];
    let path = Bundle.main.path(forResource: filename, ofType: "txt")!;
    
    let data = try? String(contentsOfFile: path);
    if(data != nil){
        let dataRows = (data ?? "" ).components(separatedBy: "\n");
        
        for row:String in dataRows{
            
            let values = extractNumbers(regex: "[0-9]+", text: row)
                .map { Int($0)! }
                //.sorted();
            
            let tuple = (a: values[0], b: values[1], c:values[2] );
            
            result.append(tuple);
        }
    }
    
    return result;
}

func extractNumbers(regex: String, text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let nsString = text as NSString
        let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}
