// console.log('mai2');

export function run(){
    window.onload=build;
}

var ctx;

function build(){
    var DIRECTION_TOP = 0;
    var DIRECTION_RIGHT = 1
    var DIRECTION_BOTTOM = 2;
    var DIRECTION_LEFT = 3;
    
    var TOKEN_DIRECTION_LEFT = 'L';
    var TOKEN_DIRECTION_RIGHT = 'R';
    
    var scale = 10;
    
    var grid = [];
    var instructions = "R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2";
    
    var tokens = instructions.split(', ');
    var commands = [];
    
    for(var i = 0, l = tokens.length; i<l;i++){
        var instruction = tokens[i];
        var direction = instruction.substring(0, 1);
        var distance = parseInt(instruction.substring(1));
        
        var command = {
            distance: distance,
            direction: direction
        }
        
        commands.push(command);
    }
    
    var canvas = document.createElement('canvas');
    document.body.appendChild(canvas);
    var context = ctx = canvas.getContext('2d');
    
    var Santa = function(){
        this.position = {x: 0, y:0};
        this.startPosition = {x: 0, y:0};
        this.globalRotation = 0.0;
        this.waypoints = [];
        
        this.intersections = [];
    }
    
    Santa.prototype.left = function(){
        this.globalRotation -= 90.0;
    }
    
    Santa.prototype.right = function(){
        this.globalRotation += 90.0;
    }
    
    Santa.prototype.intersectsPath = function(line2){
        
        for(var i = 1, l = this.waypoints.length; i<l; i++){
            var p1 = this.waypoints[i-1];
            var p2 = this.waypoints[i];
            
            var line1  = {start: p1, end: p2}
            
            var denominator = ((line2.end.y - line2.start.y) * (line1.end.x - line1.start.x)) - ((line2.end.x - line2.start.x) * (line1.end.y - line1.start.y));
            
            if(denominator !==0){ //parallel if zero
                var a = line1.start.y - line2.start.y;
                var b = line1.start.x - line2.start.x;
                var numerator1 = ((line2.end.x - line2.start.x) * a) - ((line2.end.y - line2.start.y) * b);
                var numerator2 = ((line1.end.x - line1.start.x) * a) - ((line1.end.y - line1.start.y) * b);
                a = numerator1 / denominator;
                b = numerator2 / denominator;
                
                // project lines into ininifty
                var x = line1.start.x + (a * (line1.end.x - line1.start.x));
                var y = line1.start.y + (a * (line1.end.y - line1.start.y));
                var intersectPoint =  { x: x, y: y };
                
                //only if on segment no somewhere on the infinite line
                if (a > 0 && a < 1 && b > 0 && b < 1) {
                    return intersectPoint;
                }
                
            }
            
        }
        
    }
    
    Santa.prototype.addWaypoint = function(position){
        this.waypoints.push(this.position);
    }
    
    Santa.prototype.forward = function(distance){
        var radiant = this.globalRotation/180.0 * Math.PI;
        
        var vector = {
            x: distance * Math.sin(radiant).toFixed(2),
            y: distance * Math.cos(radiant).toFixed(2)
        }
        
        var newPosition = {
            x:  this.position.x + vector.x,
            y:  this.position.y + vector.y * -1 //canvas works upside down
        }
        
        
        
        var line = {
            start: this.position,
            end: newPosition
        }
        
        var intersection = this.intersectsPath(line)
        if(intersection){
            this.intersections.push(intersection);
            console.log(intersection);
        }
        
        
        this.position = {x: newPosition.x, y: newPosition.y}
        this.addWaypoint(this.position);
    }
    
    Santa.prototype.getCurrentPosition = function(){
        return this.position;
    }
    
    Santa.prototype.run = function(commands){
        this.addWaypoint(this.startPosition)
        
        commands.forEach(function(command){
            if(command.direction == TOKEN_DIRECTION_RIGHT){
                this.right();
            }else {
                this.left();
            }
            
            this.forward(command.distance);
            
        }.bind(this))
    }
    
    
    function findRectangle(positions){
        var maxX = 0, maxY = 0, minX = 0, minY = 0;
        
        positions.forEach(function(position){
            maxX = Math.max((position.x), maxX);
            maxY = Math.max((position.y), maxY);
            minY = Math.min((position.y), minY);
            minX = Math.min((position.x), minX);
        });
        
        return {
            x: minX,
            y: minY,
            width: maxX-minX,
            height: maxY - minY
        }
    }
    
    function drawPositions(positions, scale){
        var scale = scale || 1;
        var lastPosition;
        
        positions.forEach(function(position){
            if(lastPosition){
                utils.drawArrow(lastPosition.x * scale, lastPosition.y * scale, position.x * scale, position.y * scale);
                utils.drawDot(position.x * scale, position.y * scale)
            }
            
            lastPosition = position;
            
        })
    }
    
    var utils = {
        calculateTaxiCabFromPoint: function(x ,y ){
            return Math.abs(x) + Math.abs(y);
        },
        
        drawDot: function(x, y, color, size){
            var size = size || 2;
            
            ctx.fillStyle = color || 'black';
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.arc(x, y, size, 0, 2 * Math.PI, true);
            
            ctx.fill();
        },
        
        
        drawArrow: function(x1, y1, x2, y2, color, strokeWidth){
            var angle = Math.atan2(y2 - y1, x2 - x1) + Math.PI/2;
            utils.drawTriangle(x2, y2, angle);
            utils.drawLine(x1, y1, x2, y2, color, strokeWidth);
        },
        
        
        drawTriangle: function(x, y, angle, color, size){
            var color = color || 'red';
            var size = size || 10;
            var angle = angle || 0;
            
            ctx.save();
            ctx.fillStyle = color;
            ctx.beginPath();
            
            //align end of arrow to the origin
            ctx.translate(x, y);
            ctx.rotate(angle);
            
            ctx.translate(0, size);
            
            ctx.moveTo(-size/2,0);
            ctx.lineTo(size/2,0);
            ctx.lineTo(0,-size/2);
            ctx.closePath();
            
            ctx.fill();
            
            ctx.restore();
        },
        
        drawLine: function(x1,y1, x2, y2, color, strokeWidth){
            var color = color || 'red';
            var strokeWidth = strokeWidth || 1;
            
            ctx.save();
            
            ctx.beginPath();
            ctx.strokeStyle = color;
            ctx.lineWidth = strokeWidth;
            
            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            
            ctx.stroke()
            ctx.restore();
            
        }
    }
    
    var padding = 20;
    var santa = new Santa();
    santa.run(commands)
    
    var totalSize = findRectangle(santa.waypoints);
    
    canvas.width  = (totalSize.width + padding) * scale;
    canvas.height = (totalSize.height + padding) * scale;
    
    
    ctx.save();
    ctx.translate(scale * (-totalSize.x + padding/2), scale * (-totalSize.y + padding/2));
    
    utils.drawDot(santa.startPosition.x * scale, santa.startPosition.y * scale, 'green', 10);
    drawPositions(santa.waypoints, scale);
    utils.drawDot(santa.position.x * scale, santa.position.y * scale, 'orange', 10);
    
    var destination = santa.getCurrentPosition();
    console.log('result is', utils.calculateTaxiCabFromPoint(destination.x, destination.y));
    
    for(var i = 0; i<santa.intersections.length;i++){
        var intersectPoint = santa.intersections[i]
        utils.drawDot(intersectPoint.x * scale, intersectPoint.y * scale, 'green');
    }
    
    if(santa.intersections.length > 0){
        var firstCollision = santa.intersections[0];
        console.log('first collision at', utils.calculateTaxiCabFromPoint(firstCollision.x, firstCollision.y));
    }else {
        console.log('no intersections found')
    }
    
    ctx.restore();
}

