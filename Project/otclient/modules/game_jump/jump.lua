jumpButton = nil

function init()
    g_ui.importStyle('jump')

    jumpButton = modules.client_topmenu.addLeftGameButton('jumpWindow', tr('Jump'), '/images/topbuttons/questlog', JumpButton)

    connect(g_game, { onGameStart = JumpButton,
                      onGameEnd = destroyWindows})
end

function terminate()
    disconnect(g_game, { onGameStart = JumpButton,
                         onGameEnd = destroyWindows})

    destroyWindows()
    jumpButton:destroy()
end

function destroyWindows()
    if jumpWindow then
        jumpWindow:destroy()
    end
end

function changePos()
    jump = jumpWindow:getChildById('jump')
    local yRandom = math.random(jumpWindow.anchors.top, jumpWindow.anchors.bottom - jump.height)
    jump.anchors.top = yRandom
end

function JumpButton()
    destroyWindows()

    jumpWindow = g_ui.createWidget('JumpWindow', rootWidget)

    jumpWindow.onDestroy = function()
        jumpWindow = nil
    end
end

