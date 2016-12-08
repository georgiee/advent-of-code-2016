-- http://book.realworldhaskell.org/read/using-parsec.html
-- http://adventofcode.com/2016/day/7/input
-- http://stackoverflow.com/questions/10168756/parsing-a-string-in-haskell
-- https://www.haskell.org/hoogle/?hoogle=%5BBool%5D+-%3E+Bool

-- :m + Data.List
module Main where
import Debug.Trace

--import qualified Prelude as P
--import Text.Regex.Posix
import Data.List

import Text.ParserCombinators.Parsec

testinput = "abba[mnop]qrst\n"
testinput2 = "aba[bab]xyz\n"
--result = testinput =~ "[(a-z)]" :: String

--csvFile = endBy line eol
--line = sepBy cell (char ',')
--cell = many (noneOf ",\n")
--eol = char '\n'

--parseCodes :: P.String -> P.Either ParseError [[P.String]]
--parseCodes input = parse csvFile "(unknown)" input

--eol2 :: Parser P.String
--eol2 = string "\n" <|> string "\n\r"

data IP = Address String | Hypernet String deriving (Eq, Ord)

-- or use deriving: Show 
instance Show IP where  
    show (Address s) = "Address " ++ s
    show (Hypernet s) = "Hypernet " ++ s

content :: GenParser Char st [[IP]]
content = line `endBy` newline
--content = 

line = many (address <|> hypernet)

address = Address <$> many1 (noneOf "[\n") 
hypernet = Hypernet <$> (string "[" *> many (noneOf "]") <* string "]") 

parseS :: String -> Either ParseError [[IP]]
parseS input = parse content "" input



acceptance1 value = (reverse value) == value
acceptance2 value = length(group value) == 3
abbatest value = acceptance1 value && acceptance2 value

parselist = case (parse content "" testinput) of
    Left err  -> print err
    Right xs  -> print (xs)

windowed :: Int -> [a] -> [[a]]
windowed size [] = []
windowed size ls@(x:xs) = if length ls >= size then (take size ls) : windowed size xs else windowed size xs 



-- Put simply, . is function composition, just like in math:
-- f (g x) = (f . g) x
--https://wiki.haskell.org/Pointfree

countTrues = length . filter (== True)
isValidTLS ip = do {
    let validAdresspart = or [ testAddressPart a| a <- getAddresses(ip)]
    ;let validHypernet = [ testAddressPart a| a <- getHypernet(ip)]
    ;and $ validAdresspart : validHypernet

    --[(part, testAddressPart(part)) | part <- ip]
}

testAddressPart :: IP -> Bool
testAddressPart (Address s) = containsAbba(s)
testAddressPart (Hypernet s) = not $ containsAbba(s)

containsAbba s = or $ map abbatest (windowed 4 s)
containsAba s = or $ map abbatest (windowed 3 s)


countValidTLS xs = do {
    --map isValidTLS xs
    countTrues $ map testABA xs
}

isHypernet (Hypernet _) = True
isHypernet _         = False

isAddress (Address _) = True
isAddress _         = False

getHypernet = filter isHypernet
getAddresses = filter isAddress

test2 v = v
testt = findAbas(Address("zazbz"))


testABA ip = do {
    let addresses = concat [findAbas a | a <- getAddresses(ip)]
    ;let addressesAlternated = map alternateBab addresses
    ;let hypernetAbas = concat [findAbas a | a <- getHypernet(ip)]
    ;not $ null (intersect addressesAlternated hypernetAbas)
}

alternateBab value = (value !! 1) : (value !! 0) : (value !! 1) : []

findAbas :: IP -> [String]
findAbas (Address s) = [x|x <- (windowed 3 s), abbatest x ]
findAbas (Hypernet s) = [x|x <- (windowed 3 s), abbatest x ]

main  = do
    --let xxx = [Address "xx", Hypernet "dnwtsgyabbaawerfamfv", Address "acccdabdbasdsd"] 
    --let xxx = [Address "zazdbz", Hypernet "bzb", Address "cdb"] 
    --print( isValidTLS xxx )
    --print(extractHypernet(Hypernet "dnwtsgyawerfamfv"))
    --print(testABA xxx)
    input <- readFile "input.txt"
    let result = parseS input
    case result of
        Left err  -> print err
        Right xs  -> print (countValidTLS(xs))
    --let r <- parseS testinput
    --print r
    -- print([ (abbatest x, x) | x <- permutations("abba")])
    -- print(map abbatest (permutations "abba"))
    -- print((permutations "abba"))
    -- let eol = string "\n" <|> string "\n\r" :: GenParser P.Char st P.String
    -- P.print(parse eol2 "" "\n\r")
    
