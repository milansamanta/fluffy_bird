require 'background'
require 'obstacle'
require 'bird'
require 'buttons'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

function gameOver()
    for i = 1, #obstacle do
        if bird.x+bird.width > obstacle[i].x+8 and bird.x+2 < obstacle[i].x+obstacle[i].width-6 then
            if obstacle[i].up.y+obstacle[i].height-6 >= bird.y or bird.y+bird.height >= obstacle[i].down.y+6 then
                sounds.bgm:stop()
                sounds.die:play()
                GAME_STATE = 'gameOver'
            end
        end
    end
    if bird.y >= bird.ground_height - bird.height then
        sounds.bgm:stop()
        sounds.die:play()
        GAME_STATE = 'gameOver'
    end
end

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    font = love.graphics.setNewFont("static/flappy-bird.ttf", 54)
    love.window.setTitle("Fluffy Bird")
    icon = love.image.newImageData('static/icon.png')
    love.window.setIcon(icon)
    love.window.setVSync(true)
    hand = love.mouse.getSystemCursor("hand")
    obstacle = {}
    background = Background()
    threshold = 10
    level = 10
    for i = 1, 5 do
        obstacle[i] = Obstacle()
        if i == 1 then
            obstacle[i].x = WINDOW_WIDTH
        else
            obstacle[i].x = obstacle[i-1].x + math.random(100+obstacle[i].width, 300+obstacle[i].width)
        end
    end
    bird = Bird()
    GAME_STATE = 'start'
    score = 0
    buttons = {
        start ={},
        paused = {},
        gameOver = {}
    }
    buttons.start.play = Button("PLAY", Play, 75, 45, WINDOW_WIDTH/2-55, WINDOW_HEIGHT/2 -20)
    buttons.start.quit = Button("QUIT", love.event.quit, 70, 45, WINDOW_WIDTH-75, 0)
    buttons.paused.resume = Button("Resume", Play, 125, 45, WINDOW_WIDTH/2-70, WINDOW_HEIGHT/2 -20)
    buttons.paused.quit = Button("QUIT", love.event.quit, 70, 45, WINDOW_WIDTH-75, 0)
    buttons.gameOver.quit = Button("QUIT", love.event.quit, 70, 45, WINDOW_WIDTH-75, 0)
    buttons.gameOver.restart = Button("Restart", restart, 125, 45, WINDOW_WIDTH/2 - 80, WINDOW_HEIGHT/2+5, nil, 0.6)
    count = 3

    sounds = {}
    sounds.bgm = love.audio.newSource('static/bgm.mp3', 'stream')
    sounds.die = love.audio.newSource('static/die.mp3', 'static')
    sounds.jump = love.audio.newSource('static/jump.mp3', 'static')
    sounds.point = love.audio.newSource('static/point.mp3', 'static')
    sounds.timer = love.audio.newSource('static/timer.wav', 'static')
    sounds.bgm:setLooping(true)
    sounds.bgm:play()
    sounds.played1 = false
    sounds.played2 = false
    sounds.played3 = false
    sounds.bgmplayed = true
end

function love.update(dt)
    if GAME_STATE ~= 'paused' and GAME_STATE ~= 'countdown' then
        background:animate(dt)
    end
    resume(dt)
    if GAME_STATE == 'play' then
        for i = 1, #obstacle do
            obstacle[i]:animate(dt)
            if obstacle[i].x+obstacle[i].width < 0 then 
                rand = math.random(100+obstacle[i].width, 300+obstacle[i].width)
                if i == 1 then
                    obstacle[i].x = obstacle[5].x + rand
                else
                    obstacle[i].x = obstacle[i-1].x + rand
                end
            end
        end
        bird:animate(dt)
        bird:fall(dt)
        bird:accelerate(dt)
        scoring()
        gameOver()
        if score >= level then
            level = level + threshold
            background.clouds.speed = background.clouds.speed - 20
            background.hills.speed = background.hills.speed - 20
            background.ground.speed = background.ground.speed - 20
            for i = 1, 5 do
                obstacle[i].speed = obstacle[i].speed - 20
            end
        end

    end
end

function love.mousemoved(x, y)
    if buttons[GAME_STATE] then
        for _, button in pairs(buttons[GAME_STATE]) do
            button:is_over(x, y)
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if buttons[GAME_STATE] then
            for _, button in pairs(buttons[GAME_STATE]) do
                button:is_pressed(x, y)
                love.mouse.setCursor()
            end
        end
    end
end

function love.keypressed(key)
    if key == 'enter' or key == 'return' then
        if GAME_STATE == 'start' then
            GAME_STATE = 'countdown'
        elseif GAME_STATE == 'paused' then
            GAME_STATE = 'countdown'
        elseif GAME_STATE == 'gameOver' then
            restart()
        end
    elseif key == 'escape' then
        if GAME_STATE == 'play' then
            GAME_STATE = 'paused'
            sounds.bgm:stop()
            sounds.bgmplayed = false
        elseif GAME_STATE == 'paused' then
            GAME_STATE = 'countdown'
        end
    elseif key == 'space' then
        bird.dv = -200
        sounds.jump:play()
    end
end

function love.draw()
    
    background:render()
    if GAME_STATE == 'play' or GAME_STATE == 'countdown' or GAME_STATE == 'paused' then
        if love.mouse.isVisible() then
            love.mouse.setVisible(false)
        end
        for i = 1, #obstacle do
            obstacle[i].up:render()
            obstacle[i].down:render()
        end
    end
    background:render_ground()
    if GAME_STATE == 'play' or GAME_STATE == 'countdown' or GAME_STATE == 'paused' then
        bird:render()
        love.graphics.print('SCORE:'..tostring(score))
    elseif GAME_STATE == 'gameOver' then
        love.graphics.print("GAME OVER", WINDOW_WIDTH/2 - 180, WINDOW_HEIGHT/2 -200, nil, 2)
        love.graphics.print("Score:"..tostring(score), WINDOW_WIDTH/2 - 90, WINDOW_HEIGHT/2 -100)
        love.graphics.print("You are a noob", WINDOW_WIDTH/2 - 100, WINDOW_HEIGHT/2 -50,nil, 0.6)
        love.graphics.print("Press ENTER to", WINDOW_WIDTH/2 - 97, WINDOW_HEIGHT/2-20,nil, 0.6)
    end
    if GAME_STATE == 'countdown' then
        love.graphics.print(tostring(count), WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 -200, nil, 2)
    elseif GAME_STATE == 'start' then
        love.graphics.print("Fluffy Bird", WINDOW_WIDTH/2 - 200, WINDOW_HEIGHT/2 -200, nil, 2)
        love.graphics.print("Press ENTER to", WINDOW_WIDTH/2 - 100, WINDOW_HEIGHT/2 -60, nil, 0.7)
    elseif GAME_STATE == 'paused' then
        love.graphics.print("Paused", WINDOW_WIDTH/2 - 120, WINDOW_HEIGHT/2 -200, nil, 2)
        love.graphics.print("Press ENTER to", WINDOW_WIDTH/2 - 100, WINDOW_HEIGHT/2 -85, nil, .7)
    end
    if buttons[GAME_STATE] then
        if not love.mouse.isVisible() then
            love.mouse.setVisible(true)
        end
        for _, button in pairs(buttons[GAME_STATE]) do
            button:draw()
        end
    end
end