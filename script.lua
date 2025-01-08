







function init()

    -- SETUP - MAP LOADING - INIT


    
  
    arrow = LoadSprite("arrow.png")

    -- Global vars | gameplay
    PagesCollected = 0
    PagesToCollect = 8
    SlenderPages = FindBodies('SlenderPage')
    Slenderman = FindBody("Slenderman")

    IsPageAmbiencePlaying = false


    -- Global vars | sounds

    PageOneTwoSound = LoadSound("MOD/snd/pageOneTwo.ogg")
    PageThreeFourSound = LoadSound("MOD/snd/pageThreeFour.ogg")
    PageFiveSix = LoadSound("MOD/snd/pageFiveSix.ogg")
    PageSeven = LoadSound("MOD/snd/pageSeven.ogg")
    PageCollectedSound = LoadSound("MOD/snd/pagegrab.ogg")
    BirdsOneSound = LoadSound("MOD/snd/birds1.ogg")
    MentalScoutSound = LoadSound('MOD/snd/mentalScout.ogg')

    MentalElysiumShouldBePlayed = false
    -- Randomize page spawn (delete 2 pages + change their positions)

    local randomPageToDelete = math.floor(math.random(1, 10))
    local randomPageToDeleteTwo = math.floor(math.random(1, 10))
   SetBodyTransform(SlenderPages[randomPageToDelete],   Vec(0,0,0))
    SetBodyTransform(SlenderPages[randomPageToDeleteTwo],Vec(0,0,0))

    for i=1, #SlenderPages do
        if randomPageToDelete <= #SlenderPages/2 then
            if i==7 then -- if our page is 7 (gas camp next to bathrooms)
                SetBodyTransform(SlenderPages[i],Vec(86.0, 70.0 -10.0), QuatEuler(-6.4 -1.3, 25.5))
                SetPlayerTransform(Vec(86.0, 70.0 -10.0), QuatEuler(-6.4 -1.3, 25.5))
                -- DebugPrint('Set random page in gas')
            end
        end
        local t = GetBodyTransform(SlenderPages[i])
       
        if(GetBodyTransform(SlenderPages[i]) == Vec(0,0,0)) then
            -- DebugPrint('found ' .. i .. ' as deleted')
        end
        SetDescription(SlenderPages[i],"Collect")

    end

    
end

local playNow = false

local lastTime = GetTime()


function IsPlayerInRangeOfPoint(targetX, targetY, targetZ, range) 



    local playerTransform = GetPlayerTransform().pos

    local x = math.floor(playerTransform[1])
    local y = math.floor(playerTransform[2])
    local z =  math.floor(playerTransform[3])
  
    if x <=  math.floor(targetX) + range and x>=  math.floor(targetX)-range then
        if y <=  math.floor(targetY) + range and y >=  math.floor(targetY)-range then
            if z <=  math.floor(targetZ) + range and z>=  math.floor(targetZ)-range then
                return true
            end
        end
    end

    return false
end

local lastPos = nil
function tick(tr)
  
  
    -- SetPlayerTransform(slenderPos.pos)


    
    if InputDown("w") then

        local playerPos = GetPlayerTransform().pos
        local slendermanPos = GetBodyTransform(Slenderman).pos

        
        

        local sum = VecSub(playerPos,slendermanPos)

        -- DebugPrint("sum: "..sum[1].." "..sum[2].." "..sum[3].."  length: "..VecLength((sum)))

    --  DebugPrint("real point: "..lPos[1].." "..lPos[2].." "..lPos[3])

     
      
    

        -- DebugPrint("player: "..playerTransform.pos[1].." "..playerTransform.pos[2].." "..playerTransform.pos[3])

       

    end

    --Disable all tools
    local tools = ListKeys("game.tool")
    for i=1,#tools do
        local k = "game.tool."..tools[i]..".enabled"
        if GetBool(k) then
            SetBool(k, false)
        end
    end
    SetString("game.player.tool", "none")   
    

    if(GetPlayerInteractBody() ~= 0 and InputPressed('interact')) then

        PagesCollected = PagesCollected + 1
        SetBodyTransform(GetPlayerInteractBody(),Vec(0,0,0), 1)
       
        DebugPrint("Pages: "..PagesCollected.." " .. "of" .. " ".. #SlenderPages)
    end

    -- if 1 minute passes from start of the game and didnt collect,
    -- any pages, player had enough time to know the map so let's put music and let slender arrive.
    -- (original 8 pages had 2 minutes as far as I know)


    local secondsFromGameStart = math.floor(GetTime())
    
    local t = Transform(Vec(10, 0, 0), QuatEuler(0, 90, 0))
 
  
    local lastAmbienceSetTime = 0
    -- 1 second timer
    if(secondsFromGameStart-math.floor(lastTime) >= 1) then
        
        local pos = GetPlayerTransform().pos

        if IsPlayerInRangeOfPoint(-105, 5, -103, 10) then 
            mentalElysiumShouldBePlayed = true
        end

        if PagesCollected == 1 or PagesCollected == 2 then
        
            PlayMusic("MOD/snd/pageOneTwo.ogg")
            lastAmbienceSetTime = secondsFromGameStart
        end

        elseif PagesCollected == 3 or PagesCollected == 4 then
          
            PlayMusic("MOD/snd/pageThreeFour.ogg")
            lastAmbienceSetTime = secondsFromGameStart
        elseif PagesCollected == 5 or PagesCollected == 6 then
          
            PlayMusic("MOD/snd/pageFiveSix.ogg")
            lastAmbienceSetTime = secondsFromGameStart
        elseif PagesCollected == 7 then
          
            PlayMusic("MOD/snd/pageSeven.ogg")
            lastAmbienceSetTime = secondsFromGameStart
        elseif PagesCollected == 8 then
            StopMusic()
            lastAmbienceSetTime = secondsFromGameStart
        elseif PagesCollected == 0 then
            
            PlayMusic("MOD/snd/wind.ogg")
    end

    lastTime = GetTime()

    -- Ambience long is 2 minutes so we need to save how long does it play, and if it ended we need to return it back
    -- Because unfortunely API LoopSound() doesn't work with custom ones.

    
    
    local isMentalElysiumPlaying = false
    if mentalElysiumShouldBePlayed then
        if isMentalElysiumPlaying == false then
            PlaySound(MentalScoutSound, Vec(-105, 5, -103, 15), 0.5)
            DebugPrint('playing asylum')
            isMentalElysiumPlaying = true
        end
      
     
       
    end

    local currentPlayerVel = GetPlayerVelocity()
    if(currentPlayerVel[2] > 0) then
        SetPlayerVelocity(Vec(currentPlayerVel[1], 0, currentPlayerVel[3]))
        if(currentPlayerVel[1] > 10 or currentPlayerVel[3] > 10) then
            -- SetPlayerHealth(0)
        end

    end

end 