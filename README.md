# Advent Notes
+ Day01 and Day02 are running with webpack (npm start)
+ Day03 with Swift (xcode playground, input is read from Resources/ (browse via xcode or show package content on osx))

## Day 01 (ES5)
This was fun. I first visualized the walking and was nearly 
able too visually identify the solutions of the base excercise AND the additional second start excercise. In the end I over engeneered it and calculated the intersection with more math than necessary in this grid based world.

Have a look (console + output):  
https://jsfiddle.net/5j9g0gLv/


## Day 02 (ES6)
Easier than Day 01. Beginning with rows & columns and a simple move check
was just the right decision for the second star variant.

Have a look (console):  
https://jsfiddle.net/72eenf3g/

## Day 03 (Swift)
Swift Time with xcode's swift playground. Reading again the language guide. I did it before and before.
Waiting to reach the point when I know how to make the input a collection of the tuples.

Screw you regex in swift. That's seems to be stupid complex in comparison to other languages. But well it works.
Jeez that playground is so slow. To process 1600 lines of a text file it takes more than 30 seconds. It's fixed by putting functions your are not 'playing' with in an external file in Sources/ so they are not analyzed during runtime by the playground. Now it runs well under 2 seconds.

## Day 04 (GO)
Yeah let's try go.

`brew install go` and some other worspace settings to use go tools.  
Hard parts were: Sorting  
Love the ubiquitous for-loop  

Tour of Go is working well for beginners with programming experience.  
https://tour.golang.org/welcome/1


Running example is here;  
https://play.golang.org/p/f2YkTqh5Hk