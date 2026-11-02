local TimeManager = {}

local HttpService = game:GetService("HttpService")

local TimeStore: { [Instance | string]: { [string]: CooldownData } } = {}

type CooldownData = {
	UUID: string,
	EndTick: number
}

type SetData = {
	ID: string,
	Time: number,
	OnFinished: (() -> ())?
}

function TimeManager.SetCooldown(Owner: Instance | string, SetData: SetData)
	local Store = TimeStore[Owner]
	if not Store then
		Store = {}
		TimeStore[Owner] = Store
	end

	local UUID = HttpService:GenerateGUID()
	Store[SetData.ID] = {
		UUID = UUID,
		EndTick = tick() + SetData.Time
	}

	task.delay(SetData.Time, function()
		local Data = Store[SetData.ID]
		if not TimeStore[Owner] or not Data or Data.UUID ~= UUID then
			return
		end

		Store[SetData.ID] = nil

		if not next(Store) then
			TimeStore[Owner] = nil
		end

		if SetData.OnFinished then
			SetData.OnFinished()
		end
	end)
end

function TimeManager.GetCooldown(Owner: Instance | string, ID: string): number
	local Store = TimeStore[Owner]
	if not Store then
		return 0
	end
	local Data = Store[ID]
	if not Data then
		return 0
	end
	return math.max(Data.EndTick - tick(), 0)
end

function TimeManager.IsOnCooldown(Owner: Instance | string, ID: string): boolean
	return TimeManager.GetCooldown(Owner, ID) > 0
end

function TimeManager.ClearCooldown(Owner: Instance | string, ID: string)
	local Store = TimeStore[Owner]
	if not Store then
		return
	end
	Store[ID] = nil
	if not next(Store) then
		TimeStore[Owner] = nil
	end
end

function TimeManager.ResetCooldown(Owner: Instance | string)
	local Store = TimeStore[Owner]
	if not Store then
		return
	end
	table.clear(Store)
	TimeStore[Owner] = nil
end

return TimeManager