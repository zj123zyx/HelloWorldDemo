

local ReelGenerater = {}


local symbolsDistribution={
    ['21']={reel1=2, reel2=8, reel3=12, reel4=11, reel5=12, },
    ['22']={reel1=11, reel2=13, reel3=2, reel4=8, reel5=13, },
    ['23']={reel1=2, reel2=12, reel3=10, reel4=8, reel5=10, },
    ['24']={reel1=2, reel2=15, reel3=12, reel4=11, reel5=12, },
    ['25']={reel1=13, reel2=10, reel3=6, reel4=11, reel5=11, },
    ['26']={reel1=15, reel2=15, reel3=15, reel4=14, reel5=10, },
    ['27']={reel1=15, reel2=15, reel3=15, reel4=14, reel5=10, },
    ['28']={reel1=15, reel2=14, reel3=14, reel4=13, reel5=12, },
    ['29']={reel1=18, reel2=18, reel3=17, reel4=17, reel5=17, },
    ['30']={reel1=20, reel2=21, reel3=20, reel4=19, reel5=18, },
    ['31']={reel1=1, reel2=2, reel3=2, reel4=2, reel5=3, },
    ['32']={reel1=3, reel2=2, reel3=2, reel4=3, reel5=3, },
    ['33']={reel1=2, reel2=3, reel3=2, reel4=4, reel5=2, },
}

function ReelGenerater.generateReelsSymbols(col)


	local reels_distribution = {reel1=0,reel2=0,reel3=0,reel4=0,reel5=0}
	local reelssymbols_distribution = {reel1={},reel2={},reel3={},reel4={},reel5={}}
	local reelssymbols_distribution_sign = {reel1={},reel2={},reel3={},reel4={},reel5={}}

	-- body
	for k,v in pairs(symbolsDistribution) do
		for i=1,col do
			reels_distribution["reel"..tostring(i)]=reels_distribution["reel"..tostring(i)]+v["reel"..tostring(i)]
		end
	end

    math.newrandomseed()  

	local hasSymbol = true 


    local changeSameVal = function(readvals)
        -- body
        local cnt = #readvals

        local preIdx = 1
        local nextIdx = 1

        for i=2,cnt-1 do

            preIdx = i-1
            nextIdx = i+1

            if readvals[preIdx] == readvals[i] or readvals[nextIdx] == readvals[i] then

                local curIdx = i
                local changeIdx = (curIdx+3)%cnt
                local changeNextIdx = (curIdx+3+1)%cnt
                local changePreIdx = (curIdx+3-1)%cnt

                curIdx = changeIdx

                while readvals[changeIdx] == readvals[i] 
                    or readvals[changePreIdx] == readvals[i] 
                    or readvals[changeNextIdx] == readvals[i] do
                        changeIdx = (curIdx+3)%cnt
                        changeNextIdx = (curIdx+3+1)%cnt
                        changePreIdx = (curIdx+3-1)%cnt
                        curIdx = changeIdx
                end

                local temp = readvals[i]
                readvals[i] = readvals[changeIdx]
                readvals[changeIdx] = temp
            end

        end

    end

    while hasSymbol == true do

        hasSymbol = false
        for s,v in pairs(symbolsDistribution) do
            for i=1,col do
                local count = v["reel"..tostring(i)]

                if count > 0 then
                    hasSymbol = true
                    local totalCount = reels_distribution["reel"..tostring(i)]
                            
                    math.newrandom()

                    local randomval = math.floor(math.newrandom() * totalCount) + 1
                    while reelssymbols_distribution_sign["reel"..tostring(i)][randomval] == 1 do
                        randomval = math.floor(math.newrandom() * totalCount) + 1
                    end

                    reelssymbols_distribution["reel"..tostring(i)][randomval]=s
                    reelssymbols_distribution_sign["reel"..tostring(i)][randomval]=1

                    v["reel"..tostring(i)]=v["reel"..tostring(i)]-1
                end
            end
        end

    end


    
    for i,v in pairs(reelssymbols_distribution) do
        changeSameVal(v)
    end

    for i,v in pairs(reelssymbols_distribution) do

        local reelStr = tostring(i).."="
        for i=1,#v do
            reelStr=reelStr..tostring(v[i])..","
        end
    end

    return reelssymbols_distribution

end

function ReelGenerater.analysisForReels(col, machIdx, cnt)

    local reelsIdxs = DICT_MACHINE[machIdx].reels

    local reels = ReelGenerater.generateReelsSymbols(col)

    --DICT_REELS = {}

    for i=1,col do

        local reeldata = reels["reel"..tostring(i)]
        local reelidx = reelsIdxs[i]

        print("reel data:", i, reelidx)

        local reelStr = tostring(reelidx).."="
        for j=1,#reeldata do
            reelStr=reelStr..tostring(reeldata[j])..","
        end
        print(reelStr)


        DICT_REELS[tostring(reelidx)] = {
            reel_id = tostring(reelidx), 
            symbol_ids = reeldata
        }

        --table.dump(DICT_REELS[tostring(reelidx)] ,"DICT_MATCH5"..reelidx)

    end

    local ReelAnalysis = require("app.data.slots.ReelAnalysis")
    ReelAnalysis.analysis(machIdx, cnt)

end




return ReelGenerater