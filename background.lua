function Background()
    a = {}
    a.sky = {
        sprite = love.graphics.newImage('static/sky.png'),
        x = 0,
        y = 0,
        width = 1467,
        height = 677
    }
    a.clouds = {
        sprite = love.graphics.newImage('static/cloud.png'),
        speed = -40,
        x = 0,
        y = 0,
        width = 1467,
        height = 677
    }
    a.hills = {
        sprite = love.graphics.newImage('static/hills.png'),
        speed = -50,
        x = 0,
        y = 0,
        width = 1467,
        height = 677
    }
    a.ground = {
        sprite = love.graphics.newImage('static/ground.png'),
        speed = -80,
        x = 0,
        y = -76,
        width = 1467,
        height = 677
    }

    function a:animate(dt)
        self.clouds.x = self.clouds.x + self.clouds.speed * dt
        self.hills.x = self.hills.x + self.hills.speed * dt
        self.ground.x = self.ground.x + self.ground.speed * dt
        if self.clouds.x < -self.clouds.width then
            self.clouds.x = 0
        end
        if self.hills.x < -self.hills.width then
            self.hills.x = 0
        end
        if self.ground.x < -self.ground.width then
            self.ground.x = 0
        end
    end

    function a:render()
        love.graphics.draw(self.sky.sprite, self.sky.x, self.sky.y)
        love.graphics.draw(self.clouds.sprite, self.clouds.x, self.clouds.y)
        love.graphics.draw(self.clouds.sprite, self.clouds.x+self.clouds.width, self.clouds.y)
        love.graphics.draw(self.hills.sprite, self.hills.x, self.hills.y)
        love.graphics.draw(self.hills.sprite, self.hills.x+self.hills.width, self.hills.y)
    end

    function a:render_ground()
        love.graphics.draw(self.ground.sprite, self.ground.x, self.ground.y)
        love.graphics.draw(self.ground.sprite, self.ground.x+self.ground.width, self.ground.y)       
    end

    return a
end

return Background