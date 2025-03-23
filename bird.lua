function Bird()
    local b = {}
    b.sprite = love.graphics.newImage('static/bird.png')
    b.imagewidth = 260
    b.width = 65
    b.height = 39
    b.gravity = 600
    b.x = WINDOW_WIDTH/2 - 65
    b.y = 528/2 - 39
    b.dv = -200
    b.ground_height = 528
    b.animationtimer = 0
    b.timer = 4
    b.quad = {}
    for i = 1, 4 do
        b.quad[i] = love.graphics.newQuad((i-1)*b.width, 0, b.width, b.height, b.imagewidth, b.height)
    end
    b.frame = 1
    function b:accelerate(dt)
        if self.y + self.height < self.ground_height then
            self.dv = self.dv + self.gravity * dt
        else
            self.dv = 0
        end
    end
    function b:fall(dt)
        if self.y <= 0 then
            self.dv = 0
            self.y = 0
        end
        if self.y + self.height < self.ground_height then
            self.y =self.y + self.dv * dt + 0.5 * self.gravity * dt^2
        else
            self.y = self.ground_height - self.height
        end
    end
    function b:render()
        love.graphics.draw(self.sprite, self.quad[self.frame], self.x, self.y)
    end
    function b:animate(dt)
        self.animationtimer = self.animationtimer + dt
        if self.animationtimer >= 0.1 then
            if self.frame == 4 then
                self.frame = 1
            else
                self.frame = self.frame + 1
            end
            self.animationtimer = 0
        end
    end
    return b
end

function scoring()
    for i = 1, #obstacle do
        if bird.x > obstacle[i].x+obstacle[i].width-6 then
            if obstacle[i].passed == false then
                obstacle[i].passed = true
                score = score + 1
                sounds.point:play()
            end
        else
            obstacle[i].passed = false
        end
    end
end

function reset()
    bird.x = WINDOW_WIDTH/2 - 65
    bird.y = 528/2 - 39
    bird.dv = -200
    bird.frame = 1
    bird.animationtimer = 0
    score = 0
    for i = 1, 5 do
        obstacle[i].up.y = -math.random(150, 400)
        obstacle[i].down.y = obstacle[i].up.y + obstacle[i].height + math.random(obstacle[i].min_gap, obstacle[i].max_gap)
        if i == 1 then
            obstacle[i].x = WINDOW_WIDTH
        else
            obstacle[i].x = obstacle[i-1].x + math.random(200, 400)
        end
        obstacle[i].speed = -80
    end
    level = 10
    background.clouds.speed = -40
    background.hills.speed = -50
    background.ground.speed = -80
end