Example is down blow.

```lua
local TimeManager = require("ModuleLocation")

local function OnSuccess() -- For main your code function
	print("Attack!")
end

local function OnFailed() -- For if cooldown is on running 
	print("On cooldown!")
end

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

-- Check if cooldown exist
local OnCooldown : boolean = TimeManager.IsCooldown("SavedID", "Cooldown ID")

if OnCooldown then
	print("On Cooldown!")
else
	print("Not on cooldown.")
end
```
