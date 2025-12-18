local TimeManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RunningCooldowns = {}

type CooldownData = {
	Callback : {Success : RBXScriptSignal, Failed : RBXScriptSignal},
	Name : string,
	Time : number
}

local function ClearIfEmtpy(ID : string)
	local Store = RunningCooldowns[ID]
	if not Store or next(Store) ~= nil then
		return
	end
	RunningCooldowns[ID] = nil
end

local function RemoveCooldown(Data : {ID : string, Name : string})
	local ID = Data["ID"]
	local Store = RunningCooldowns[ID]
	if not Store then
		return
	end
	local Cooldown = Store[Data["Name"]]
	if not Cooldown then
		return
	end
	Cooldown["IntValue"]:Destroy()
	Store[Data["Name"]] = nil
	ClearIfEmtpy(ID)
end

local function IsCooldown(ID : string, Name : string)
	local Store = RunningCooldowns[ID]
	if not Store then
		return false
	end
	local Cooldown = Store[Name]
	if Cooldown then
		return true
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
		if not TimeData then
			return
		end
		local IntValue : IntValue = TimeData["IntValue"]
		local Cooltime : number = IntValue.Value
		local Failed = Callback["Failed"]
		return typeof(Failed) == "function" and task.defer(Failed, Cooltime) or false
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

TimeManager.IsCooldown = IsCooldown
TimeManager.AddCooldown = AddCooldown
TimeManager.RemoveCooldown = RemoveCooldown

return TimeManager
