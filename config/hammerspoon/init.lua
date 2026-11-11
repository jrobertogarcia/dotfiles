-- GNOME-style Super+N for macOS: Option+1..9 launches / focuses / cycles apps.
require("hs.ipc") -- enables the `hs` CLI (e.g. `hs -c "hs.reload()"`)

hs.window.animationDuration = 0

-- Bundle IDs, not names: VS Code runs as "Code", so a name lookup misses it and
-- falls through to a slow launchOrFocus search.
local APP_MAP = {
    [1] = "com.google.Chrome",
    [2] = "com.anthropic.claudefordesktop",
    [3] = "com.microsoft.VSCode",
    [4] = "com.tinyspeck.slackmacgap",
    [5] = "com.mitchellh.ghostty",
    [6] = "com.apple.finder",
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

-- Ctrl+Option+Shift+Left/Right carries the focused window to the adjacent Space by
-- holding its title bar while switching Spaces.
-- hs.spaces.moveWindowToSpace silently does nothing for other apps' windows on macOS 27.
local MouseEvent = hs.eventtap.event
local MouseTypes = MouseEvent.types
-- macOS 27 drops a synthetic drag whose events don't share one kCGMouseEventNumber;
-- start above the real HID counter, as PaperWM.spoon and OpenJDK's Robot do.
local mouseEventNumber = 32000

local function mouseEvent(kind, pos, number, dx, dy)
    MouseEvent.newMouseEvent(kind, pos):rawFlags(0)
        :setProperty(MouseEvent.properties.mouseEventNumber, number)
        :setProperty(MouseEvent.properties.mouseEventClickState, 1)
        :setProperty(MouseEvent.properties.mouseEventDeltaX, dx or 0)
        :setProperty(MouseEvent.properties.mouseEventDeltaY, dy or 0)
        :post()
end

local moveTimer -- holds the in-flight move's timer so it isn't garbage-collected

local function moveWindowToSpace(direction)
    local win = hs.window.focusedWindow()
    if not win or moveTimer or not win:isStandard() or win:isFullScreen() then return end
    local startSpace = (hs.spaces.windowSpaces(win) or {})[1]
    local frame = win:frame()
    -- Just up-left of the zoom button is title-bar drag area, even in Chrome's tab strip.
    local zoom = win:zoomButtonRect()
    local grab = zoom and { x = zoom.x - 1, y = zoom.y - 1 }
        or { x = frame.x + 90, y = frame.y + 5 }
    local cursor = hs.mouse.absolutePosition()
    mouseEventNumber = mouseEventNumber + 1
    local n = mouseEventNumber

    MouseEvent.newMouseEvent(MouseTypes.mouseMoved, grab):rawFlags(0):post()
    mouseEvent(MouseTypes.leftMouseDown, grab, n)
    -- macOS 27 ignores a motionless hold, so nudge out and back: the window
    -- counts as dragged but sits at its original spot during the animation.
    for _, dx in ipairs({ 3, 3, 3, -3, -3, -3 }) do
        hs.timer.usleep(15000)
        grab.x = grab.x + dx
        mouseEvent(MouseTypes.leftMouseDragged, grab, n, dx, 0)
    end
    switchSpace(direction)

    -- Drop as soon as the window lands; give up after 1s (e.g. already at the last Space).
    local deadline = hs.timer.secondsSinceEpoch() + 1
    moveTimer = hs.timer.doEvery(0.02, function()
        local space = (hs.spaces.windowSpaces(win) or {})[1]
        if space == startSpace and hs.timer.secondsSinceEpoch() < deadline then return end
        moveTimer:stop()
        mouseEvent(MouseTypes.leftMouseUp, grab, n)
        hs.mouse.absolutePosition(cursor)
        win:focus()
        -- Apps finish the drag after the drop and can land a few pixels off.
        moveTimer = hs.timer.doAfter(0.15, function()
            moveTimer = nil
            if not win:frame():equals(frame) then win:setFrame(frame) end
        end)
    end)
end

local MOVE_MODS = { "ctrl", "alt", "shift" }
hs.hotkey.bind(MOVE_MODS, "left", function() moveWindowToSpace("left") end)
hs.hotkey.bind(MOVE_MODS, "right", function() moveWindowToSpace("right") end)

hs.alert.show("Hammerspoon config loaded")
