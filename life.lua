local Life = {}

-- Create a new grid with specified dimensions
function Life.create(width, height)
    local grid = {}
    for y = 1, height do
        grid[y] = {}
        for x = 1, width do
            grid[y][x] = false
        end
    end
    grid.width = width
    grid.height = height
    return grid
end

-- Randomly populate the grid
function Life.randomize(grid, density)
    local d = density or 0.2
    for y = 1, grid.height do
        for x = 1, grid.width do
            grid[y][x] = math.random() < d
        end
    end
end

-- Count alive neighbors with wrapping (toroidal field)
local function countNeighbors(grid, x, y)
    local count = 0
    local w = grid.width
    local h = grid.height
    
    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                local nx = (x + dx - 1) % w + 1
                local ny = (y + dy - 1) % h + 1
                if grid[ny][nx] then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Update the grid state in the 'next' buffer based on 'current'
function Life.update(current, next)
    local w = current.width
    local h = current.height
    
    for y = 1, h do
        for x = 1, w do
            local neighbors = countNeighbors(current, x, y)
            local isAlive = current[y][x]
            
            if isAlive then
                -- Rules for alive cell
                if neighbors < 2 or neighbors > 3 then
                    next[y][x] = false -- Death (underpopulation or overpopulation)
                else
                    next[y][x] = true  -- Survival
                end
            else
                -- Rules for dead cell
                if neighbors == 3 then
                    next[y][x] = true  -- Reproduction
                else
                    next[y][x] = false -- Stasis
                end
            end
        end
    end
end

return Life
