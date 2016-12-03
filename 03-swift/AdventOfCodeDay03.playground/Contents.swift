//: Playground - noun: a place where people can play

import Cocoa;


let inputTuples = readTextFile(filename: "input");
var totalTriangles = 0;

// for second example transpose the tuple skip overhead at the end
let inputTuplesTransposed = transposeTuples(tuples: inputTuples);


// replace inputTuplesTransposed with inputTuples to calculate part 1
for (a, b, c) in inputTuplesTransposed {
    let isTriangle = (b + c) > a && (a + c) > b && (a + b) > c;
    print("Analyzing \(a)-\(b)-\(c) with result \(isTriangle)");
    if isTriangle {
        totalTriangles+=1 ;
    }
}

print("Found a total of \(totalTriangles) valid triangles");
