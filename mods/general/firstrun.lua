DRAGONFLIGHT()
if not dependency('UnitXP') then return end

DF:NewDefaults('firstrun', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('firstrun', 1, function()
    local charKey = UnitName('player') .. '-' .. GetRealmName()
    DF_Profiles.meta.secondInstallShown = DF_Profiles.meta.secondInstallShown or {}
    if DF_Profiles.meta.secondInstallShown[charKey] then return end

    local installFrame = DF.ui.CreatePaperDollFrame('DF_InstallPanel', UIParent, 400, 400, 1)
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

    local subtitle = DF.ui.Font(contentFrame, 14, 'BETA PHASE GUIDELINES', {1, 0.5, 0}, 'CENTER')
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

    local block1 = DF.ui.Font(contentFrame, 12, '|cffff8000BETA BUILD|r - Expect bugs and frequent changes.', {1, 1, 1}, 'LEFT')
    block1:SetPoint('CENTER', contentFrame, 'TOP', 0, -70)

    local block2 = DF.ui.Font(contentFrame, 12, '|cffffcc00Bug Reports:|r\n\n- You must use |cffffcc00/df safeboot|r before reporting.\n- This proves the bug is caused by Dragonflight only.\n- Focus on stability and polish during beta.', {1, 1, 1}, 'LEFT')
    block2:SetPoint('TOPLEFT', block1, 'BOTTOMLEFT', 0, -20)

    local block3 = DF.ui.Font(contentFrame, 12, '|cffffcc00Please report:|r\n\n- Addon conflicts if reproducible with /df safeboot.\n- Any stability or performance issues.', {1, 1, 1}, 'LEFT')
    block3:SetPoint('TOPLEFT', block2, 'BOTTOMLEFT', 0, -20)

    local block4 = DF.ui.Font(contentFrame, 12, 'So |cffffcc00UPDATE frequently|r or |cffffcc00suffer|r,\n\nGuzruul.', {1, 1, 1}, 'CENTER')
    block4:SetPoint('BOTTOM', contentFrame, 'BOTTOM', 0, 60)

    -- local function ApplyProfile(profileName)
    --     local profile = DF.tables.profiles[profileName]
    --     for option, value in pairs(profile) do
    --         for module, _ in pairs(DF.defaults) do
    --             if DF.defaults[module][option] then
    --                 DF:SetConfig(module, option, value)
    --             end
    --         end
    --     end

    --     local posData = profile.positions
    --     for i = 1, table.getn(posData) do
    --         local data = posData[i]
    --         local f = getglobal(data[1])
    --         f:ClearAllPoints()
    --         f:SetPoint(data[2], data[3], data[4], data[5], data[6])
    --         DF.setups.SaveFramePosition(f)
    --     end
    -- end

    -- local dragonflightBtn = DF.ui.Button(contentFrame, 'Dragonflight', 100, 30)
    -- dragonflightBtn:SetPoint('BOTTOM', contentFrame, 'BOTTOM', -125, 8)
    -- dragonflightBtn:SetScript('OnClick', function()
    --     ApplyProfile('Dragonflight')
    -- end)

    -- local pfuiBtn = DF.ui.Button(contentFrame, 'Pfui', 100, 30)
    -- pfuiBtn:SetPoint('BOTTOM', contentFrame, 'BOTTOM', 125, 8)
    -- pfuiBtn:SetScript('OnClick', function()
    --     ApplyProfile('Pfui')
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
end)
