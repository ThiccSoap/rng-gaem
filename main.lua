local json = require("dkjson")

-- Initialization
function love.load()
	love.window.setTitle("rng gaem")
    math.randomseed(os.time())
    rarity = "Press any key to generate a rarity"
    rollCount = 0
    autoRoll = false
    rollTimer = 0
    rarestRarity = nil
    cutsceneActive = false
    cutsceneType = nil
    cutsceneTimer = 0
    sparkleRotation = 0
    sparkleScale = 1
    showSolarnium = false
    autoRollUnlocked = false
    build = "Build 37"
    changelogVisible = true
    changelog = [[
    Changelog:
    - Build 37
    - Nerfed auto roll 
    - Removed some placeholder texts
    - 
    ]]
    rarityBookVisible = false
    rarityBook = {
        ["Common"] = "Common: 1 in 1.5 to 1 in 5",
        ["Uncommon"] = "Uncommon: 1 in 5.01 to 1 in 20",
        ["Rare"] = "Rare: 1 in 20.01 to 1 in 50",
        ["Epic"] = "Epic: 1 in 50.01 to 1 in 250",
        ["Legendary"] = "Legendary: 1 in 250.01 to 1 in 999",
        ["Insane"] = "Insane: 1 in 1000 to 1 in 2000",
        ["Epic:Dark"] = "Epic:Dark: 1 in 2000 to 1 in 2600",
        ["Epic:Light"] = "Epic:Light: 1 in 2600 to 1 in 3200",
        ["Solarnium"] = "Solarnium: 1 in 3200 to 1 in 4000",
        ["Mythical"] = "Mythical: Rare and powerful, emerging from the unknown.",
        ["Quantum"] = "Quantum: An otherworldly rarity with shifting properties."
    }
    rarityWeights = {
        ["Common"] = 50,
        ["Uncommon"] = 30,
        ["Rare"] = 15,
        ["Epic"] = 4,
        ["Legendary"] = 0.9,
        ["Insane"] = 0.1,
        ["Epic:Dark"] = 0.1 / 13,
        ["Epic:Light"] = 0.1 / 13,
        ["Solarnium"] = 0.1 / 100,
        ["Mythical"] = 0.05,
        ["Quantum"] = 0.02
    }
    love.graphics.setBackgroundColor(0, 0, 0)
    
    -- Load saved game data
    loadGame()
end

-- Function to generate a random rarity
function generateRarity()
    local weights = {
        {rarity = "Common", weight = 50},
        {rarity = "Uncommon", weight = 30},
        {rarity = "Rare", weight = 15},
        {rarity = "Epic", weight = 4},
        {rarity = "Legendary", weight = 0.9},
        {rarity = "Insane", weight = 0.1},
        {rarity = "Epic:Dark", weight = 0.1 / 13},
        {rarity = "Epic:Light", weight = 0.1 / 13},
        {rarity = "Solarnium", weight = 0.1 / 100},
        {rarity = "Mythical", weight = 0.05},
        {rarity = "Quantum", weight = 0.02}
    }

    local totalWeight = 0
    for _, item in ipairs(weights) do
        totalWeight = totalWeight + item.weight
    end

    local randomNumber = math.random() * totalWeight
    for _, item in ipairs(weights) do
        if randomNumber < item.weight then
            return item.rarity
        end
        randomNumber = randomNumber - item.weight
    end
end

-- Function to format numbers with commas
function formatNumberWithCommas(number)
    local formatted = tostring(number)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Function to update the rarest rarity
function updateRarestRarity(newRarity)
    if not rarestRarity or rarityWeights[newRarity] < rarityWeights[rarestRarity] then
        rarestRarity = newRarity
    end
end

-- Function to save the game
function saveGame()
    local data = {
        rarity = rarity,
        rollCount = rollCount,
        autoRoll = autoRoll,
        rarestRarity = rarestRarity,
        autoRollUnlocked = autoRollUnlocked
    }
    local jsonData = json.encode(data, { indent = true })
    love.filesystem.write("savegame.json", jsonData)
end

-- Function to load the game
function loadGame()
    local file = love.filesystem.read("savegame.json")
    if file then
        local data, _, err = json.decode(file)
        if not err then
            rarity = data.rarity or rarity
            rollCount = data.rollCount or rollCount
            autoRoll = data.autoRoll or autoRoll
            rarestRarity = data.rarestRarity or rarestRarity
            autoRollUnlocked = data.autoRollUnlocked or autoRollUnlocked
        end
    end
end

-- Function to handle key presses
function love.keypressed(key)
    if key == "space" then
        if rollCount >= 100000 then
            autoRoll = not autoRoll
        else
            print("Auto-roll requires 100,000 total rolls.")
        end
    elseif key == "c" then
        changelogVisible = not changelogVisible
    elseif key == "r" then
        rarityBookVisible = not rarityBookVisible
    else
        rarity = generateRarity()
        rollCount = rollCount + 1
        updateRarestRarity(rarity)
        if rarity == "Solarnium" then
            cutsceneActive = true
            cutsceneType = "Solarnium"
            cutsceneTimer = 0
            sparkleScale = 1
            showSolarnium = false
        elseif rarity == "Mythical" then
            cutsceneActive = true
            cutsceneType = "Mythical"
            cutsceneTimer = 0
            sparkleRotation = 0
            sparkleScale = 1
        elseif rarity == "Quantum" then
            cutsceneActive = true
            cutsceneType = "Quantum"
            cutsceneTimer = 0
            sparkleRotation = 0
            sparkleScale = 1
        end
        saveGame()
    end
end

-- Function to update game state
function love.update(dt)
    if autoRoll and rollCount >= 100000 then
        rollTimer = rollTimer + dt
        if rollTimer >= 0.01 then
            rarity = generateRarity()
            rollCount = rollCount + 1
            updateRarestRarity(rarity)
            if rarity == "Solarnium" then
                cutsceneActive = true
                cutsceneType = "Solarnium"
                cutsceneTimer = 0
                sparkleScale = 1
                showSolarnium = false
            elseif rarity == "Mythical" then
                cutsceneActive = true
                cutsceneType = "Mythical"
                cutsceneTimer = 0
                sparkleRotation = 0
                sparkleScale = 1
            elseif rarity == "Quantum" then
                cutsceneActive = true
                cutsceneType = "Quantum"
                cutsceneTimer = 0
                sparkleRotation = 0
                sparkleScale = 1
            end
            rollTimer = rollTimer - 0.1
            saveGame()
        end
    end

    if cutsceneActive then
        cutsceneTimer = cutsceneTimer + dt
        if cutsceneType == "Mythical" then
            -- Purple background transition
            local fadeDuration = 5
            local alpha = math.min(cutsceneTimer / fadeDuration, 1)
            love.graphics.setBackgroundColor(0.5 * alpha, 0, 0.5 * alpha)
            if cutsceneTimer >= fadeDuration then
                love.graphics.setBackgroundColor(0, 0, 0)
                cutsceneActive = false
            end
        elseif cutsceneType == "Quantum" then
            -- Screen color transition
            local transitionDuration = 5
            local alpha = math.min(cutsceneTimer / transitionDuration, 1)
            local colorValue = 0.5 * (1 - alpha)
            love.graphics.setBackgroundColor(colorValue, colorValue, colorValue)
            if cutsceneTimer >= transitionDuration then
                love.graphics.setBackgroundColor(0, 0, 0)
                cutsceneActive = false
            end
        elseif cutsceneType == "Solarnium" then
            sparkleRotation = sparkleRotation + dt * 2
            if cutsceneTimer < 2.5 then
                sparkleScale = sparkleScale - dt * 0.4
            else
                sparkleScale = sparkleScale + dt * 1.6
            end
            if cutsceneTimer > 5 then
                cutsceneActive = false
                showSolarnium = true
            end
        end
    end
end

-- Function to draw on the screen
function love.draw()
    if changelogVisible then
        love.graphics.clear()
        love.graphics.printf(changelog, 10, 10, love.graphics.getWidth() - 20)
        love.graphics.print("Press 'C' to close the changelog", 10, love.graphics.getHeight() - 20)
    elseif rarityBookVisible then
        love.graphics.clear()
        love.graphics.print("Rarity Book:", 10, 10)
        local y = 30
        for rarity, description in pairs(rarityBook) do
            love.graphics.print(description, 10, y)
            y = y + 20
        end
        love.graphics.print("Press 'R' to close the rarity book", 10, love.graphics.getHeight() - 20)
    else
        -- Clear the screen and set a black background
        love.graphics.clear(0, 0, 0)  -- Black background

        if cutsceneActive then
            if cutsceneType == "Solarnium" then
                love.graphics.setColor(1, 1, 1)  -- White color
                love.graphics.print("Solarnium Cutscene!", 10, 10)
                love.graphics.draw(sparkle, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, sparkleRotation, sparkleScale, sparkleScale, sparkle:getWidth() / 2, sparkle:getHeight() / 2)
            elseif cutsceneType == "Mythical" then
                love.graphics.setColor(1, 1, 1)  -- White color
                love.graphics.print("Mythical Cutscene!", 10, 10)
				love.graphics.draw(sparkle, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, sparkleRotation, sparkleScale, sparkleScale, sparkle:getWidth() / 2, sparkle:getHeight() / 2)
                -- You can add specific drawing or effects for the Mythical cutscene here
            elseif cutsceneType == "Quantum" then
                love.graphics.setColor(1, 1, 1)  -- White color
                love.graphics.print("Quantum Cutscene!", 10, 10)
				love.graphics.draw(sparkle, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, sparkleRotation, sparkleScale, sparkleScale, sparkle:getWidth() / 2, sparkle:getHeight() / 2)
                -- You can add specific drawing or effects for the Quantum cutscene here
            end
        else
            -- Draw the main game screen
            love.graphics.setColor(1, 1, 1)  -- White color
            love.graphics.print("Generated Rarity: " .. rarity, 10, 10)
            love.graphics.print("Total Rolls: " .. formatNumberWithCommas(rollCount), 10, 30)
            love.graphics.print("Auto-Roll: " .. (autoRoll and "Enabled" or "Disabled"), 10, 50)
            love.graphics.print("Auto-Roll Unlocked: " .. (autoRollUnlocked and "Yes" or "No"), 10, 70)
            love.graphics.print("Rarest Rarity: " .. (rarestRarity or "None"), 10, 90)

            if showSolarnium then
                love.graphics.print("placeholder i guess?", 10, 110)
            end

            love.graphics.print("Build: " .. build, 10, love.graphics.getHeight() - 20)
        end
    end
end

