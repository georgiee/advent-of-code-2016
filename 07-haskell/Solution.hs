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


countValidTLS xs = do {
    --map isValidTLS xs
    countTrues $ map isValidTLS xs
}

extractHypernet :: IP -> Maybe String
extractHypernet (Hypernet a) = Just a
extractHypernet _ = Nothing

isHypernet (Hypernet _) = True
isHypernet _         = False

isAddress (Address _) = True
isAddress _         = False

getHypernet = filter isHypernet
getAddresses = filter isAddress

main  = do
    --let xxx = [Address "xx", Hypernet "dnwtsgyabbaawerfamfv", Address "acccdabdbasdsd"] 
    --print( isValidTLS xxx )
    --print(extractHypernet(Hypernet "dnwtsgyawerfamfv"))
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
    
