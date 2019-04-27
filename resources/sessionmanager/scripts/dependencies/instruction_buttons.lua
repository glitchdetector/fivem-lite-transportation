--[[
    INSTRUCTION BUTTONS
    BY ILLUSIVETEA
    GITHUB https://gist.github.com/IllusiveTea/c9e33f678586b02f68315c7ca3ceec33
]]

local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform, data)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    for n, btn in next, data do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(n-1)
        Button(GetControlInstructionalButton(2, btn[2], true))
        ButtonMessage(btn[1])
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

local form = nil
local data = {}

function SetInstructions(inst)
    form = nil
    if not inst then
        inst = {}
    end
    if not GetUserConfig("hud_disable_instructions", false) then
        if not CruiseControl.enabled then
            table.insert(inst, {"Cruise Control", 20})
        else
            table.insert(inst, {"Disable Cruise Control", 20})
        end
        table.insert(inst, {"Settings", 167})
        table.insert(inst, {"Tips", 168})
    end

    form = setupScaleform("instructional_buttons", inst)
end

Citizen.CreateThread(function()
    while true do
        if form then
            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
        end
        Wait(0)
    end
end)
