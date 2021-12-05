#include "./components/slenderman.lua"







function init()

    -- SETUP - MAP LOADING - INIT




    -- Global vars | gameplay
    PagesCollected = 0
    PagesToCollect = 8
    SlenderPages = FindBodies('SlenderPage')
    IsPageAmbiencePlaying = false

    -- Global vars | sounds

    PageOneTwoSound = LoadSound("MOD/snd/pageOneTwo.ogg")
    PageThreeFourSound = LoadSound("MOD/snd/pageThreeFour.ogg")
    PageFiveSix = LoadSound("MOD/snd/pageFiveSix.ogg")
    PageSeven = LoadSound("MOD/snd/pageSeven.ogg")
    PageCollectedSound = LoadSound("MOD/snd/pagegrab.ogg")
    BirdsOneSound = LoadSound("MOD/snd/birds1.ogg")

    -- Randomize page spawn (so we delete 1 page from each category)

    

    local randomPageToDelete = math.floor(math.random(1, 8))
    SetBodyTransform(SlenderPages[randomPageToDelete],Vec(0,0,0))
    if randomPageToDelete > 1 and randomPageToDelete < #SlenderPages then
        SetBodyTransform(SlenderPages[randomPageToDelete+1],Vec(0,0,0))
        DebugPrint('Removed additional page: '..randomPageToDelete+1 .. " max bodies: "..#SlenderPages)
    end
    
    DebugPrint('Removed page: '..randomPageToDelete .. " max bodies: "..#SlenderPages)

    for i=1, #SlenderPages do
        if randomPageToDelete <= #SlenderPages/2 then
            if i==7 then -- if our page is 7 (gas camp next to bathrooms)
                SetBodyTransform(SlenderPages[i],Vec(86.0, 70.0 -10.0), Vec(-6.4 -1.3, 25.5))
                DebugPrint('Set random page in gas')
            end
        end
        SetDescription(SlenderPages[i],"Collect")
        DebugPrint(i.. "  "..SlenderPages[i])
    end

    
end

local playNow = false

local lastTime = GetTime()

function tick(tr)

    SetPlayerGroundVelocity(Vec(2,0,0))
    --Disable all tools
    local tools = ListKeys("game.tool")
    for i=1,#tools do
        local k = "game.tool."..tools[i]..".enabled"
        if GetBool(k) then
            SetBool(k, false)
        end
    end
    SetString("game.player.tool", "none")   

    if(GetPlayerInteractBody() and InputPressed('interact')) then

        PagesCollected = PagesCollected + 1
        SetBodyTransform(GetPlayerInteractBody(),Vec(0,0,0), 1)
       
        DebugPrint("Pages: "..PagesCollected.."  "..GetPlayerInteractBody())
    end

    -- if 1 minute passes from start of the game and didnt collect,
    -- any pages, player had enough time to know the map so let's put music and let slender arrive.
    -- (original 8 pages had 2 minutes as far as I know)


    local secondsFromGameStart = math.floor(GetTime())
    

  
    local lastAmbienceSetTime = 0
    -- 1 second timer
    if(secondsFromGameStart-math.floor(lastTime) >= 1) then
        
      
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
        
            
          
            DebugPrint(secondsFromGameStart .. " pages: " ..PagesCollected)
    
      
    end

    lastTime = GetTime()

    -- Ambience long is 2 minutes so we need to save how long does it play, and if it ended we need to return it back
    -- Because unfortunely API LoopSound() doesn't work with custom ones.
  
    

    local currentPlayerVel = GetPlayerVelocity()
    if(currentPlayerVel[2] > 0) then
        SetPlayerVelocity(Vec(currentPlayerVel[1], 0, currentPlayerVel[3]))
        if(currentPlayerVel[1] > 10 or currentPlayerVel[3] > 10) then
            -- SetPlayerHealth(0)
        end

    end

  

    

    if playNow == false then
     
      
      
        PlaySound(BirdsOneSound,GetPlayerTransform(),100)
        playNow = true
        DebugPrint('sound true')
    else
       
     
    end

    
 

end 