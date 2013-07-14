var makeWorld = function(width, height) {
    var world = {};
    world.width = width;
    world.height = height;
    return world;
};

var makePoint = function(x, y) {
    var point = {};
    point.x = x;
    point.y = y;
    return point;
};

var SNAKE_LEFT = 0;
var SNAKE_RIGHT= 1;
var SNAKE_UP = 2;
var SNAKE_DOWN = 3;

var makeSnake = function(world) {
    var snake = {};
    snake.world = world;
    snake.body = [];
    var head = makePoint(Math.floor(world.width/2), Math.floor(world.height/2));
    snake.body[0] = head;
    snake.body[1] = makePoint(head.x + 1, head.y);
    snake.direction = SNAKE_LEFT;
    snake.directionLocked = false;
    snake.move = function() {
        var head = snake.body[0];
        var x = head.x;
        var y = head.y;
        if (snake.direction == SNAKE_LEFT) {
            if (--x < 0) x = snake.world.width - 1;
        }
        else if (snake.direction == SNAKE_RIGHT) {
            if (++x >= snake.world.width) x = 0;
        }
        else if (snake.direction == SNAKE_UP) {
            if (--y < 0) y = snake.world.height - 1;
        }
        else if (snake.direction == SNAKE_DOWN) {
            if (++y >= snake.world.height) y = 0;
        }
        snake.body.pop();
        snake.body = [makePoint(x, y)].concat(snake.body);
    };
    snake.changeDirection = function (newDirection) {
        if (snake.directionLocked) {
            return false;
        }
        if (snake.direction == SNAKE_UP || snake.direction == SNAKE_DOWN) {
            if (newDirection == SNAKE_LEFT || newDirection == SNAKE_RIGHT) {
                snake.direction = newDirection;
                return true;
            }
        }
        else if (snake.direction == SNAKE_LEFT || snake.direction == SNAKE_RIGHT) {
            if (newDirection == SNAKE_UP || newDirection == SNAKE_DOWN) {
                snake.direction = newDirection;
                return true;
            }
        }
        return false;
    }
    snake.enlarge = function (length) {
        var lastPoint = snake.body[snake.body.length - 1];
        var theOnBeforeLastPoint = snake.body[snake.body.length - 2];
        var x = lastPoint.x - theOnBeforeLastPoint.x;
        var y = lastPoint.y - theOnBeforeLastPoint.y;
        for (var i = 0; i < length; i++) {
            snake.body.push(makePoint((lastPoint.x + x*i) % snake.world.width, (lastPoint.y + y*i) % snake.world.height));
        }
    }
    snake.isHeadHitBody = function () {
        var head = snake.body[0];
        for (var i = 1; i < snake.body.length; i++) {
            var point = snake.body[i];
            if (point.x == head.x && point.y == head.y) {
                return true;
            }
        }
        return false;
    }
    return snake;
};

var makeFruit = function (snake, world) {
    Log("makeFruit");
    var x = 0;
    var y = 0;
    while (true) {
        x = Math.floor(Math.random() * world.width);
        y = Math.floor(Math.random() * world.height);
        var inBody = false;
        for (var i = 0; i < snake.body.length; i++) {
            var point = snake.body[i];
            if (point.x == x && point.y == y) {
                inBody = true;
                break;
            }
        }
        if (!inBody) break;
    }
    return makePoint(x, y);
}

var world = null;
var snake = null;
var fruit = null;
var timer = null;
var gameStart = false;

var setup = function() {
};

var startGame = function () {
    world = makeWorld(20, 20);
    snake = makeSnake(world);
    fruit = makeFruit(snake, world);
    gameStart = true;
};

var endGame = function () {
    gameStart = false;
};

var onDraw = function() {
    if (!gameStart) {
        SetFontName("HelveticaNeue-UltraLight");
        SetFontSize(48);
        TextBox("Tap to play!", 20, 20, 260, 200);
        return;
    }
    var worldWidth = 320;
    var worldHeitgh = 320;
    var w = worldWidth / world.width;
    var h = worldHeitgh / world.height;
    for (var i = 0; i <= world.width; i++) {
        Line(i * w, 0, i * w, worldHeitgh);
    }
    for (var i = 0; i <= world.height; i++) {
        Line(0, i * h, worldWidth, i * h);
    }
    for (var i = 0; i < snake.body.length; i++) {
        var point = snake.body[i];
        FillRect(point.x*w, point.y*h, w, h);
    }
    SetFillColor(255, 0, 0, 255);
    FillRect(fruit.x*w, fruit.y*h, w, h);

    snake.move();
    snake.directionLocked = false;
    var head = snake.body[0];
    if (head.x == fruit.x && head.y == fruit.y) {
        snake.enlarge(2);
        fruit = makeFruit(snake, world);
    }
    if (snake.isHeadHitBody()) {
        endGame();
    }
};

var _changeDirection  = function (newDirection) {
    if (snake.directionLocked) {
        return;
    }
    if (snake.changeDirection(newDirection)) {
        snake.directionLocked = true;
    }
};

var onTap = function () {
    if (!gameStart) {
        startGame();
    }
};

var onSwipeLeft = function () {
    _changeDirection(SNAKE_LEFT);
};

var onSwipeRight = function () {
    _changeDirection(SNAKE_RIGHT);
};

var onSwipeUp = function () {
    _changeDirection(SNAKE_UP);
};

var onSwipeDown = function () {
    _changeDirection(SNAKE_DOWN);
};
