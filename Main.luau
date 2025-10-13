local TimeManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = require(ReplicatedStorage["TweenService"])

local RunningCooldowns = {}

type CooldownData = {
	Callback : {Success : RBXScriptSignal, Failed : RBXScriptSignal},
	Name : string,
	Time : number
}

local function ClearIfEmtpy(ID : string)
	local Store = RunningCooldowns[ID]
	if Store then
		if next(Store) == nil then
			RunningCooldowns[ID] = nil
		end
	end
end

local function RemoveCooldown(Data : {ID : string, Name : string})
	local ID = Data["ID"]
	local Store = RunningCooldowns[ID]
	if Store then
		local Cooldown = Store[Data["Name"]]
		if Cooldown then
			Cooldown["IntValue"]:Destroy()
			Store[Data["Name"]] = nil
			ClearIfEmtpy(ID)
		end
	end
end

local function IsCooldown(ID : string, Data : CooldownData)
	local Store = RunningCooldowns[ID]
	if Store then
		local Cooldown = Store[Data["Name"]]
		if Cooldown then
			return true
		end
	end
	return false
end

local function AddCooldown(ID : string, Data : CooldownData)
	local IsStored = RunningCooldowns[ID]
	
	local Callback = Data["Callback"]
	local Name = Data["Name"]
	local Time = Data["Time"]
	
	if IsStored and RunningCooldowns[ID][Name] then
		local TimeData : number = RunningCooldowns[ID][Name]
		if TimeData then
			local IntValue : IntValue = TimeData["IntValue"]
			local Cooltime : number = IntValue.Value
			local Failed = Callback["Failed"]
			return typeof(Failed) == "function" and task.defer(Failed, Cooltime) or false
		end
	else
		local Success = Callback["Success"]
		local IntValue = Instance.new("IntValue")
		IntValue.Value = Time
		TweenService:Create(IntValue, TweenInfo.new(Time, Enum.EasingStyle.Linear), {Value = 0}):Play()
		if not RunningCooldowns[ID] then
			RunningCooldowns[ID] = {}
		end
		RunningCooldowns[ID][Name] = {
			["IntValue"] = IntValue,
		}
		if typeof(Success) == "function" then
			task.defer(Success)
		end
		task.delay(Time, RemoveCooldown, {
			["ID"] = ID,
			["Name"] = Name
		})
	end
end

TimeManager.AddCooldown = AddCooldown
TimeManager.IsCooldown = IsCooldown

return TimeManager
