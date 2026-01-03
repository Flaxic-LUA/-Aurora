DRAGONFLIGHT()

function DF.mixins.HideMinimizeMaximizeButton()
    if DF.others.server ~= 'turtle' then return end

    if WorldMapFrameMinimizeButton then
        WorldMapFrameMinimizeButton:Hide()
    end
end

function DF.mixins.IsCollectorException(buttonName)
    if DF.others.server ~= 'turtle' then return false end
    return buttonName == 'EBC_Minimap' or buttonName == 'TWMiniMapBattlefieldFrame'
end

function DF.mixins.AddInspectTalentTab(customBg)
    if DF.others.server ~= 'turtle' then return end

    if InspectFrameTab3 then
        InspectFrameTab3:Hide()
    end

    local talentTab = customBg:AddTab('Talent', function()
        InspectFrame_ShowSubFrame('InspectTalentFrame')
    end, 60)

    local function UpdateTalentTab()
        if InspectFrame.unit and UnitLevel(InspectFrame.unit) >= 10 then
            talentTab:Show()
        else
            talentTab:Hide()
        end
    end

    DF.hooks.HookScript(InspectFrame, 'OnShow', UpdateTalentTab, true)
    InspectFrame:RegisterEvent('UNIT_LEVEL')
    DF.hooks.HookScript(InspectFrame, 'OnEvent', function()
        if event == 'UNIT_LEVEL' and arg1 == InspectFrame.unit then
            UpdateTalentTab()
        end
    end, true)
end
