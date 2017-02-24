
local FishManager = class("FishManager")

FishManager.fishPool = {}
FishManager.moveingFishPool = {}

--------------------------------------
-- createSymbol 
--------------------------------------
function FishManager.create( sourceID )

    local fishData = FishManager.getFromPool( sourceID )

    if false then
   -- if fishData then
        print("fishData",fishData.name)
        --fishData:reset()
    else
        fishData = Fish.new(sourceID)
    end

    FishManager.addFish( fishData )


    return fishData

end

function FishManager.addFish( fish )

    local fishes = FishManager.moveingFishPool[tostring(fish.sourceID)]

    if fishes == nil then
        fishes = {}
    end
    table.insert(fishes, fish)

    FishManager.moveingFishPool[tostring(fish.sourceID)] = fishes

end

function FishManager.delFish( fish )

   local fishes = FishManager.moveingFishPool[tostring(fish.sourceID)]

    if fishes and #fishes > 0 then
        for i=1,#fishes do
            if fishes[i] == fish then
                table.remove(fishes, i)
            end
        end
    end

    FishManager.moveingFishPool[tostring(fish.sourceID)] = fishes

end

--------------------------------------
-- release 
--------------------------------------
function FishManager.release()
    FishManager.fishPool = {}
    -- local fish
    for sourceID, fishes in pairs(FishManager.moveingFishPool) do
        print("FishManager.release() #fishes:",#fishes)
        for i=1,#fishes do
            local fish = fishes[i]
            -- print("fish.sourceID:",fish.sourceID,",sourceID:",sourceID)
            if fish.sourceID~=nil then
                fish:release()
            else
                print(fish)
            end
            fish = nil
        end
    end
    FishManager.moveingFishPool = {}

end

--------------------------------------
-- getFromPool 
--------------------------------------
function FishManager.getFromPool( sourceID )

    local fishes = FishManager.fishPool[tostring(sourceID)]

    if fishes and #fishes > 0 then
        return table.remove(fishes);
    end

    return nil
end

--------------------------------------
-- push 
--------------------------------------
function FishManager.push( fish )

    local fishes = FishManager.fishPool[tostring(fish.sourceID)]

    if fishes == nil then
        fishes = {}
    end
    table.insert(fishes, fish)

    FishManager.fishPool[tostring(fish.sourceID)] = fishes

    FishManager.delFish( fish )

end

return FishManager