```
local TimeManager = require("ModuleLocation")

local function OnSuccess()
	print("Attack!")
end

local function OnFailed()
	print("On cooldown!")
end

TimeManager.AddCooldown("IDForSave", 
	{
		["Name"] = "Run",
		["Time"] = .1,
		["Callback"] = {
			["Success"] = OnSuccess,
			["Failed"] = OnFailed,
		}
	}
)
```
