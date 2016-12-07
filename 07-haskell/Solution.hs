-- http://book.realworldhaskell.org/read/using-parsec.html
-- http://adventofcode.com/2016/day/7/input
-- http://stackoverflow.com/questions/10168756/parsing-a-string-in-haskell
-- :m + Data.List
module Main where

--import qualified Prelude as P
--import Text.Regex.Posix
import Data.List

import Text.ParserCombinators.Parsec

testinput = "dnwtsgywerfamfv[gwrhdujbiowtcirq]bjbhmuxdcasenlctwgh\ndnwtsgywerfamfv[gwrhdujbiowtcirq]bjbhmuxdcasenlctwgh\n"
--result = testinput =~ "[(a-z)]" :: String

--csvFile = endBy line eol
--line = sepBy cell (char ',')
--cell = many (noneOf ",\n")
--eol = char '\n'

--parseCodes :: P.String -> P.Either ParseError [[P.String]]
--parseCodes input = parse csvFile "(unknown)" input

--eol2 :: Parser P.String
--eol2 = string "\n" <|> string "\n\r"

data IP = Address String | Hypernet String deriving Show


content :: GenParser Char st [[IP]]
content = endBy line eol
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

eol = char '\n'

main  = do
    let result = parseS testinput
    case result of
        Left err  -> print err
        Right xs  -> print (windowed 4 "dnwtsgywerfamfv")
    --let r <- parseS testinput
    --print r
    -- print([ (abbatest x, x) | x <- permutations("abba")])
    -- print(map abbatest (permutations "abba"))
    -- print((permutations "abba"))
    -- let eol = string "\n" <|> string "\n\r" :: GenParser P.Char st P.String
    -- P.print(parse eol2 "" "\n\r")
    
