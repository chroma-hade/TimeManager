Example is down below.

```lua
local TimeManager = require("ModuleLocation")

local function OnSuccess() -- For main your code function
	print("Attack!")
end

local function OnFailed(TimeLeft : number) -- For if cooldown is on running 
	print("On cooldown! Time Left: " .. TimeLeft) -- you can get cooldown time progress
end

-- Add Cooldown
TimeManager.AddCooldown("IDForSave", 
	{
		["Name"] = "Run", -- unique string name for save cooldown id
		["Time"] = .1, -- how many time need for cooldown
		["Callback"] = {
			["Success"] = OnSuccess, -- run function when cooldown is not running with name that we used
			["Failed"] = OnFailed, -- if cooldown is running 
		}
	}
)

-- Remove Cooldown
TimeManager.RemoveCooldown(
	{
		["ID"] = "SavedID",
		["Name"] = "Ability"
	}
)

-- Check if cooldown exist
local OnCooldown : boolean = TimeManager.IsCooldown("SavedID", "Cooldown ID")

if OnCooldown then
	print("On Cooldown!")
else
	print("Not on Cooldown.")
end
```
