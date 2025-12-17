UNLOCKAURORA()

local setup = AU.setups.unitframes
AU:NewDefaults('unitframes', setup:GenerateDefaults())

AU:NewModule('unitframes', 1, 'PLAYER_LOGIN', function()
    local playerPortrait = setup:CreateUnitFrame('player', 180, 70)
    playerPortrait:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 45, -30)

    local targetPortrait = setup:CreateUnitFrame('target', 180, 70)
    targetPortrait:SetPoint('LEFT', playerPortrait, 'RIGHT', 50, 0)

    local totPortrait = setup:CreateUnitFrame('targettarget', 180, 70)
    totPortrait:SetPoint('TOPLEFT', targetPortrait, 'BOTTOMRIGHT', -10, -0)

    local petPortrait = setup:CreateUnitFrame('pet', 180, 70)
    petPortrait:SetPoint('TOPLEFT', playerPortrait, 'BOTTOMLEFT', 10, -20)

    local petTargetPortrait = setup:CreateUnitFrame('pettarget', 180, 70)
    petTargetPortrait:SetPoint('TOPLEFT', petPortrait, 'BOTTOMRIGHT', 10, 0)

    for i = 1, 4 do
        local partyFrame = setup:CreateUnitFrame('party'..i, 180, 70)
        if i == 1 then
            partyFrame:SetPoint('TOPLEFT', UIParent, 'LEFT', 10, 170)
        else
            partyFrame:SetPoint('TOPLEFT', setup.portraits[table.getn(setup.portraits)-1], 'BOTTOMLEFT', 0, -10)
        end
    end

    AU.common.KillFrame(PlayerFrame)
    AU.common.KillFrame(TargetFrame)
    AU.common.KillFrame(PetFrame)
    AU.common.KillFrame(PartyMemberFrame1)
    AU.common.KillFrame(PartyMemberFrame2)
    AU.common.KillFrame(PartyMemberFrame3)
    AU.common.KillFrame(PartyMemberFrame4)

    setup:OnUpdate()
    setup:OnEvent()

    playerPortrait.hpBar.max = UnitHealthMax('player')
    playerPortrait.hpBar:SetValue(UnitHealth('player'))
    playerPortrait.powerBar.max = UnitManaMax('player')
    playerPortrait.powerBar:SetValue(UnitMana('player'))
    setup:UpdateNameText(playerPortrait)
    setup:UpdateLevelColor(playerPortrait)

    local callbacks = setup:GenerateCallbacks()
    AU:NewCallbacks('unitframes', callbacks)
end)
