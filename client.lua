local QBCore = nil
CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Wait(100)
    end
end)

-- https://www.youtube.com/watch?v=hI0Q7IPWjOk Funny innit
local isitonornot = false
local curRadius = 0.5
local whodarespass = false

CreateThread(function()
    Wait(500)
    QBCore.Functions.TriggerCallback("mojito_polytool:getpermission", function(permission)
        if permission == "admin" or permission == "god" then
            whodarespass = true
        end
    end)
end)

RegisterNetEvent("mojito_pedzones:open")
AddEventHandler("mojito_pedzones:open", function(radius)
    if radius then
        isitonornot = true
        curRadius = radius ~= nil and radius or 0.5
    else
        isitonornot = false
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if whodarespass then
            if isitonornot then
                local ped = PlayerPedId()
                local pedCoords = GetEntityCoords(ped)
                local hit, hitCoords = RayCastGamePlayCamera(20.0)

                if hit ~= 0 then
                    DrawLine(pedCoords.x, pedCoords.y, pedCoords.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 255, 255, 1.0)
                    DrawSphere(hitCoords.x, hitCoords.y, hitCoords.z, curRadius, 255, 255, 255, 0.7)

                    if IsControlJustPressed(0, 47) then
                        SendNUIMessage({
                            coords = tostring(hitCoords)
                        })
                    end
                end
            else
                Wait(1000)
            end
        else
            Wait(5000)
        end
    end
end)

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local _, b, c, _, _ = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c
end