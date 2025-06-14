local QBCore = exports['qb-core']:GetCoreObject()

-- Variables
drugRunActive = false

-- Hand Off Anim
local handOffAnim = "mp_common"
    RequestAnimDict(handOffAnim)
    while (not HasAnimDictLoaded(handOffAnim)) do
    Citizen.Wait(1)
    end


-- Ped
CreateThread(function()
  local model = Config.Ped
  RequestModel(model)
  while not HasModelLoaded(model) do Wait(0) end
  local ped = CreatePed(0, model, Config.PedCoords, true, false)

  FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
  TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)

  exports['qb-target']:AddTargetEntity(ped, {
    options = {
      {
        num = 1,
        type = "client",
        event = "npc:openDialog",
        icon = "fas fa-comments",
        label = Config.TargetMessage,
        targeticon = "fas fa-user",
        action = function(entity)
          openMenu()
        end,
        canInteract = function(entity, distance, data)
          return not IsPedAPlayer(entity)
        end,

      }
    },
    distance = 2.0
  })
end)

-- Functions
function openMenu()
  exports['qb-menu']:openMenu({
    { 
        header = "Start Run", 
        txt = "Start drug delivery",
        isMenuHeader = false,
        action = function()
           startRun()
        end
    },
      { 
        header = "Cancel Run", 
        txt = "Cancel your current delivery",
        isMenuHeader = false,
        action = function()
           cancelRun()
        end
    },
    {
        header = "Reputation:", 
        txt = lib.callback.await("sam-drugrun:server:getrep"),
        disabled = true
    }
       
}, false, false)
end

function startRun()
  local carModel = Config.CarModel
  RequestModel(carModel)
  while not HasModelLoaded(carModel) do Wait(0) end
  
  if drugRunActive == false then
    -- Drug Run Start

    local rep = lib.callback.await("sam-drugrun:server:getrep")

    drugRunActive = true


    TriggerServerEvent("sam-drugrun:givepackage")
  
    QBCore.Functions.Notify("Deliver package to specfied location on your map!")

    -- Blip
    
    
    local deliveryCoordinates = nil

    if rep < Config.RepThreshold then 
      local deliveryCoordinates = Config.LowRepDeliveryCoords[math.random(1, #Config.LowRepDeliveryCoords)]
      createBlip(deliveryCoordinates)
    createDeliveryPed(deliveryCoordinates)
    else if rep > Config.RepThreshold then
      local deliveryCoordinates = Config.HighRepDeliveryCoords[math.random(1, #Config.HighRepDeliveryCoords)]
      createBlip(deliveryCoordinates)
      createDeliveryPed(deliveryCoordinates)
    end
  end
    

    
  else if drugRunActive == true then
      QBCore.Functions.Notify('A run is already active!', 'error', 5000)
  end
  end
  
end

function cancelRun()
  if drugRunActive == true then
    local currentRep = lib.callback.await("sam-drugrun:server:getrep")
    DeleteEntity(drugrunCar)
    drugRunActive = false
    QBCore.Functions.Notify("Drug run cancelled!", "error", 5000)
    RemoveBlip(deliveryBlip)
    deleteDeliveryPed()
    TriggerServerEvent("sam-drugrun:removepackage")
    TriggerServerEvent("sam-drugrun:server:setRep", currentRep-(Config.RepGiveRange))
  else
    QBCore.Functions.Notify("A run is currently not active!", "error", 5000)
  end
  
end

function completeHandOff()
  local currentRep = lib.callback.await("sam-drugrun:server:getrep")
  local handoffParticipants = {
    deliveryPed,
    PlayerPedId()
  }

  TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(),-1)

  TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, 1.0, -1, 48, 0.001, false, false, false)
  TaskPlayAnim(deliveryPed, 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 48, 0.001, false, false, false)

  Citizen.Wait(3000)
  QBCore.Functions.Notify("Delivery completed!", "success", 5000)
  SetPedAsNoLongerNeeded(deliveryPed)
  RemoveBlip(deliveryBlip)
  TriggerServerEvent("sam-drugrun:removepackage")

  drugRunActive = false

  TriggerServerEvent("sam-drugrun:server:setRep", currentRep+(Config.RepGiveRange))
  handOffReward()
  TriggerServerEvent('police:server:policeAlert', 'Drug sale in progress')
end

function createDeliveryPed(coords)
  CreateThread(function()
  local rep = lib.callback.await("sam-drugrun:server:getrep")
  pedModel = nil
  
    
    if rep < Config.RepThreshold then 
      pedModel = Config.LowRepDeliveryPeds

    else if rep > Config.RepThreshold then
      pedModel = Config.HighRepDeliveryPeds

    end
  end
  

  local deliveryPedModel = pedModel[math.random(1, #pedModel)]

  RequestModel(deliveryPedModel)
  while not HasModelLoaded(deliveryPedModel) do Wait(0) end
  deliveryPed = CreatePed(0, deliveryPedModel, coords, false, false)

	SetEntityInvincible(deliveryPed, true)
	SetBlockingOfNonTemporaryEvents(deliveryPed, true)

  exports['qb-target']:AddTargetEntity(deliveryPed, {
    options = {
      {
        num = 1,
        type = "client",
        label = "Hand over package...",
        targeticon = "fas fa-user",
        action = function(entity)
          completeHandOff()
        end,
        canInteract = function(entity, distance, data)
          return not IsPedAPlayer(entity)
        end,

      }
    },
    distance = 2.0
  })
end)
end

function handOffReward()
  local currentRep = lib.callback.await("sam-drugrun:server:getrep")

  if currentRep < Config.RepThreshold then 
      TriggerServerEvent("sam-drugrun:rewardLow")

    else if currentRep > Config.RepThreshold then
      TriggerServerEvent("sam-drugrun:rewardHigh")

    end
  end
end


function deleteDeliveryPed()
  DeleteEntity(deliveryPed)
end

function createBlip(coords)
Citizen.CreateThread(function()                                                   
deliveryBlip = AddBlipForCoord(coords)
SetBlipScale(deliveryBlip, 1.0)
SetBlipSprite(deliveryBlip, 51)
SetBlipColour(deliveryBlip, 5)
SetBlipAsShortRange(deliveryBlip, true)
AddTextEntry("DRUG_RUN", "Drug Run Delivery")
BeginTextCommandSetBlipName("DRUG_RUN")
EndTextCommandSetBlipName(deliveryBlip)
SetBlipCategory(deliveryBlip, 138)
SetBlipRoute(deliveryBlip, true)
  end)
end
