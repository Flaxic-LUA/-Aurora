UNLOCKDRAGONFLIGHT()

DF:NewDefaults('firstrun', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('firstrun', 1, function()
    local charName = UnitName('player')
    local realmName = GetRealmName()
    local charKey = charName .. '-' .. realmName

    DF_Profiles.meta.secondInstallShown = DF_Profiles.meta.secondInstallShown or {}

    if not DF_Profiles.meta.secondInstallShown[charKey] then
        local installFrame = DF.ui.CreatePaperDollFrame('DF_InstallPanel', UIParent, 450, 400, 1)
        installFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
        installFrame:SetFrameStrata('HIGH')
        installFrame:EnableMouse(true)

        local logo = installFrame:CreateTexture(nil, 'ARTWORK')
        logo:SetTexture(media['tex:interface:logo.blp'])
        logo:SetSize(64, 64)
        logo:SetPoint('TOPLEFT', installFrame, 'TOPLEFT', -7, 10)

        local title = DF.ui.Font(installFrame, 12, info.addonNameColor, {1, 1, 1}, 'CENTER')
        title:SetPoint('TOP', installFrame, 'TOP', 0, -5)

        local contentFrame = CreateFrame('Frame', nil, installFrame)
        contentFrame:SetPoint('TOPLEFT', installFrame, 'TOPLEFT', 20, -20)
        contentFrame:SetPoint('BOTTOMRIGHT', installFrame, 'BOTTOMRIGHT', -20, 10)
        -- debugframe(contentFrame)

        local subtitle = DF.ui.Font(contentFrame, 14, 'ALPHA PHASE GUIDELINES', {1, 0, 0}, 'CENTER')
        subtitle:SetPoint('TOP', contentFrame, 'TOP', 0, -20)

        local decorLeft = contentFrame:CreateTexture(nil, 'ARTWORK')
        decorLeft:SetTexture(media['tex:bags:expand.tga'])
        decorLeft:SetSize(16, 16)
        decorLeft:SetPoint('RIGHT', subtitle, 'LEFT', -5, 0)

        local decorRight = contentFrame:CreateTexture(nil, 'ARTWORK')
        decorRight:SetTexture(media['tex:bags:expand.tga'])
        decorRight:SetSize(16, 16)
        decorRight:SetPoint('LEFT', subtitle, 'RIGHT', 5, 0)
        decorRight:SetTexCoord(1, 0, 0, 1)

        local block1 = DF.ui.Font(contentFrame, 12, '|cffff0000ALPHA BUILD|r - Expect bugs, missing features and frequent changes.', {1, 1, 1}, 'LEFT')
        block1:SetPoint('CENTER', contentFrame, 'TOP', 0, -70)

        local block2 = DF.ui.Font(contentFrame, 12, '|cffffcc00Bug Reports:|r\n\n- You must use |cffffcc00/df safeboot|r before reporting.\n- This proves the bug is caused by Dragonflight only.\n- Focus on core functionality during alpha.', {1, 1, 1}, 'LEFT')
        block2:SetPoint('TOPLEFT', block1, 'BOTTOMLEFT', 0, -20)

        local block3 = DF.ui.Font(contentFrame, 12, '|cffffcc00Please Do NOT:|r\n\n- Report addon conflicts or compatibility issues.\n- Ask for advanced features.', {1, 1, 1}, 'LEFT')
        block3:SetPoint('TOPLEFT', block2, 'BOTTOMLEFT', 0, -20)

        local block4 = DF.ui.Font(contentFrame, 12, '|cffffcc00Update frequently|r and |cffffcc00enjoy|r!\n\nGuzruul.', {1, 1, 1}, 'CENTER')
        block4:SetPoint('BOTTOM', contentFrame, 'BOTTOM', 0, 60)









        -- local function ApplyProfile(profileName)
        --     local profile = DF.tables.profiles[profileName]
        --     if profile then
        --         for option, value in pairs(profile) do
        --             if option == 'framePositions' then
        --                 DF.profile['editmode']['framePositions'] = value
        --                 for name, pos in pairs(value) do
        --                     local frame = getglobal(name)
        --                     if frame then
        --                         frame:ClearAllPoints()
        --                         if pos.parent and pos.rx and pos.ry then
        --                             local parent = getglobal(pos.parent)
        --                             if parent then
        --                                 frame:SetPoint('CENTER', parent, 'CENTER', pos.rx, pos.ry)
        --                             end
        --                         elseif pos.x and pos.y then
        --                             frame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', pos.x, pos.y)
        --                         end
        --                     end
        --                 end
        --             else
        --                 for module, _ in pairs(DF.defaults) do
        --                     if DF.defaults[module][option] and DF.callbacks[module .. '.' .. option] then
        --                         DF:SetConfig(module, option, value)
        --                     end
        --                 end
        --             end
        --         end
        --     end
        -- end

        -- local auroraBtn = DF.ui.Button(installFrame, 'DF_', 100, 30)
        -- auroraBtn:SetPoint('BOTTOM', installFrame, 'BOTTOM', -55, 60)
        -- auroraBtn:SetScript('OnClick', function()
        --     ApplyProfile('DF_')
        -- end)

        -- local dragonflightBtn = DF.ui.Button(installFrame, 'Dragonflight', 100, 30)
        -- dragonflightBtn:SetPoint('BOTTOM', installFrame, 'BOTTOM', 55, 60)
        -- dragonflightBtn:SetScript('OnClick', function()
        --     ApplyProfile('Dragonflight')
        -- end)

        local countdown = 15
        local okBtn = DF.ui.Button(contentFrame, countdown..'', 100, 30)
        okBtn:SetPoint('BOTTOM', contentFrame, 'BOTTOM', 0, 8)
        okBtn:Disable()

        DF.timers.every(1, function()
            countdown = countdown - 1
            if countdown > 0 then
                okBtn.text:SetText(countdown)
            else
                okBtn.text:SetText('OK')
                okBtn:Enable()
                return true
            end
        end)

        okBtn:SetScript('OnClick', function()
            DF_Profiles.meta.secondInstallShown[charKey] = true
            installFrame:Hide()
        end)
    end

    -- callbacks
    local callbacks = {}
    DF:NewCallbacks('firstrun', callbacks)
end)
