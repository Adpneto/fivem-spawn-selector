local cam = nil
local new = false
local weight = 270.0
local config = {
	["praca"] = { 310.62,-231.46,54.03 },
	["vespucci"] = { 1037.77,-765.61,57.98 },
	["poleto"] = { 450.12,-662.3,28.47 },
	["hospital"] = { 55.46,-880.18,30.36 }
}

RegisterNetEvent("vrp_login:Spawn")
AddEventHandler("vrp_login:Spawn",function(status)
	local ped = PlayerPedId()
	if status then
		local x,y,z = table.unpack(GetEntityCoords(ped))

		cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",x,y,z+200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(cam,true)
		SetEntityInvincible(ped,false) --MQCU
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)
		RenderScriptCams(true,false,1,true,true)

		SetNuiFocus(true,true)
		SendNUIMessage({ display = true })
	else
		DoScreenFadeOut(500)
		Citizen.Wait(500)
		SetEntityInvincible(ped,false)
		FreezeEntityPosition(ped,false)
		SetEntityVisible(ped,true,false)
		RenderScriptCams(false,false,0,true,true)
		SetCamActive(cam,false)
		DestroyCam(cam,true)
		DoScreenFadeIn(500)
	end
	TriggerEvent("ToogleBackCharacter")
end)

RegisterNUICallback("spawn",function(data)
	local ped = PlayerPedId()
	if data.choice == "spawn" then
		SetNuiFocus(false)
		SendNUIMessage({ display = false })

		DoScreenFadeOut(500)
		Citizen.Wait(500)

		SetEntityInvincible(ped,false)
		FreezeEntityPosition(ped,false)
		SetEntityVisible(ped,true,false)

		RenderScriptCams(false,false,0,true,true)
		SetCamActive(cam,false)
		DestroyCam(cam,true)

		DoScreenFadeIn(500)
    else
    	new = false
		local speed = 0.7

		DoScreenFadeOut(500)
		Citizen.Wait(500)

		SetCamRot(cam,270.0)
		SetCamActive(cam,true)
		new = true
		weight = 270.0

		DoScreenFadeIn(500)

		SetEntityCoords(ped,config[data.choice][1],config[data.choice][2],config[data.choice][3],0,0,0,0)
		local x,y,z = table.unpack(GetEntityCoords(ped))

		SetCamCoord(cam,x,y,z+200.0)
		local i = z + 200.0

		while i > config[data.choice][3] + 1.5 do
			Citizen.Wait(5)
			i = i - speed
			SetCamCoord(cam,x,y,i)

			if i <= config[data.choice][3] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(cam,weight)
			end

			if not new then
				break
			end
		end
	end
end)