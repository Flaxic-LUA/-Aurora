-- UNLOCKDRAGONFLIGHT()

-- DF:NewDefaults('inspect', {
--     enabled = {value = true},
--     version = {value = '1.0'},
-- })

-- DF:NewModule('inspect', 1, function()
--     local frames = {InspectPaperDollFrame, InspectHonorFrame}
--     for _, frame in frames do
--         if frame then
--             local regions = {frame:GetRegions()}
--             for i = 1, table.getn(regions) do
--                 local region = regions[i]
--                 if region:GetObjectType() == 'Texture' then
--                     local texture = region:GetTexture()
--                     if texture and (string.find(texture, 'UI%-Character') or string.find(texture, 'PaperDollInfoFrame')) then
--                         region:Hide()
--                     end
--                 end
--             end
--         end
--     end

--     InspectFrameTab1:Hide()
--     InspectFrameTab2:Hide()
--     InspectFrameCloseButton:Hide()

--     local customBg = DF.ui.CreatePaperDollFrame('DF_InspectCustomBg', InspectFrame, 384, 512, 1)
--     customBg:SetPoint('TOPLEFT', InspectFrame, 'TOPLEFT', 12, -12)
--     customBg:SetPoint('BOTTOMRIGHT', InspectFrame, 'BOTTOMRIGHT', -32, 75)
--     customBg:SetFrameLevel(InspectFrame:GetFrameLevel() + 1)
--     customBg.Bg:SetDrawLayer('BACKGROUND', -1)

--     InspectFramePortrait:SetParent(customBg)
--     InspectFramePortrait:SetDrawLayer('BORDER', 0)

--     local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(InspectFrame) end)
--     closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
--     closeButton:SetSize(20, 20)
--     closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

--     customBg:AddTab('Character', function()
--         InspectFrame_ShowSubFrame('InspectPaperDollFrame')
--     end, 70)

--     customBg:AddTab('Honor', function()
--         InspectFrame_ShowSubFrame('InspectHonorFrame')
--     end, 75)

--     DF.mixins.AddInspectTalentTab(customBg)

--     tinsert(UISpecialFrames, 'DF_InspectCustomBg')

--     local callbacks = {}
--     DF:NewCallbacks('inspect', callbacks)
-- end)
