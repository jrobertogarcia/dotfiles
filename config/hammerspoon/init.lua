-- GNOME-style Super+N for macOS: Option+1..9 launches / focuses / cycles apps.
require("hs.ipc") -- enables the `hs` CLI (e.g. `hs -c "hs.reload()"`)

hs.window.animationDuration = 0

-- Bundle IDs, not names: VS Code runs as "Code", so a name lookup misses it and
-- falls through to a slow launchOrFocus search.
local APP_MAP = {
    [1] = "com.google.Chrome",
    [2] = "com.anthropic.claudefordesktop",
    [3] = "com.todesktop.230313mzl4w4u92",
    [4] = "com.microsoft.VSCode",
    [5] = "com.tinyspeck.slackmacgap",
    [6] = "com.mitchellh.ghostty",
    [7] = "com.apple.finder",
}

-- Apps where Cmd+N reliably opens a new window when none exist.
local NEW_WINDOW_ON_EMPTY = {
    ["com.apple.finder"] = true,
    ["com.google.Chrome"] = true,
    ["com.mitchellh.ghostty"] = true,
}

-- Current-Space windows of `app`, front-to-back. Only used when cycling.
local function eligibleWindows(app)
    local pid = app:pid()
    local wins = {}
    for _, win in ipairs(hs.window.orderedWindows()) do
        local owner = win:application()
        if owner and owner:pid() == pid
            and win:isStandard() and win:isVisible() and not win:isMinimized() then
            wins[#wins + 1] = win
        end
    end
    return wins
end

local function newWindow(app)
    app:activate()
    hs.eventtap.keyStroke({ "cmd" }, "n", 0, app)
end

local function launchOrCycle(bundleID)
    local app = hs.application.get(bundleID)

    if not app then
        if not hs.application.launchOrFocusByBundleID(bundleID) then
            hs.alert.show("Could not launch " .. bundleID)
        end
        return "launch"
    end

    if not app:isFrontmost() then
        -- macOS switches Spaces itself (Mission Control: "switch to a space with
        -- open windows for the application").
        app:activate()
        return "activate"
    end

    local wins = eligibleWindows(app)
    if #wins > 1 then
        wins[#wins]:focus() -- least recently used => rotates through all windows
        return "cycle"
    elseif #wins == 0 then
        if NEW_WINDOW_ON_EMPTY[bundleID] then
            newWindow(app)
        else
            hs.application.launchOrFocusByBundleID(bundleID) -- triggers reopen, restoring a window
        end
        return "reopen"
    end
    return "noop"
end

for n, bundleID in pairs(APP_MAP) do
    hs.hotkey.bind({ "alt" }, tostring(n), function() launchOrCycle(bundleID) end)
end

-- GNOME-style Option+scroll: mouse wheel switches Spaces via the Mission Control
-- "Move left/right a space" shortcuts (Ctrl+Left/Right). Trackpad scrolls pass through.
-- Global, not local: a local eventtap gets garbage-collected and stops firing.
local SCROLL = hs.eventtap.event.properties
local lastSpaceSwitch = 0

-- Arrow keys need the fn flag (as on a real keyboard); hs.eventtap.keyStroke omits it
-- and the shortcut then fires only intermittently.
local function switchSpace(key)
    for _, down in ipairs({ true, false }) do
        hs.eventtap.event.newKeyEvent(key, down):setFlags({ ctrl = true, fn = true }):post()
    end
end

spaceScrollTap = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, function(e)
    local f = e:getFlags()
    if not (f.alt and not (f.cmd or f.ctrl or f.shift)) then return false end
    if e:getProperty(SCROLL.scrollWheelEventIsContinuous) ~= 0 then return false end
    local dy = e:getProperty(SCROLL.scrollWheelEventDeltaAxis1)
    if dy == 0 then return true end
    local now = hs.timer.secondsSinceEpoch()
    if now - lastSpaceSwitch > 0.25 then -- one switch per notch burst
        lastSpaceSwitch = now
        switchSpace(dy > 0 and "left" or "right")
    end
    return true
end):start()

-- GNOME-style Super+arrows on Ctrl+Option (plain Option+arrows is word/paragraph nav):
-- Left/Right snap to halves, Up maximizes, Down restores the pre-snap frame.
local SNAP_MODS = { "ctrl", "alt" }
local preSnapFrames = {} -- window id -> frame before the first snap; lost on reload

local function snap(unit)
    local win = hs.window.focusedWindow()
    if not win then return end
    preSnapFrames[win:id()] = preSnapFrames[win:id()] or win:frame()
    win:moveToUnit(unit)
end

hs.hotkey.bind(SNAP_MODS, "left", function() snap({ 0, 0, 0.5, 1 }) end)
hs.hotkey.bind(SNAP_MODS, "right", function() snap({ 0.5, 0, 0.5, 1 }) end)
hs.hotkey.bind(SNAP_MODS, "up", function() snap({ 0, 0, 1, 1 }) end)
hs.hotkey.bind(SNAP_MODS, "down", function()
    local win = hs.window.focusedWindow()
    local frame = win and preSnapFrames[win:id()]
    if not frame then return end
    win:setFrame(frame)
    preSnapFrames[win:id()] = nil
end)

hs.alert.show("Hammerspoon config loaded")
