const testinput = "rect 3x2\nrotate column x=1 by 1"
const WIDTH = 50;
const HEIGHT = 6;

export function run(){
    window.onload = function(){
        const commands = parse(input)
        
        const renderer = new DisplayRenderer(WIDTH, HEIGHT);  
        document.body.appendChild(renderer.canvas);
        
        
        const display = new Display(WIDTH, HEIGHT)
        display.process(commands)

        renderer.render(display);
        console.log(display.countLights());
    }
}



class Display {
    constructor(width, height){
        this.data = [];
        this.displayWidth = width;
        this.displayHeight = height;

        this.init();
        this.offsetColumn(0, 0)
    }
    
    init(){
        var l = this.displayWidth * this.displayHeight;
        while(l--){
            this.data[l] = 0
        }

    }
    
    process(commands){
        commands.forEach(command => this.processCommand(command));
    }
    
    lightsOn(width, height){

        for(let x = 0; x < width; x++){
            for(let y = 0; y < height; y++){
                this.data[y * this.displayWidth + x] = 1;
            }    
        }
    }
    
    countLights(){
        var counter = 0;
        var width = this.displayWidth, height = this.displayheight;

        
        var l = this.displayWidth * this.displayHeight;
        while(l--){
           counter += this.data[l] == true ? 1 : 0;
        }

        

        return counter;
    }

    offsetRow(row, offset){
        let newData = this.data.concat([]);
        let datasize = this.data.length;

        for(var column = 0; column < this.displayWidth; column++){
            newData[row * this.displayWidth + (column + offset)%this.displayWidth] = this.data[row * this.displayWidth + column]
        }
        

        this.data = newData;
    }

    offsetColumn(column, offset){
        let newData = this.data.concat([]);
        let datasize = this.data.length;

        for(var row = 0; row < this.displayHeight; row++){
            let oldIndex = row*this.displayWidth+ column
            let newIndex = (row + offset)%this.displayHeight * this.displayWidth + column;
            newData[newIndex] = this.data[oldIndex]
            
        }
        

        this.data = newData;
    }
    

    processCommand(command){

        if(command.instruction == 'rect'){
            this.lightsOn(command.width, command.height);
        }

        if(command.instruction == 'rotate'){
            if(command.target == 'column'){
                this.offsetColumn(command.origin, command.offset)
            }

            if(command.target == 'row'){
                this.offsetRow(command.origin, command.offset)
            }
        }
    }
}

function parse(input){
    const tokens = input.split('\n');
    const commands = tokens.map(function(token){
        return parseToken(token)
    })

    return commands;
}

function parseToken(token){
    let command = token.split(" ");
    let instruction = command[0]

    if(instruction == 'rect'){
        let size = command[1].split('x')
        return { instruction, width: parseInt(size[0]), height: parseInt(size[1]) }
    }
    
    if(instruction == 'rotate'){
        let target = command[1]
        let dataProperty = command[2].split('=')
        let offset = parseInt(command[4])
        let property = {name:dataProperty[0], value: parseInt(dataProperty[1]) }
        let translation = [0,0];

        let origin = property.value
        

        return { instruction, target, origin, offset }
    }
}



class DisplayRenderer{
    constructor(width, height){
        let canvas = document.createElement('canvas');
        canvas.id = 'day06';
        canvas.width  = width;
        canvas.height = height;
        
        this.width = width;
        this.height = height;

        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
    }
    

    render(display){
        let {ctx} = this;

        ctx.beginPath();
        ctx.rect(0, 0, 10, 10);
        ctx.fillStyle = "red";
        ctx.fill();

        var imagedata = this.ctx.createImageData(this.width, this.height);
        
        for (var i=0;i < imagedata.data.length;i+=4){
          imagedata.data[i+0] = 255 * display.data[i/4];
          imagedata.data[i+3] = 255;
        }
        
        ctx.putImageData(imagedata,0,0);

    }

    drawPixel(x,y){
        
        var pixel  = data.data;
        pixel[0]   = 0;
        pixel[1]   = 255;
        pixel[2]   = 255;
        pixel[3]   = 255;
        this.ctx.putImageData( data, x, y ); 
    }
}



const input = `rect 1x1
rotate row y=0 by 5
rect 1x1
rotate row y=0 by 5
rect 1x1
rotate row y=0 by 3
rect 1x1
rotate row y=0 by 2
rect 1x1
rotate row y=0 by 3
rect 1x1
rotate row y=0 by 2
rect 1x1
rotate row y=0 by 5
rect 1x1
rotate row y=0 by 5
rect 1x1
rotate row y=0 by 3
rect 1x1
rotate row y=0 by 2
rect 1x1
rotate row y=0 by 3
rect 2x1
rotate row y=0 by 2
rect 1x2
rotate row y=1 by 5
rotate row y=0 by 3
rect 1x2
rotate column x=30 by 1
rotate column x=25 by 1
rotate column x=10 by 1
rotate row y=1 by 5
rotate row y=0 by 2
rect 1x2
rotate row y=0 by 5
rotate column x=0 by 1
rect 4x1
rotate row y=2 by 18
rotate row y=0 by 5
rotate column x=0 by 1
rect 3x1
rotate row y=2 by 12
rotate row y=0 by 5
rotate column x=0 by 1
rect 4x1
rotate column x=20 by 1
rotate row y=2 by 5
rotate row y=0 by 5
rotate column x=0 by 1
rect 4x1
rotate row y=2 by 15
rotate row y=0 by 15
rotate column x=10 by 1
rotate column x=5 by 1
rotate column x=0 by 1
rect 14x1
rotate column x=37 by 1
rotate column x=23 by 1
rotate column x=7 by 2
rotate row y=3 by 20
rotate row y=0 by 5
rotate column x=0 by 1
rect 4x1
rotate row y=3 by 5
rotate row y=2 by 2
rotate row y=1 by 4
rotate row y=0 by 4
rect 1x4
rotate column x=35 by 3
rotate column x=18 by 3
rotate column x=13 by 3
rotate row y=3 by 5
rotate row y=2 by 3
rotate row y=1 by 1
rotate row y=0 by 1
rect 1x5
rotate row y=4 by 20
rotate row y=3 by 10
rotate row y=2 by 13
rotate row y=0 by 10
rotate column x=5 by 1
rotate column x=3 by 3
rotate column x=2 by 1
rotate column x=1 by 1
rotate column x=0 by 1
rect 9x1
rotate row y=4 by 10
rotate row y=3 by 10
rotate row y=1 by 10
rotate row y=0 by 10
rotate column x=7 by 2
rotate column x=5 by 1
rotate column x=2 by 1
rotate column x=1 by 1
rotate column x=0 by 1
rect 9x1
rotate row y=4 by 20
rotate row y=3 by 12
rotate row y=1 by 15
rotate row y=0 by 10
rotate column x=8 by 2
rotate column x=7 by 1
rotate column x=6 by 2
rotate column x=5 by 1
rotate column x=3 by 1
rotate column x=2 by 1
rotate column x=1 by 1
rotate column x=0 by 1
rect 9x1
rotate column x=46 by 2
rotate column x=43 by 2
rotate column x=24 by 2
rotate column x=14 by 3
rotate row y=5 by 15
rotate row y=4 by 10
rotate row y=3 by 3
rotate row y=2 by 37
rotate row y=1 by 10
rotate row y=0 by 5
rotate column x=0 by 3
rect 3x3
rotate row y=5 by 15
rotate row y=3 by 10
rotate row y=2 by 10
rotate row y=0 by 10
rotate column x=7 by 3
rotate column x=6 by 3
rotate column x=5 by 1
rotate column x=3 by 1
rotate column x=2 by 1
rotate column x=1 by 1
rotate column x=0 by 1
rect 9x1
rotate column x=19 by 1
rotate column x=10 by 3
rotate column x=5 by 4
rotate row y=5 by 5
rotate row y=4 by 5
rotate row y=3 by 40
rotate row y=2 by 35
rotate row y=1 by 15
rotate row y=0 by 30
rotate column x=48 by 4
rotate column x=47 by 3
rotate column x=46 by 3
rotate column x=45 by 1
rotate column x=43 by 1
rotate column x=42 by 5
rotate column x=41 by 5
rotate column x=40 by 1
rotate column x=33 by 2
rotate column x=32 by 3
rotate column x=31 by 2
rotate column x=28 by 1
rotate column x=27 by 5
rotate column x=26 by 5
rotate column x=25 by 1
rotate column x=23 by 5
rotate column x=22 by 5
rotate column x=21 by 5
rotate column x=18 by 5
rotate column x=17 by 5
rotate column x=16 by 5
rotate column x=13 by 5
rotate column x=12 by 5
rotate column x=11 by 5
rotate column x=3 by 1
rotate column x=2 by 5
rotate column x=1 by 5
rotate column x=0 by 1`