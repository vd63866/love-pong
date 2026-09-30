
-- ========================================
-- LUA PONG v2
-- ========================================

local WIDTH = 800
local HEIGHT = 600

local WIN_SCORE = 5

local gameState = "menu"

local player
local enemy
local ball

local playerScore = 0
local enemyScore = 0

local countdown = 0
local countdownValue = 3

local font
local bigFont


-- ========================================
-- GAME SETUP
-- ========================================

function love.load()

    math.randomseed(os.time())

    love.window.setMode(WIDTH, HEIGHT)
    love.window.setTitle("Lua Pong")

    font = love.graphics.newFont(24)
    bigFont = love.graphics.newFont(60)

    resetGame()

end


function resetGame()

    player = {
        x = 30,
        y = HEIGHT / 2 - 50,
        width = 20,
        height = 100,
        speed = 450
    }

    enemy = {
        x = WIDTH - 50,
        y = HEIGHT / 2 - 50,
        width = 20,
        height = 100,
        speed = 330
    }

    playerScore = 0
    enemyScore = 0

    resetBall(math.random(0, 1) == 0 and -1 or 1)

    countdown = 3
    countdownValue = 3

    gameState = "countdown"

end


-- ========================================
-- BALL RESET
-- ========================================

function resetBall(direction)

    local angle = math.rad(math.random(-35, 35))

    local speed = 350

    ball = {
        x = WIDTH / 2 - 10,
        y = HEIGHT / 2 - 10,
        size = 20,
        speed = speed,
        speedX = math.cos(angle) * speed * direction,
        speedY = math.sin(angle) * speed,
        maxSpeed = 900
    }

end


-- ========================================
-- COLLISION
-- ========================================

function checkCollision(ballObject, paddle)

    return ballObject.x < paddle.x + paddle.width
        and ballObject.x + ballObject.size > paddle.x
        and ballObject.y < paddle.y + paddle.height
        and ballObject.y + ballObject.size > paddle.y

end


-- ========================================
-- PADDLE COLLISION
-- ========================================

function bounceFromPaddle(paddle, direction)

    -- Find the center of the paddle
    local paddleCenter = paddle.y + paddle.height / 2

    -- Find the center of the ball
    local ballCenter = ball.y + ball.size / 2

    -- Distance from paddle center
    local difference = ballCenter - paddleCenter

    -- Normalize between -1 and 1
    local normalized = difference / (paddle.height / 2)

    -- Limit the value
    normalized = math.max(-1, math.min(1, normalized))

    -- Maximum bounce angle
    local maxAngle = math.rad(60)

    local angle = normalized * maxAngle

    -- Increase speed after every paddle hit
    ball.speed = math.min(ball.speed * 1.05, ball.maxSpeed)

    ball.speedX = math.cos(angle) * ball.speed * direction
    ball.speedY = math.sin(angle) * ball.speed

end


-- ========================================
-- START ROUND
-- ========================================

function startRound()

    countdown = 3
    countdownValue = 3

    gameState = "countdown"

end


-- ========================================
-- UPDATE
-- ========================================

function love.update(dt)

    -- ====================================
    -- MENU
    -- ====================================

    if gameState == "menu" then
        return
    end


    -- ====================================
    -- GAME OVER
    -- ====================================

    if gameState == "gameover" then
        return
    end


    -- ====================================
    -- COUNTDOWN
    -- ====================================

    if gameState == "countdown" then

        countdown = countdown - dt

        local newValue = math.ceil(countdown)

        if newValue ~= countdownValue then
            countdownValue = newValue
        end

        if countdown <= 0 then
            gameState = "playing"
        end

        return

    end


    -- ====================================
    -- PAUSED
    -- ====================================

    if gameState == "paused" then
        return
    end


    -- ====================================
    -- PLAYER MOVEMENT
    -- ====================================

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end


    -- Keep player inside screen

    player.y = math.max(
        0,
        math.min(HEIGHT - player.height, player.y)
    )


    -- ====================================
    -- ENEMY AI
    -- ====================================

    local enemyCenter = enemy.y + enemy.height / 2
    local ballCenter = ball.y + ball.size / 2

    local difference = ballCenter - enemyCenter

    -- Only move if the difference is noticeable
    if math.abs(difference) > 10 then

        local movement = enemy.speed * dt

        if difference > 0 then
            enemy.y = enemy.y + movement
        else
            enemy.y = enemy.y - movement
        end

    end


    -- Keep enemy inside screen

    enemy.y = math.max(
        0,
        math.min(HEIGHT - enemy.height, enemy.y)
    )


    -- ====================================
    -- BALL MOVEMENT
    -- ====================================

    ball.x = ball.x + ball.speedX * dt
    ball.y = ball.y + ball.speedY * dt


    -- ====================================
    -- TOP WALL
    -- ====================================

    if ball.y <= 0 then

        ball.y = 0
        ball.speedY = math.abs(ball.speedY)

    end


    -- ====================================
    -- BOTTOM WALL
    -- ====================================

    if ball.y + ball.size >= HEIGHT then

        ball.y = HEIGHT - ball.size
        ball.speedY = -math.abs(ball.speedY)

    end


    -- ====================================
    -- PLAYER COLLISION
    -- ====================================

    if checkCollision(ball, player) and ball.speedX < 0 then

        ball.x = player.x + player.width

        bounceFromPaddle(player, 1)

    end


    -- ====================================
    -- ENEMY COLLISION
    -- ====================================

    if checkCollision(ball, enemy) and ball.speedX > 0 then

        ball.x = enemy.x - ball.size

        bounceFromPaddle(enemy, -1)

    end


    -- ====================================
    -- PLAYER SCORES
    -- ====================================

    if ball.x > WIDTH then

        playerScore = playerScore + 1

        if playerScore >= WIN_SCORE then

            gameState = "gameover"

        else

            resetBall(-1)
            startRound()

        end

    end


    -- ====================================
    -- ENEMY SCORES
    -- ====================================

    if ball.x + ball.size < 0 then

        enemyScore = enemyScore + 1

        if enemyScore >= WIN_SCORE then

            gameState = "gameover"

        else

            resetBall(1)
            startRound()

        end

    end

end


-- ========================================
-- KEYBOARD INPUT
-- ========================================

function love.keypressed(key)

    -- ====================================
    -- MENU
    -- ====================================

    if gameState == "menu" then

        if key == "space" or key == "return" then

            resetGame()

        elseif key == "escape" then

            love.event.quit()

        end

        return

    end


    -- ====================================
    -- PAUSE
    -- ====================================

    if key == "p" or key == "escape" then

        if gameState == "playing" then

            gameState = "paused"

        elseif gameState == "paused" then

            gameState = "playing"

        end

        return

    end


    -- ====================================
    -- GAME OVER
    -- ====================================

    if gameState == "gameover" then

        if key == "r" or key == "return" then

            resetGame()

        elseif key == "escape" then

            love.event.quit()

        end

        return

    end

end


-- ========================================
-- DRAW CENTER LINE
-- ========================================

function drawCenterLine()

    for y = 0, HEIGHT, 30 do

        love.graphics.rectangle(
            "fill",
            WIDTH / 2 - 2,
            y,
            4,
            15
        )

    end

end


-- ========================================
-- DRAW SCORE
-- ========================================

function drawScore()

    love.graphics.setFont(bigFont)

    love.graphics.print(
        playerScore,
        WIDTH / 2 - 120,
        30
    )

    love.graphics.print(
        enemyScore,
        WIDTH / 2 + 80,
        30
    )

end


-- ========================================
-- DRAW
-- ========================================

function love.draw()

    -- Background
    love.graphics.clear(0.04, 0.04, 0.06)


    -- ====================================
    -- MENU
    -- ====================================

    if gameState == "menu" then

        love.graphics.setFont(bigFont)

        love.graphics.printf(
            "LUA PONG",
            0,
            150,
            WIDTH,
            "center"
        )

        love.graphics.setFont(font)

        love.graphics.printf(
            "Press SPACE or ENTER to start",
            0,
            280,
            WIDTH,
            "center"
        )

        love.graphics.printf(
            "W / S  -  Move",
            0,
            330,
            WIDTH,
            "center"
        )

        love.graphics.printf(
            "P / ESC  -  Pause",
            0,
            370,
            WIDTH,
            "center"
        )

        love.graphics.printf(
            "First to 5 wins",
            0,
            420,
            WIDTH,
            "center"
        )

        return

    end


    -- ====================================
    -- GAME
    -- ====================================

    drawCenterLine()
    drawScore()


    -- Player paddle
    love.graphics.rectangle(
        "fill",
        player.x,
        player.y,
        player.width,
        player.height
    )


    -- Enemy paddle
    love.graphics.rectangle(
        "fill",
        enemy.x,
        enemy.y,
        enemy.width,
        enemy.height
    )


    -- Ball
    love.graphics.rectangle(
        "fill",
        ball.x,
        ball.y,
        ball.size,
        ball.size
    )


    -- ====================================
    -- COUNTDOWN
    -- ====================================

    if gameState == "countdown" then

        love.graphics.setFont(bigFont)

        love.graphics.printf(
            tostring(countdownValue),
            0,
            HEIGHT / 2 - 50,
            WIDTH,
            "center"
        )

    end


    -- ====================================
    -- PAUSED
    -- ====================================

    if gameState == "paused" then

        love.graphics.setFont(bigFont)

        love.graphics.printf(
            "PAUSED",
            0,
            240,
            WIDTH,
            "center"
        )

        love.graphics.setFont(font)

        love.graphics.printf(
            "Press P or ESC to continue",
            0,
            320,
            WIDTH,
            "center"
        )

    end


    -- ====================================
    -- GAME OVER
    -- ====================================

    if gameState == "gameover" then

        love.graphics.setFont(bigFont)

        if playerScore >= WIN_SCORE then

            love.graphics.printf(
                "YOU WIN!",
                0,
                220,
                WIDTH,
                "center"
            )

        else

            love.graphics.printf(
                "YOU LOSE!",
                0,
                220,
                WIDTH,
                "center"
            )

        end

        love.graphics.setFont(font)

        love.graphics.printf(
            playerScore .. "  -  " .. enemyScore,
            0,
            300,
            WIDTH,
            "center"
        )

        love.graphics.printf(
            "Press R or ENTER to play again",
            0,
            360,
            WIDTH,
            "center"
        )

        love.graphics.printf(
            "Press ESC to quit",
            0,
            400,
            WIDTH,
            "center"
        )

    end

end
