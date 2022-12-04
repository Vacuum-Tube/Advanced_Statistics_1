local Polygon = {}
Polygon.__index = Polygon

local function intersects(line1, line2)
    local v1x1 = line1[1][1]
    local v1y1 = line1[1][2]
    local v1x2 = line1[2][1]
    local v1y2 = line1[2][2]
    
    local v2x1 = line2[1][1]
    local v2y1 = line2[1][2]
    local v2x2 = line2[2][1]
    local v2y2 = line2[2][2]
    
    local d1, d2
    local a1, a2, b1, b2, c1, c2
    
    a1 = v1y2 - v1y1
    b1 = v1x1 - v1x2
    c1 = (v1x2 * v1y1) - (v1x1 * v1y2)
    
    d1 = (a1 * v2x1) + (b1 * v2y1) + c1
    d2 = (a1 * v2x2) + (b1 * v2y2) + c1
    
    if d1 > 0 and d2 > 0 then
        return false
    end
    
    if d1 < 0 and d2 < 0 then
        return false
    end
    
    a2 = v2y2 - v2y1
    b2 = v2x1 - v2x2
    c2 = (v2x2 * v2y1) - (v2x1 * v2y2)
    
    d1 = (a2 * v1x1) + (b2 * v1y1) + c2
    d2 = (a2 * v1x2) + (b2 * v1y2) + c2
    
    if d1 > 0 and d2 > 0 then
        return false
    end
    
    if d1 < 0 and d2 < 0 then
        return false
    end
    
    --colinear
    if (a1 * b2) - (a2 * b1) == 0.0 then
        return false
    end
    
    return true
end

local function isLeft(p1, p2, p3)
    return ((p1[1] - p3[1]) * (p2[2] - p3[2]) - (p2[1] - p3[1]) * (p1[2] - p3[2]))
end

local function windings(p, v)
    local wn = 0
    
    for i = 1, #v - 1 do
        if v[i][2] <= p[2] then
            if (v[i + 1][2] > p[2]) then
                if isLeft(v[i], v[i + 1], p) > 0 then
                    wn = wn + 1
                end
            end
        else
            if (v[i + 1][2] <= p[2]) then
                if (isLeft(v[i], v[i + 1], p) < 0) then
                    wn = wn - 1
                end
            end
        end
    end
    return wn
end

local function contains(p0, p1, p2, p3)    
    local d1 = isLeft(p0, p1, p2)
    local d2 = isLeft(p0, p2, p3)
    local d3 = isLeft(p0, p3, p1)

    local hasNeg = d1 < 0 or d2 < 0 or d3 < 0
    local hasPos = d1 > 0 or d2 > 0 or d3 > 0

    return not (hasNeg and hasPos)
end

local function clip( index, nodes, points, clockwise )

    local node = nodes[index]

    --check if node was already clipped
    if node == nil then
        return nil
    end

    local currentPoint = points[index]
    local previousPoint = points[node.previousIndex]
    local nextPoint = points[node.nextIndex]                   
           
    --check if convex
    if (isLeft(currentPoint, previousPoint, nextPoint) > 0) ~= clockwise then              
        return nil
    end
         
    local checkIndex = nodes[node.nextIndex].nextIndex

    --check if triangle contains other points. afaik we only need to check unclipped points.
    while checkIndex ~= node.previousIndex do
    
        local checkPoint = points[checkIndex]

        if contains(checkPoint, previousPoint, currentPoint, nextPoint) then
            return nil
        end

        checkIndex = nodes[checkIndex].nextIndex
    end

    return {previousPoint, currentPoint, nextPoint}    
end


function Polygon:Create(points)
	assert(type(points)=="table")
	assert(#points>0)
	assert(type(points[1])=="table")
    local polygon = points
    setmetatable(polygon, Polygon)
    return polygon
end

function Polygon:GetBounds()
    local xmin, xmax, ymin, ymax
    for i = 1, #self do
        local point = self[i]
        if (not xmin or point[1] < xmin) then
            xmin = point[1]
        end
        if (not xmax or point[1] > xmax) then
            xmax = point[1]
        end
        if (not ymin or point[2] < ymin) then
            ymin = point[2]
        end
        if (not ymax or point[2] > ymax) then
            ymax = point[2]
        end
    end
    return {
        x = xmin,
        y = ymin,
        width = xmax - xmin,
        height = ymax - ymin,
    }
end

function Polygon:Contains(point, bounds)
    if not bounds then
        bounds = self:GetBounds()
    end
    
    if (point[1] < bounds.x or point[1] > bounds.x + bounds.width or point[2] < bounds.y or point[2] > bounds.y + bounds.height) then
        return false
    end
    
    local poly = {table.unpack(self)}  -- copy
    poly[#poly + 1] = poly[1]
    
    local horizontal = {{bounds.x, point[2]}, {point[1], point[2]}}
    local windingNumber = windings(point, poly)
    
    return windingNumber % 2 == 1
end

function Polygon:IsClockwise()
    local sum = 0
    for i = 1, #self do
        local a = self[(i - 1) % #self + 1]
        local b = self[i % #self + 1]
        sum = sum + (b[1] - a[1]) * (b[2] + a[2])
    end
    return sum > 0
end

function Polygon:IsSelfIntersecting()
    local edges = {}
    for i = 1, #self do
        local a = self[i]
        local b = self[(i % #self) + 1]
        
        edges[#edges + 1] = {a, b}
    end
    
    if #edges < 4 then
        return false
    end
    
    for i = 1, #edges do
        for j = i + 1, #edges do
            if math.abs(j - i) > 1 and (i > 1 or j < #edges) then
                local ai = (i - 1 % #edges) + 1
                local aj = (j - 1 % #edges) + 1
                
                local a = edges[ai]
                local b = edges[aj]
                
                if intersects(a, b) then
                    return true
                end
            end
        end
    end
    
    return false
end

function Polygon:GetArea()  -- Shoelace formula
	-- if self:IsSelfIntersecting() then
		-- return  -- subareas get negative
	-- end
	local p,q = self[#self], self[1]
	local a = p[1]*q[2] - p[2]*q[1]
	for i = 2,#self do
		p,q = q,self[i]
		a = a + p[1]*q[2] - p[2]*q[1]
	end
	return math.abs(a) / 2
end

function Polygon:Triangulate()
    if #self < 3 then
        return nil
    end

    local clockwise = self:IsClockwise()    --we need this to determine convexity
    local count = #self                     --number of points that are not clipped
    local result = {}                       --triangles
    local nodes = {}                        --linked index list of unclipped point indices

    --fill node list
    for i = 1,#self do
        nodes[i] = {
            previousIndex = (i + #self - 2) % #self + 1,            
            nextIndex = i % #self + 1
        }
    end
    
    --clip 'ears' until only three points are left
    while count > 3 do     
        
        --try to find a triangle for clipping. there's always one ;)
        for i = 1,#self do 
            local triangle = clip(i, nodes, self, clockwise)

            --point with index i and its previous and next node will form a triangle
            if triangle ~= nil then

                local node = nodes[i];

                --relink nodes
                nodes[node.previousIndex].nextIndex = node.nextIndex
                nodes[node.nextIndex].previousIndex = node.previousIndex
                nodes[i] = nil

                count = count - 1   
                result[#result + 1] = triangle 

                --add the last triangle to the result list
                if count == 3 then
                    result[#result + 1] = {
                        self[node.previousIndex],
                        self[node.nextIndex],
                        self[nodes[node.nextIndex].nextIndex]
                    }
                end
                
                break
            end 
        end

    end    
        
    return result
end

return Polygon