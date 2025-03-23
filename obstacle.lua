function Obstacle()
    local a = {
        sprite = love.graphics.newImage('static/obstacle.png'),
        width = 116,
        height = 492,
        max_gap = 200,
        min_gap = 100,
        speed = -80,
        x = WINDOW_WIDTH,
        passed = false,
        up = {
            y = -math.random(200, 450)
        },
        down = {}
        
    }
    a.down.y = a.up.y + a.height + math.random(a.min_gap, a.max_gap)
    function a:animate(dt)
        self.x = self.x + self.speed * dt
        if a.x+a.width < 0 then
            self.up.y = -math.random(100, 400)
            self.down.y = self.up.y + self.height + math.random(self.min_gap, self.max_gap)
        end
    end
    function a.down:render()
        love.graphics.draw(a.sprite, a.x, self.y, nil, 1, -1, nil, a.height)
    end
    function a.up:render()
        love.graphics.draw(a.sprite, a.x, self.y)
    end
    return a
end

return Obstacle