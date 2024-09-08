local isBackwardModifierActive = false
local backwardWalkingStartTime = 0

local function playAnimation(ped, animName, isSprinting)
    local anim = Config.Animations[animName]
    if anim then
        local speed = isSprinting and Config.SprintAnimationSpeed or Config.AnimationSpeed
        local speedMultiplier = isSprinting and Config.SprintAnimationSpeedMultiplier or Config.AnimationSpeedMultiplier
        TaskPlayAnim(ped, Config.AnimationDict, anim.name, speed, speedMultiplier, Config.AnimationDuration, Config.AnimationFlag, Config.AnimationPlaybackRate)
    end
end

local function stopAllAnimations(ped)
    for _, anim in pairs(Config.Animations) do
        StopAnimTask(ped, Config.AnimationDict, anim.name, 2.0)
    end
end

local function CanWalkBackwards()
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped, false)
    local inFirstPerson = GetFollowPedCamViewMode() == 4

    return (Config.AllowInVehicle or not inVehicle) and (Config.AllowInFirstPerson or not inFirstPerson)
end

local function triggerRagdoll()
    if not Config.EnableRagdoll then return end
    local ped = PlayerPedId()
    SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false)
    
    --local forwardVector = GetEntityForwardVector(ped)
    --ApplyForceToEntity(ped, 1, -forwardVector.x * 10.0, -forwardVector.y * 10.0, 0.0, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
    
    if Config.DebugMode then
        print("Player tripped after walking backwards for too long")
    end
end

local function handleBackwardMovement()
    local ped = PlayerPedId()
    backwardWalkingStartTime = GetGameTimer()
    
    CreateThread(function()
        while isBackwardModifierActive do
            if not CanWalkBackwards() then
                isBackwardModifierActive = false
                stopAllAnimations(ped)
                if Config.DebugMode then
                    print("Backward movement stopped: Player not eligible")
                end
                break
            end

            local isSprinting = IsControlPressed(0, 21) -- Left Shift key
            local isMovingBackward = false

            if IsControlPressed(0, Config.Controls.S) then
                isMovingBackward = true
                if IsControlPressed(0, Config.Controls.A) then
                    playAnimation(ped, "BACKWARD_LEFT", isSprinting)
                    while isBackwardModifierActive and IsControlPressed(0, Config.Controls.S) and IsControlPressed(0, Config.Controls.A) and CanWalkBackwards() do Wait(Config.UpdateInterval) end
                elseif IsControlPressed(0, Config.Controls.D) then
                    playAnimation(ped, "BACKWARD_RIGHT", isSprinting)
                    while isBackwardModifierActive and IsControlPressed(0, Config.Controls.S) and IsControlPressed(0, Config.Controls.D) and CanWalkBackwards() do Wait(Config.UpdateInterval) end
                else
                    playAnimation(ped, "BACKWARD", isSprinting)
                    while isBackwardModifierActive and IsControlPressed(0, Config.Controls.S) and not IsControlPressed(0, Config.Controls.A) and not IsControlPressed(0, Config.Controls.D) and CanWalkBackwards() do Wait(Config.UpdateInterval) end
                end
            elseif IsControlPressed(0, Config.Controls.A) then
                playAnimation(ped, "LEFT", isSprinting)
                while isBackwardModifierActive and IsControlPressed(0, Config.Controls.A) and not IsControlPressed(0, Config.Controls.S) and CanWalkBackwards() do Wait(Config.UpdateInterval) end
            elseif IsControlPressed(0, Config.Controls.D) then
                playAnimation(ped, "RIGHT", isSprinting)
                while isBackwardModifierActive and IsControlPressed(0, Config.Controls.D) and not IsControlPressed(0, Config.Controls.S) and CanWalkBackwards() do Wait(Config.UpdateInterval) end
            end
            
            if isMovingBackward and (GetGameTimer() - backwardWalkingStartTime) > Config.TripTime then
                triggerRagdoll()
                isBackwardModifierActive = false
                break
            end
            
            if not isMovingBackward then
                backwardWalkingStartTime = GetGameTimer()
            end
            
            stopAllAnimations(ped)
            Wait(Config.UpdateInterval)
        end
    end)
end

RegisterCommand('+backwardModifier', function()
    if CanWalkBackwards() then
        isBackwardModifierActive = true
        if Config.DebugMode then
            print("Backward modifier activated")
        end
        handleBackwardMovement()
    elseif Config.DebugMode then
        print("Backward modifier not activated: Player not eligible")
    end
end, false)

RegisterCommand('-backwardModifier', function()
    isBackwardModifierActive = false
    if Config.DebugMode then
        print("Backward modifier deactivated")
    end
end, false)

RegisterKeyMapping('+backwardModifier', 'Walk Backwards (Hold)', 'keyboard', Config.BackwardModifierKey)

if Config.DebugMode then
    print("Backward movement script loaded with configuration:")
    for k, v in pairs(Config) do
        if type(v) ~= "table" then
            print(k .. ": " .. tostring(v))
        else
            print(k .. ": " .. json.encode(v))
        end
    end
end