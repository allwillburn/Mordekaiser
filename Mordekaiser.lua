local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Mordekaiser" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Mordekaiser/master/Mordekaiser.lua', SCRIPT_PATH .. 'Mordekaiser.lua', function() PrintChat('<font color = "#00FFFF">Warwick Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No Mordekaiser updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Warwick/master/Mordekaiser.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local MordekaiserMenu = Menu("Mordekaiser", "Mordekaiser")

WarwickMenu:SubMenu("Combo", "Combo")

MordekaiserMenu.Combo:Boolean("Q", "Use Q in combo", true)
MordekaiserMenu.Combo:Boolean("W", "Use W in combo", true)
MordekaiserMenu.Combo:Boolean("E", "Use E in combo", true)
MordekaiserMenu.Combo:Boolean("R", "Use R in combo", true)
MordekaiserMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
MordekaiserMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
MordekaiserMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
MordekaiserMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
MordekaiserMenu.Combo:Boolean("RHydra", "Use RHydra", true)
MordekaiserMenu.Combo:Boolean("THydra", "Use THydra", true)
MordekaiserMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
MordekaiserMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
MordekaiserMenu.Combo:Boolean("Randuins", "Use Randuins", true)


MordekaiserMenu:SubMenu("AutoMode", "AutoMode")
MordekaiserMenu.AutoMode:Boolean("Level", "Auto level spells", false)
MordekaiserMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
MordekaiserMenu.AutoMode:Boolean("Q", "Auto Q", false)
MordekaiserMenu.AutoMode:Boolean("W", "Auto W", false)
MordekaiserMenu.AutoMode:Boolean("E", "Auto E", false)
MordekaiserMenu.AutoMode:Boolean("R", "Auto R", false)

MordekaiserMenu:SubMenu("LaneClear", "LaneClear")
MordekaiserMenu.LaneClear:Boolean("Q", "Use Q", true)
MordekaiserMenu.LaneClear:Boolean("W", "Use W", true)
MordekaiserMenu.LaneClear:Boolean("E", "Use E", true)
MordekaiserMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
MordekaiserMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

MordekaiserMenu:SubMenu("Harass", "Harass")
MordekaiserMenu.Harass:Boolean("Q", "Use Q", true)
MordekaiserMenu.Harass:Boolean("W", "Use W", true)

MordekaiserMenu:SubMenu("KillSteal", "KillSteal")
MordekaiserMenu.KillSteal:Boolean("Q", "KS w Q", true)
MordekaiserMenu.KillSteal:Boolean("E", "KS w E", true)

MordekaiserMenu:SubMenu("AutoIgnite", "AutoIgnite")
MordekaiserMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

MordekaiserMenu:SubMenu("Drawings", "Drawings")
MordekaiserMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

MordekaiserMenu:SubMenu("SkinChanger", "SkinChanger")
MordekaiserMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
MordekaiserMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
         local THydra = GetItemSlot(myHero, 3748)
		
	--AUTO LEVEL UP
	if MordekaiserMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if MordekaiserMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastSpell(_Q)
                                end
            end

            if MordekaiserMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if MordekaiserMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if MordekaiserMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if MordekaiserMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if MordekaiserMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if MordekaiserMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 675) then
			 CastSkillShot(_E, target)
	    end

            if MordekaiserMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastSpell(_Q)
                                end
              end

            if MordekaiserMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if MordekaiserMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if MordekaiserMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end
			
	    if MordekaiserMenu.Combo.THydra:Value() and THydra > 0 and Ready(THydra) and ValidTarget(target, 400) then
			CastSpell(THydra)
            end	

	    if MordekaiserMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSpell(_W)
	    end
	    
	    
            if MordekaiserMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= MordekaiserMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and MordekaiserMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSpell(_Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 675) and MordekaiserMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if MordekaiserMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 700) then
	        	CastSpell(_Q)
                end

                if MordekaiserMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastSpell(_W)
	        end

                if MordekaiserMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 675) then
	        	CastSkillShot(_E, target)
	        end

                if MordekaiserMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if MordekaiserMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if MordekaiserMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 700) then
		      CastSpell(_Q)
          end
        end 
        if MordekaiserMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastSpell(_W)
          end
        end
        if MordekaiserMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 675) then
		      CastSkillShot(_E, target)
	  end
        end
        if MordekaiserMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if WarwickMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if MordekaiserMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 700, 0, 200, GoS.Red)
	end

end)





local function SkinChanger()
	if MordekaiserMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Mordekaiser</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





