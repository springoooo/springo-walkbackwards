Config = {}

-- Change keybind here as you wish. Note that keybinding can be edited in FiveM settings.
Config.BackwardModifierKey = "J" 

-- DO NOT TOUCH THIS IF YOU DO NOT KNOW WHAT YOU ARE DOING (unless you have crazily rebinded your WASD keys)
Config.Controls = {
    S = 33,
    A = 34,
    D = 35
}

-- DO NOT TOUCH THIS IF YOU DO NOT KNOW WHAT YOU ARE DOING! 
Config.AnimationSpeed = 5.0
Config.AnimationSpeedMultiplier = 1.0
Config.AnimationDuration = -1
Config.AnimationFlag = 1
Config.AnimationPlaybackRate = 0.1
-- Increased speed for sprinting
Config.SprintAnimationSpeed = 20.0 
 -- Increased speed multiplier for sprinting
Config.SprintAnimationSpeedMultiplier = 2.5
-- Enable ragdolling of the player (to simulate tripping over) when walking in backwards for too long? True = Yes, False = No.
Config.EnableRagdoll = true
-- Time in milliseconds (10 seconds) before the player trips from walking in backwards. Must have Config.EnableRagdoll set to true.
Config.TripTime = 10000 

-- DO NOT TOUCH THIS IF YOU DO NOT KNOW WHAT YOU ARE DOING! 
Config.AnimationDict = "move_strafe@first_person@generic"

-- DO NOT TOUCH THIS IF YOU DO NOT KNOW WHAT YOU ARE DOING! 
Config.Animations = {
    BACKWARD = {
        name = "walk_bwd_180_loop"
    },
    BACKWARD_LEFT = {
        name = "walk_bwd_-135_loop"
    },
    BACKWARD_RIGHT = {
        name = "walk_bwd_135_loop"
    },
    LEFT = {
        name = "walk_bwd_-90_loop"
    },
    RIGHT = {
        name = "walk_fwd_90_loop"
    }
}

-- KEEP THIS FALSE! Only edit for extended functionality.
Config.AllowInVehicle = false
-- KEEP THIS FALSE! Only edit for extended functionality. 
Config.AllowInFirstPerson = false
-- Higher number = less CPU usage, but less smooth animation.
Config.UpdateInterval = 0 -- milliseconds between checks (0 for every frame)
-- Debug mode ,only enable while in testing.
Config.DebugMode = true