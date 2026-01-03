DRAGONFLIGHT()

DF:NewDefaults('classtrainerframe', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('classtrainerframe', 1, function()
    local skinned = false

    local function SkinClassTrainerFrame()
        if skinned or not ClassTrainerFrame then return end
        skinned = true

        local regions = {ClassTrainerFrame:GetRegions()}
        for i = 1, table.getn(regions) do
            local region = regions[i]
            if region:GetObjectType() == 'Texture' then
                local texture = region:GetTexture()
                if texture and string.find(texture, 'ClassTrainer') then
                    region:Hide()
                end
            end
        end

        if ClassTrainerFrameCloseButton then ClassTrainerFrameCloseButton:Hide() end

        local customBg = DF.ui.CreatePaperDollFrame('DF_ClassTrainerCustomBg', ClassTrainerFrame, 384, 512, 1)
        customBg:SetPoint('TOPLEFT', ClassTrainerFrame, 'TOPLEFT', 12, -12)
        customBg:SetPoint('BOTTOMRIGHT', ClassTrainerFrame, 'BOTTOMRIGHT', -32, 60)
        customBg:SetFrameLevel(ClassTrainerFrame:GetFrameLevel() - 1)
        -- customBg:SetVertexColor(0, 0, 0, 0.5)
        -- customBg:SetAlpha(0.5)

        local topWood = customBg:CreateTexture(nil, 'BORDER')
        topWood:SetTexture(media['tex:panels:spellbook_top_wood.blp'])
        topWood:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 0, -10)
        topWood:SetPoint('RIGHT', customBg, 'RIGHT', 0, -60)
        topWood:SetSize(customBg:GetWidth()-10, 64)

        ClassTrainerFramePortrait:SetParent(customBg)
        ClassTrainerFramePortrait:SetDrawLayer('ARTWORK', 0)
        ClassTrainerFramePortrait:ClearAllPoints()
        ClassTrainerFramePortrait:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -4, 7)

        local blackBg = CreateFrame('Frame', nil, customBg)
        blackBg:SetPoint('TOPLEFT', topWood, 'BOTTOMLEFT', 2, -5)
        blackBg:SetPoint('RIGHT', customBg, 'RIGHT', -2, 0)
        blackBg:SetHeight(190)
        blackBg:SetBackdrop({
            bgFile = 'Interface\\Buttons\\WHITE8X8',
            edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
            edgeSize = 16,
            insets = {left = 5, right = 5, top = 5, bottom = 5}
        })
        blackBg:SetBackdropColor(0, 0, 0, 0.3)

        local botBg = CreateFrame('Frame', nil, customBg)
        botBg:SetPoint('TOPLEFT', blackBg, 'BOTTOMLEFT', 0, 2)
        botBg:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -2, 30)
        botBg:SetHeight(125)
        botBg:SetBackdrop({
            bgFile = 'Interface\\Buttons\\WHITE8X8',
            edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
            edgeSize = 16,
            insets = {left = 5, right = 5, top = 5, bottom = 5}
        })
        botBg:SetBackdropColor(0, 0, 0, 0.3)

        if ClassTrainerTrainButton then
            ClassTrainerTrainButton:ClearAllPoints()
            ClassTrainerTrainButton:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -90, 5)
        end

        if ClassTrainerCancelButton then
            ClassTrainerCancelButton:ClearAllPoints()
            ClassTrainerCancelButton:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -10, 5)
        end

        if ClassTrainerMoneyFrame then
            ClassTrainerMoneyFrame:ClearAllPoints()
            ClassTrainerMoneyFrame:SetPoint('RIGHT', ClassTrainerTrainButton, 'LEFT', -10, 1)
        end

        local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(ClassTrainerFrame) end)
        closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
        closeButton:SetSize(20, 20)
        closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

        tinsert(UISpecialFrames, 'DF_ClassTrainerCustomBg')
    end

    local frame = CreateFrame('Frame')
    frame:RegisterEvent('ADDON_LOADED')
    frame:SetScript('OnEvent', function()
        if arg1 == 'Blizzard_TrainerUI' then
            SkinClassTrainerFrame()
        end
    end)

    if ClassTrainerFrame then
        SkinClassTrainerFrame()
    end

    local callbacks = {}
    DF:NewCallbacks('classtrainerframe', callbacks)
end)
