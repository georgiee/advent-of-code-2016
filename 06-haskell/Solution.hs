module Main where

import Data.List.Split
import Data.Map
import Data.Ord
import Data.List

testinput = "eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar"
charFrequency input = toList $ fromListWith (+) [(c, 1) | c <- input]

highest freq = fst $ maximumBy (comparing snd) freq
lowest freq = fst $ minimumBy (comparing snd) freq

findHighest list = highest $ charFrequency list
findLowest list = lowest $ charFrequency list

main  = do
    input <- readFile "input.txt"
    let tokens =  transpose $ lines input
    let first = head tokens
    
    print(Prelude.map findLowest tokens)