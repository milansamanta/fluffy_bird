function Button(text, func, width, height, x, y)
    return {
        width = width or 100,
        height = height or 50,
        func = func or function ()
            print("No function attached")
        end,
        text = text or "No text",
        buttonx = x or 200,
        buttony = y or 200,
        mouseover = false,
        draw = function(self, buttonx, buttony)
            buttonx = buttonx or self.buttonx
            buttony = buttony or self.buttony
            love.graphics.print(text, buttonx, buttony)
        end,
        is_pressed = function(self, x, y)
            if x >= self.buttonx and x <= self.buttonx + self.width then
                if y >= self.buttony and y <= self.buttony + self.height then
                    func()
                end
            end
        end,
        is_over = function(self, x, y)
            if x >= self.buttonx and x <= self.buttonx + self.width and y >= self.buttony and y <= self.buttony + self.height then
                self.mouseover = true
                love.mouse.setCursor(hand)
            elseif self.mouseover == true then
                self.mouseover = false
                love.mouse.setCursor()
            end
        end
    }
end

function Play()
    GAME_STATE = 'countdown'
end

function restart()
    reset()
    GAME_STATE = 'countdown' 
end

function resume(dt)
    if GAME_STATE == 'countdown' then
        if sounds.bgmplayed then
            sounds.bgm:stop()
            sounds.bgmplayed = false
        end
        bird.timer = bird.timer - dt
        if bird.timer <= 1 then
            GAME_STATE = 'play'
            sounds.bgm:play()
            sounds.bgmplayed = true
            bird.timer = 4
        elseif bird.timer <= 2 then
            count = 1
            if not sounds.played1 then
                sounds.timer:play()
                sounds.played1 = true
                sounds.played3 = false
            end
        elseif bird.timer <= 3 then
            count = 2
            if not sounds.played2 then
                sounds.timer:play()
                sounds.played2 = true
                sounds.played1 = false
            end
        elseif bird.timer <= 4 then
            count = 3
            if not sounds.played3 then
                sounds.timer:play()
                sounds.played3 = true
                sounds.played2 = false
            end
        end
    end
end