package main

import (
)
import (
    "fmt"
    "os"
    "bufio"
    "strings"
    "sort"
    "strconv"
    "io"
    "bytes"
)


func Sqr(x float64) float64 {
    c:=0;

    x1:=x;
    x2 := float64(0);
    delta:=float64(1);

    for delta > 0.00001 {
        x2 = x1 - (x1*x1 - x)/(2*x1)
        delta = x1 - x2;
        x1 = x2;
        c+=1;
    }
    return x1;
}

func readFile(filename string) []string{
    file, err := os.Open(filename);

    if err != nil {
        panic(err);
    }

    defer file.Close()

    var lines []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }

    if err:= scanner.Err(); err !=nil {
        fmt.Fprintln(os.Stderr, err)
    }

    return lines;
}

func generateSortedCharMap(value string) PairList{
    result := make(map[string]int)

    for _, c := range(value){
        if _, ok := result[string(c)]; ok {
            result[string(c)]+=1;
        }else{
            result[string(c)] = 1;
        }
    }

    p := make(PairList, len(result))

    i := 0
    for k, v := range result {
        p[i] = Pair{k, v}
        i++
    }

    sort.Sort(sort.Reverse(p))

    return p;
}

// A data structure to hold key/value pairs
type Pair struct {
    Key   string
    Value int
}

// A slice of pairs that implements sort.Interface to sort by values
type PairList []Pair

func (p PairList) Len() int           { return len(p) }
func (p PairList) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
func (p PairList) Less(i, j int) bool {
    //if same use key to sort
    if(p[i].Value == p[j].Value){
        return p[i].Key > p[j].Key //manually reverse by testing of more than less
    }

    return p[i].Value < p[j].Value;
}

func validateCharMaps(list PairList, checksum string) bool{
    fullCharSum := "";

    for _, pair := range list {
        fullCharSum += pair.Key;
    }

    return fullCharSum[0:len(checksum)] == checksum;
}


type Room struct {
    Name string
    DecryptedName string
    Checksum string
    Sector int
    NameStats PairList
}

func decrypt(input string, rotation int) string {
    s := strings.NewReader(input)
    r := rot1Reader{s, rotation}

    buf := new(bytes.Buffer)
    buf.ReadFrom(&r)
    return buf.String()
}

func parseRoom(value string) Room{
    endOfName := strings.LastIndex(value, "-");
    startOfChecksum:= strings.LastIndex(value, "[");
    sector, _ := strconv.Atoi(value[endOfName+1:startOfChecksum])

    var room = Room{}
    room.Name = value[0:endOfName ]
    room.Sector = sector;
    room.Checksum = value[startOfChecksum + 1: len(value)-1]
    room.NameStats = generateSortedCharMap(strings.Replace(value[0:endOfName ], "-", "",11));

    room.DecryptedName = decrypt(room.Name, room.Sector);

    return room;
}

type rot1Reader struct {
    r io.Reader
    rotation int
}

func (rot *rot1Reader) Read(p []byte) (n int, err error){
    n,err = rot.r.Read(p)

    for i:=range(p[:n]) {
        if p[i] == '-' {
            p[i] = ' '
        }else {
            shiftedByte := (int(p[i]) + rot.rotation%26);
            if shiftedByte >= 122 {
                shiftedByte = shiftedByte%123 + 97
            }

            p[i]= byte(shiftedByte)
        }

    }

    return
}

func main() {

    inputs := []string{
        "qzmt-zixmtkozy-ivhz-343[abc]",
    }

    inputs = readFile("input.txt")
    sum := 0
    for _, value := range inputs {
        room := parseRoom(value);

        if validateCharMaps(room.NameStats, room.Checksum) {
            sum += room.Sector
        }else {
        }

        if(room.DecryptedName == "northpole object storage"){
            fmt.Println(room.DecryptedName, room.Sector)
        }

    }

    println("total sum is", sum);

    //println(Sqr(1115), math.Sqrt(1115));
    //println(runtime.GOOS)
    //parseToken("fubrjhqlf-edvnhw-dftxlvlwlrq-803[wjvzd]");
}