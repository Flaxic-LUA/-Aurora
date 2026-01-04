DRAGONFLIGHT()

DF:NewDefaults('map', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('map', 1, 'PLAYER_ENTERING_WORLD',function()
    UIPanelWindows['WorldMapFrame'] = { area = 'center' }

    local regions = {WorldMapFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'UI%-WorldMap') then
                region:Hide()
            end
        elseif region:GetObjectType() == 'FontString' then
            local text = region:GetText()
            if text and text == WORLD_MAP then
                region:Hide()
            end
        end
    end

    WorldMapFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_MapCustomBg', WorldMapFrame, 1024, 768, 2)
    customBg:SetPoint('TOPLEFT', WorldMapFrame, 'TOPLEFT', 0, 0)
    customBg:SetPoint('BOTTOMRIGHT', WorldMapFrame, 'BOTTOMRIGHT', 0, 0)
    customBg:SetFrameLevel(WorldMapFrame:GetFrameLevel())
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)

    local title = customBg:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
    title:SetPoint('TOP', customBg, 'TOP', 0, -6)
    title:SetText(WORLD_MAP)

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(WorldMapFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    tinsert(UISpecialFrames, 'DF_MapCustomBg')

    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    WorldMapFrame:SetWidth(WorldMapButton:GetWidth() + 15)
    WorldMapFrame:SetHeight(WorldMapButton:GetHeight() + 100)

    DF.hooks.HookScript(WorldMapFrame, 'OnShow', function()
        WorldMapFrame:SetScale(0.7)
        this:EnableKeyboard(false)

    end, true)

    WorldMapFrame:SetMovable(true)
    WorldMapFrame:EnableMouse(true)
    WorldMapFrame:RegisterForDrag('LeftButton')
    WorldMapFrame:SetScript('OnDragStart', function()
        WorldMapFrame:StartMoving()
    end)
    WorldMapFrame:SetScript('OnDragStop', function()
        WorldMapFrame:StopMovingOrSizing()
    end)

    BlackoutWorld:Hide()

    DF.mixins.HideMinimizeMaximizeButton()

    WorldMapZoneDropDown:ClearAllPoints()
    WorldMapZoneDropDown:SetPoint('LEFT', WorldMapContinentDropDown, 'RIGHT', 20, 0)

    local continentRegions = {WorldMapContinentDropDown:GetRegions()}
    for i = 1, table.getn(continentRegions) do
        local region = continentRegions[i]
        if region and region:GetObjectType() == 'FontString' then
            local text = region:GetText()
            if text and text == CONTINENT then
                region:ClearAllPoints()
                region:SetPoint('RIGHT', WorldMapContinentDropDown, 'LEFT', 0, 0)
                break
            end
        end
    end

    local zoneRegions = {WorldMapZoneDropDown:GetRegions()}
    for i = 1, table.getn(zoneRegions) do
        local region = zoneRegions[i]
        if region and region:GetObjectType() == 'FontString' then
            local text = region:GetText()
            if text and text == ZONE then
                region:ClearAllPoints()
                region:SetPoint('RIGHT', WorldMapZoneDropDown, 'LEFT', 0, 0)
                break
            end
        end
    end

    local callbacks = {}
    DF:NewCallbacks('map', callbacks)
end)
