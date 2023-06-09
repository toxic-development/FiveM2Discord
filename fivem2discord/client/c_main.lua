function SendWebhookLogs(channel, name, message, image, dep)
    TriggerServerEvent('FiveM2Discord:SendWebhookLogs', channel, name, message, image, dep)
end

RegisterCommand("fm2dtest", function()
    TriggerServerEvent('FiveM2Discord:SendWebhookLogs', 'system', 'EXPORTS', 'Test webhook.. If you got this it worked chief!', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
end)

exports['fivem2discord']:SendWebhookLogs('system', 'EXPORTS', 'Test webhook through export.. If you got this it worked chief!', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)

Citizen.CreateThread(function()

	local DeathReason, Killer, DeathCauseHash, Weapon

	while true do

		
        Citizen.Wait(0)
		
        if IsEntityDead(PlayerPedId()) then
		
            Citizen.Wait(500)
		
            local PedKiller = GetPedSourceOfDeath(PlayerPedId())
		
            DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
		
            Weapon = WeaponNames[tostring(DeathCauseHash)]

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then

                Killer = NetworkGetPlayerIndexFromPed(PedKiller)

            elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then

                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
            end
			
			if (Killer == PlayerId()) then

                DeathReason = 'took the cowards way out and commited suicide'

            elseif (Killer == nil) then

                DeathReason = 'died of unknown causes or was killed by an admin'
			else

                if IsMelee(DeathCauseHash) then

                    DeathReason = 'murdered'

                elseif IsTorch(DeathCauseHash) then

                    DeathReason = 'torched'

                elseif IsKnife(DeathCauseHash) then

                    DeathReason = 'knifed'

                elseif IsPistol(DeathCauseHash) then

                    DeathReason = 'pistoled'

                elseif IsSub(DeathCauseHash) then

                    DeathReason = 'riddled'

                elseif IsRifle(DeathCauseHash) then

                    DeathReason = 'rifled'

                elseif IsLight(DeathCauseHash) then

                    DeathReason = 'machine gunned'

                elseif IsShotgun(DeathCauseHash) then

                    DeathReason = 'pulverized'

                elseif IsSniper(DeathCauseHash) then

                    DeathReason = 'sniped'

                elseif IsHeavy(DeathCauseHash) then

                    DeathReason = 'obliterated'

                elseif IsMinigun(DeathCauseHash) then

                    DeathReason = 'shredded'

                elseif IsBomb(DeathCauseHash) then

                    DeathReason = 'bombed'

                elseif IsVeh(DeathCauseHash) then

                    DeathReason = 'mowed over'

                elseif IsVK(DeathCauseHash) then

                    DeathReason = 'flattened'

                else

                    DeathReason = 'killed'
				end
			end
			

            if DeathReason == 'took the cowards way out and commited suicide' or DeathReason == 'died of unknown causes or was killed by an admin' then

                TriggerServerEvent('FiveM2Discord:playerDied', GetPlayerName(PlayerId()) .. ' ' .. DeathReason .. '.', Weapon)

            else

                TriggerServerEvent('FiveM2Discord:playerDied', GetPlayerName(Killer) .. ' ' .. DeathReason .. ' ' .. GetPlayerName(PlayerId()) .. '.', Weapon)
			end

            Killer = nil
            DeathReason = nil
            DeathCauseHash = nil
			Weapon = nil
		end
		
        while IsEntityDead(PlayerPedId()) do
		
            Citizen.Wait(0)
		end
	end
end)

function IsMelee(Weapon)
	
    local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsTorch(Weapon)
	
    local Weapons = {'WEAPON_MOLOTOV'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsKnife(Weapon)
	
    local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
        end
	end
	
    return false
end

function IsPistol(Weapon)
	
    local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsSub(Weapon)
	
    local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsRifle(Weapon)
	
    local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsLight(Weapon)
	
    local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
    end
	
    return false
end

function IsSniper(Weapon)
	
    local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsHeavy(Weapon)
	
    local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
        end
    end
	
    return false
end

function IsMinigun(Weapon)
	
    local Weapons = {'WEAPON_MINIGUN'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
    end
	
    return false
end

function IsBomb(Weapon)
	
    local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsVeh(Weapon)
	
    local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end

function IsVK(Weapon)
	
    local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	
    for i, CurrentWeapon in ipairs(Weapons) do
	
        if GetHashKey(CurrentWeapon) == Weapon then
	
            return true
		end
	end
	
    return false
end