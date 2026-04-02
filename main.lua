os.execute("chcp 65001 > nul")

local Life = require("life")

local WIDTH = 50
local HEIGHT = 25
local DELAY = 0.1 -- скорость
local DENSITY = 0.25 -- сколько в начале

local currentGrid = Life.create(WIDTH, HEIGHT)
local nextGrid = Life.create(WIDTH, HEIGHT)

math.randomseed(os.time())

local function render(grid, generation)
    os.execute("cls")
    
    print("Кадр - : " .. generation)
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
    print((1/DELAY) .. " fps")
end


local function sleep(seconds)
    local t = os.clock()
    while os.clock() - t < seconds do 
    end
end

os.execute("cls")
print("Выберите режим игры:")
print("1 - Случайное заполнение")
print("2 - Ручное заполнение (ввод координат X Y)")
io.write("Ваш выбор (1 или 2): ")
local mode = tonumber(io.read())

if mode == 1 then
    io.write("Введите плотность (от 0.0 до 1.0, например 0.3. Оставьте пустым для " .. DENSITY .. "): ")
    local input = io.read()
    local userDensity = tonumber(input)
    if userDensity then DENSITY = userDensity end
    Life.randomize(currentGrid, DENSITY)
elseif mode == 2 then
    while true do
        os.execute("cls")
        print("--- Режим редактирования поля ---")
        print("+" .. string.rep("-", currentGrid.width) .. "+")
        local output = {}
        for y = 1, currentGrid.height do
            local line = "|"
            for x = 1, currentGrid.width do
                line = line .. (currentGrid[y][x] and "█" or " ")
            end
            table.insert(output, line .. "| " .. y)
        end
        print(table.concat(output, "\n"))
        print("+" .. string.rep("-", currentGrid.width) .. "+")
        print(" Оси: X (вправо, 1-"..WIDTH.."), Y (вниз, 1-"..HEIGHT..")")
        print("Введите координаты: 'x y' (например '10 5') и нажмите Enter.")
        print("Или введите 'start' для старта игры.")
        io.write("> ")
        local input = io.read()
        
        if input == "start" then break end
        
        local x_str, y_str = string.match(input, "(%d+)%s+(%d+)")
        local x, y = tonumber(x_str), tonumber(y_str)
        if x and y and x >= 1 and x <= WIDTH and y >= 1 and y <= HEIGHT then
            currentGrid[y][x] = not currentGrid[y][x]
        else
            print("Неверный ввод! Нажмите Enter...")
            io.read()
        end
    end
else
    print("Выбран стандартный случайный режим.")
    Life.randomize(currentGrid, DENSITY)
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
