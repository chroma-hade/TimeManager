Example is down blow.

```lua
local TimeManager = require("ModuleLocation")

local function OnSuccess()
	print("Attack!")
end

local function OnFailed()
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
```
