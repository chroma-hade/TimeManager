# TimeManager

Cooldowns for Roblox! Give one to a character, a player or just a name, and ask later whether it's done. One ModuleScript, under 100 lines.

## Getting it

Grab `TimeManager.rbxm` from the [releases page](https://github.com/chroma-hade/TimeManager/releases) and put it anywhere you can require it from, like `ReplicatedStorage.Packages`.

If you use Wally, add it to your `wally.toml`:

```toml
[dependencies]
TimeManager = "chroma-hade/timemanager@1.0.0"
```

Or just copy `src/init.luau` into your project.

## Using it

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TimeManager = require(ReplicatedStorage.Packages.TimeManager)
TimeManager.SetCooldown(Character, { ID = "Dash", Time = 2 })
```

That puts `Dash` on cooldown for two seconds. Check it before letting the dash happen again:

```lua
if TimeManager.IsOnCooldown(Character, "Dash") then
    return
end
```

`GetCooldown` gives you the seconds left instead, or `0` once it's done. Handy for a timer on a button.

The owner can be any Instance or a string, so a cooldown can belong to one character, one player, or the whole server, like `"Airdrop"`.

It works on the server and on the client, but each side keeps its own cooldowns. For anything players shouldn't be able to skip, check on the server!

## When it runs out

Hand it an `OnFinished` function and it runs the moment the cooldown is over.

```lua
TimeManager.SetCooldown(Character, {
    ID = "Ultimate",
    Time = 30,
    OnFinished = function()
        print("Ultimate is ready!")
    end,
})
```

Setting the same cooldown again restarts it, and only the newest `OnFinished` runs.

## Ending it early

```lua
TimeManager.ClearCooldown(Character, "Dash")
TimeManager.ResetCooldown(Character)
```

`ClearCooldown` ends one cooldown, and `ResetCooldown` ends every cooldown that owner has. Neither runs `OnFinished`.

Cooldowns clean themselves up once they run out, so there's nothing to tidy afterwards☆

## Everything

That's the whole API!

| | |
|---|---|
| `TimeManager.SetCooldown(Owner, Data)` | Starts a cooldown. `Data` takes `ID`, `Time` and an optional `OnFinished` |
| `TimeManager.GetCooldown(Owner, ID)` | Seconds left, or `0` |
| `TimeManager.IsOnCooldown(Owner, ID)` | Whether it's still going |
| `TimeManager.ClearCooldown(Owner, ID)` | Ends one cooldown |
| `TimeManager.ResetCooldown(Owner)` | Ends every cooldown that owner has |

## License

MIT, so go wild☆ Just keep the license file around.
