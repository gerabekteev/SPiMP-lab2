os.execute("chcp 65001 > nul")

local Life = require("life")

local WIDTH = 50
local HEIGHT = 25
local DELAY = 0.1 -- скорость
local DENSITY = 0.25 -- сколько в начале

local currentGrid = Life.create(WIDTH, HEIGHT)
local nextGrid = Life.create(WIDTH, HEIGHT)

math.randomseed(os.time())
Life.randomize(currentGrid, DENSITY)

local function render(grid, generation)
    os.execute("cls")
    
    print("Conway's Game of Life - Lua")
    print("Generation: " .. generation)
    print("+" .. string.rep("-", grid.width) .. "+")
    
    local output = {}
    for y = 1, grid.height do
        local line = "|"
        for x = 1, grid.width do
            line = line .. (grid[y][x] and "█" or " ")
        end
        table.insert(output, line .. "|")
    end
    print(table.concat(output, "\n"))
    
    print("+" .. string.rep("-", grid.width) .. "+")
    print("Press Ctrl+C to exit. Speed: " .. (1/DELAY) .. " fps")
end


local function sleep(seconds)
    local t = os.clock()
    while os.clock() - t < seconds do 
    end
end

local generation = 0
while true do
    render(currentGrid, generation)
    
    Life.update(currentGrid, nextGrid)
    
    currentGrid, nextGrid = nextGrid, currentGrid
    
    generation = generation + 1
    
    if DELAY > 0 then
        sleep(DELAY)
    end
end
