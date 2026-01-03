DRAGONFLIGHT()

DF:NewDefaults('nocontrol', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'extras', subtab = 'nocontrol', 'General', 'Appearance', 'Size', 'Font'},
    },

    showInterrupts = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Show available interrupt spells'}},
    interruptIconOnly = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Show only interrupt icon (hide text)', dependency = {key = 'showInterrupts', state = true}}},
    showSpellName = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Show spell name'}},
    showSpellLabel = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 4, description = 'Show spell label (Stunned!, Rooted!, etc.)'}},
    showBackground = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 5, description = 'Show frame background'}},
    showCC = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 1, description = 'Show stuns (CC)'}},
    showDisorient = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 2, description = 'Show disorients'}},
    showIncap = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 3, description = 'Show incapacitates'}},
    showSilence = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 4, description = 'Show silences'}},
    showFear = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 5, description = 'Show fears'}},
    showCharm = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 6, description = 'Show charms'}},
    showSleep = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 7, description = 'Show sleep effects'}},
    showRoot = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 8, description = 'Show roots'}},
    showSnare = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 9, description = 'Show snares/slows'}},
    showGlow = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 10, description = 'Show glow effect'}},
    disableGlowAnimation = {value = false, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 11, description = 'Disable glow pulse animation', dependency = {key = 'showGlow', state = true}}},
    frameScale = {value = 1, metadata = {element = 'slider', category = 'Size', indexInCategory = 1, description = 'Frame scale', min = 0.5, max = 2, stepSize = 0.1}},
    backgroundAlpha = {value = 0.5, metadata = {element = 'slider', category = 'Size', indexInCategory = 2, description = 'Background opacity', min = 0, max = 1, stepSize = 0.05}},
    spellIconSize = {value = 50, metadata = {element = 'slider', category = 'Size', indexInCategory = 3, description = 'Spell icon size', min = 20, max = 100, stepSize = 5}},
    interruptIconSize = {value = 30, metadata = {element = 'slider', category = 'Size', indexInCategory = 4, description = 'Interrupt icon size', min = 15, max = 60, stepSize = 5}},
    spellFontSize = {value = 14, metadata = {element = 'slider', category = 'Font', indexInCategory = 1, description = 'Spell name/label font size', min = 8, max = 24, stepSize = 1}},
    interruptFontSize = {value = 12, metadata = {element = 'slider', category = 'Font', indexInCategory = 2, description = 'Interrupt font size', min = 8, max = 24, stepSize = 1}},
    spellFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Font', indexInCategory = 3, description = 'Spell name/label font', options = media.fonts}},
    interruptFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Font', indexInCategory = 4, description = 'Interrupt font', options = media.fonts}},
})

-- module info:
-- /script for t=1,3 do for i=1,GetNumTalents(t) do local n,_,_,_,r=GetTalentInfo(t,i) if n=='Improved Sprint' then DEFAULT_CHAT_FRAME:AddMessage(t..' '..i..' '..r) end end end
-- POUNCE BLEED EXCEPTION: Debuff lasts 18s (2s stun + 16s bleed), but we only show frame during stun phase.
-- Solution: Set display duration to 2s in FindHighestPriorityDebuff, store timestamp when shown, hide frame in OnUpdate after 2s elapsed.
-- This prevents frame from displaying during the bleed-only phase while maintaining normal behavior for actual stun duration.

DF:NewModule('nocontrol', 1, function()
    local libdebuff = DF.lib.libdebuff
    local GetPlayerBuffTexture = GetPlayerBuffTexture
    local GetPlayerBuffTimeLeft = GetPlayerBuffTimeLeft
    local GetSpellName = GetSpellName
    local GetSpellCooldown = GetSpellCooldown
    local GetSpellTexture = GetSpellTexture
    local GetTime = GetTime
    local GetNumSpellTabs = GetNumSpellTabs
    local GetSpellTabInfo = GetSpellTabInfo

    local CC = 'CC'
    local SILENCE = 'Silence'
    local ROOT = 'Root'
    local SNARE = 'Snare'
    local SLEEP = 'Sleep'
    local FEAR = 'Fear'
    local CHARM = 'Charm'
    local INCAP = 'Incap'
    local DISORIENT = 'Disorient'

    local spells = {
        -- rogue
        ['Blind'] = {type = DISORIENT},
        ['Cheap Shot'] = {type = CC},
        ['Gouge'] = {type = CC},
        ['Kidney Shot'] = {type = CC},
        ['Sap'] = {type = INCAP},
        ['Kick - Silenced'] = {type = SILENCE},
        ['Crippling Poison'] = {type = SNARE},
        -- mage
        ['Polymorph'] = {type = CC},
        ['Polymorph: Turtle'] = {type = CC},
        ['Polymorph: Pig'] = {type = CC},
        ['Polymorph: Cow'] = {type = CC},
        ['Polymorph: Chicken'] = {type = CC},
        ['Counterspell - Silenced'] = {type = SILENCE},
        ['Impact'] = {type = CC},
        ['Blast Wave'] = {type = SNARE},
        ['Frostbite'] = {type = ROOT},
        ['Frost Nova'] = {type = ROOT},
        ['Frostbolt'] = {type = SNARE},
        ['Cone of Cold'] = {type = SNARE},
        ['Chilled'] = {type = SNARE},
        -- shaman
        ['Frostbrand Attack'] = {type = SNARE},
        ['Frost Shock'] = {type = SNARE},
        ['Earthbind'] = {type = SNARE},
        -- warrior
        ['Charge Stun'] = {type = CC},
        ['Intercept Stun'] = {type = CC},
        ['Revenge Stun'] = {type = CC},
        ['Concussion Blow'] = {type = CC},
        ['Intimidating Shout'] = {type = FEAR},
        ['Piercing Howl'] = {type = SNARE},
        ['Shield Bash - Silenced'] = {type = SILENCE},
        -- warlock
        ['Pyroclasm'] = {type = CC},
        ['Inferno Effect'] = {type = CC},
        ['Inferno'] = {type = CC},
        ['Curse of Exhaustion'] = {type = SNARE},
        ['Aftermath'] = {type = SNARE},
        ['Cripple'] = {type = SNARE},
        ['Death Coil'] = {type = FEAR},
        ['Fear'] = {type = FEAR},
        ['Howl of Terror'] = {type = FEAR},
        ['Seduction'] = {type = CHARM},
        ['Spell Lock'] = {type = SILENCE},
        -- paladin
        ['Hammer of Justice'] = {type = CC},
        ['Repentance'] = {type = CC},
        -- priest
        ['Mind Control'] = {type = CHARM},
        ['Psychic Scream'] = {type = FEAR},
        ['Blackout'] = {type = CC},
        ['Silence'] = {type = SILENCE},
        ['Mind Flay'] = {type = SNARE},
        -- druid
        ['Bash'] = {type = CC},
        ['Pounce Bleed'] = {type = CC}, -- v1 TODO: requires exception due to tooltipscanning issue, works for now tho...
        ['Starfire Stun'] = {type = CC},
        ['Hibernate'] = {type = SLEEP},
        ['Entangling Roots'] = {type = ROOT},
        ['Feral Charge Effect'] = {type = ROOT},
        -- hunter
        ['Intimidation'] = {type = CC},
        ['Scatter Shot'] = {type = CC},
        ['Improved Concussive Shot'] = {type = CC},
        ['Freezing Trap Effect'] = {type = CC},
        ['Freezing Trap'] = {type = CC},
        ['Wyvern Sting'] = {type = SLEEP},
        ['Scare Beast'] = {type = FEAR},
        ['Frost Trap Aura'] = {type = ROOT},
        ['Frost Trap'] = {type = ROOT},
        ['Entrapment'] = {type = ROOT},
        ['Counterattack'] = {type = ROOT},
        ['Improved Wing Clip'] = {type = ROOT},
        ['Boar Charge'] = {type = ROOT},
        ['Concussive Shot'] = {type = SNARE},
        ['Wing Clip'] = {type = SNARE},
        -- other sources
        ['War Stomp'] = {type = CC},
        ['Tidal Charm'] = {type = CC},
        ['Mace Stun Effect'] = {type = CC},
        ['Stun'] = {type = CC},
        ['Reckless Charge'] = {type = CC},
        ['Charge'] = {type = CC},
        ['Sleep'] = {type = SLEEP},
        ['Gnomish Mind Control Cap'] = {type = CHARM},
        ['Freeze'] = {type = ROOT},
        ['Dazed'] = {type = SNARE},
        ['Chill'] = {type = SNARE},
    }

    local typeConfig = {
        [CC] = {label = 'Stunned!', color = {1, 0, 0}, priority = 1},
        [DISORIENT] = {label = 'Disoriented!', color = {0.9, 0.6, 0.2}, priority = 2},
        [INCAP] = {label = 'Incapacitated!', color = {1, 0.5, 0}, priority = 3},
        [SILENCE] = {label = 'Silenced!', color = {0.5, 0, 1}, priority = 4},
        [FEAR] = {label = 'Feared!', color = {0.8, 0, 0.8}, priority = 5},
        [CHARM] = {label = 'Charmed!', color = {1, 0.4, 0.7}, priority = 6},
        [SLEEP] = {label = 'Asleep!', color = {0.5, 0.5, 1}, priority = 7},
        [ROOT] = {label = 'Rooted!', color = {0, 0.5, 1}, priority = 8},
        [SNARE] = {label = 'Slowed!', color = {1, 1, 0}, priority = 9},
    }

    local interrupts = {
        -- paladin (special handling due to forbeadance/shared CDs)
        ['Blessing of Freedom'] = {name = 'Blessing of Freedom', breaks = {ROOT, SNARE}, priority = 1},
        ['Blessing of Protection'] = {name = 'Blessing of Protection', breaks = {CC, INCAP, SILENCE, FEAR, CHARM, SLEEP, ROOT, SNARE}, priority = 3, sharedCooldown = 'Forbearance'},
        ['Divine Shield'] = {name = 'Divine Shield', breaks = {CC, DISORIENT, INCAP, SILENCE, FEAR, CHARM, SLEEP, ROOT, SNARE}, priority = 3, sharedCooldown = 'Forbearance'},
        ['Divine Protection'] = {name = 'Divine Protection', breaks = {CC, DISORIENT, INCAP, SILENCE, FEAR, CHARM, SLEEP, ROOT, SNARE}, priority = 3, sharedCooldown = 'Forbearance'},
        -- mage
        ['Blink'] = {name = 'Blink', breaks = {CC, ROOT}, priority = 1}, -- 20s
        ['Ice Block'] = {name = 'Ice Block', breaks = {CC, DISORIENT, INCAP, SILENCE, FEAR, CHARM, SLEEP, ROOT, SNARE}, priority = 3}, -- 5min
        -- rogue (special handling due to sprint talent)
        ['Vanish'] = {name = 'Vanish', breaks = {ROOT, SNARE}, priority = 2}, -- 3min
        ['Sprint'] = {name = 'Sprint', breaks = {ROOT, SNARE}, priority = 3, requireTalent = {2, 9}}, -- 4min
        -- warrior
        ['Berserker Rage'] = {name = 'Berserker Rage', breaks = {FEAR, CHARM, SLEEP}, priority = 1},
        -- druid
        ['Travel Form'] = {name = 'Travel Form', breaks = {SLEEP, ROOT, SNARE}, priority = 1},
        -- racials
        ['Escape Artist'] = {name = 'Escape Artist', breaks = {ROOT, SNARE}, priority = 1}, -- 1min
        ['Will of the Forsaken'] = {name = 'Will of the Forsaken', breaks = {CHARM, FEAR, SLEEP}, priority = 2}, -- 2min
        -- items
        ['Insignia of the Alliance'] = {name = 'PvP Trinket', breaks = {CC, DISORIENT, INCAP, FEAR, CHARM, SLEEP}, priority = 4, isItem = true},
        ['Insignia of the Horde'] = {name = 'PvP Trinket', breaks = {CC, DISORIENT, INCAP, FEAR, CHARM, SLEEP}, priority = 4, isItem = true},
    }

    local spellSlotCache = {}
    local trinketSlotCache = {}
    local sharedCooldowns = {}
    local currentSpellID = nil
    local pounceBleedShowTime = nil
    local glowAlpha = 1
    local glowDirection = -1

    local frame = CreateFrame('Frame', 'DF_NoControlFrame', UIParent)
    frame:SetSize(256, 64)
    frame:SetPoint('CENTER', 0, 0)
    frame:RegisterEvent('PLAYER_AURAS_CHANGED')
    frame:RegisterEvent('UNIT_AURA')
    frame:Hide()

    local bg = frame:CreateTexture(nil, 'BACKGROUND')
    bg:SetAllPoints(frame)
    bg:SetTexture(media['tex:generic:nocontrol_bg.blp'])
    bg:SetVertexColor(1, 1, 1, 1)

    local iconFrame = CreateFrame('Frame', 'NoControlIcon', frame)
    iconFrame:SetPoint('CENTER', 0, 0)

    local iconTexture = iconFrame:CreateTexture(nil, 'BACKGROUND')
    iconTexture:SetAllPoints(iconFrame)

    local cooldown = CreateFrame('Model', 'NoControlCooldown', iconFrame, 'CooldownFrameTemplate')
    cooldown:SetAllPoints(iconFrame)

    local iconBorder = cooldown:CreateTexture(nil, 'OVERLAY')
    iconBorder:SetAllPoints(cooldown)
    iconBorder:SetTexture(media['tex:generic:nocontrol_border.blp'])

    local nameFont = DF.ui.Font(frame, 14, '', {1, 1, 1}, 'LEFT', 'OUTLINE')
    nameFont:SetPoint('RIGHT', iconFrame, 'LEFT', -10, 0)

    local typeFont = DF.ui.Font(frame, 14, '', {1, 1, 1}, 'RIGHT', 'OUTLINE')
    typeFont:SetPoint('LEFT', iconFrame, 'RIGHT', 5, 0)

    local interruptIconFrame = CreateFrame('Frame', 'NoControlInterruptIcon', frame)
    interruptIconFrame:SetSize(30, 30)
    interruptIconFrame:SetPoint('TOP', iconFrame, 'BOTTOM', 0, -13)
    interruptIconFrame:Hide()

    local interruptIconTexture = interruptIconFrame:CreateTexture(nil, 'BACKGROUND')
    interruptIconTexture:SetAllPoints(interruptIconFrame)

    local interruptLabelFont = DF.ui.Font(frame, 12, 'Counter:', {1, 1, 1}, 'RIGHT', 'OUTLINE')
    interruptLabelFont:SetPoint('RIGHT', interruptIconFrame, 'LEFT', -5, 0)

    local interruptNameFont = DF.ui.Font(frame, 12, '', {1, 1, 1}, 'LEFT', 'OUTLINE')
    interruptNameFont:SetPoint('LEFT', interruptIconFrame, 'RIGHT', 5, 0)

    local glowTop = frame:CreateTexture(nil, 'OVERLAY')
    glowTop:SetHeight(20)
    glowTop:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 0)
    glowTop:SetPoint('RIGHT', frame, 'TOPRIGHT', 0, 0)
    glowTop:SetTexture(media['tex:generic:nocontrol_glow.blp'])
    glowTop:Hide()

    local glowBottom = frame:CreateTexture(nil, 'OVERLAY')
    glowBottom:SetHeight(20)
    glowBottom:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, 0)
    glowBottom:SetPoint('RIGHT', frame, 'BOTTOMRIGHT', 0, 0)
    glowBottom:SetTexture(media['tex:generic:nocontrol_glow.blp'])
    glowBottom:SetTexCoord(0, 1, 1, 0)
    glowBottom:Hide()

    function frame:RefreshSpellSlotCache()
        for spellName in pairs(interrupts) do
            spellSlotCache[spellName] = nil
        end
        for tab = 1, GetNumSpellTabs() do
            local _, _, offset, numSlots = GetSpellTabInfo(tab)
            for slot = offset + 1, offset + numSlots do
                local name = GetSpellName(slot, BOOKTYPE_SPELL)
                if name and interrupts[name] then
                    local interruptData = interrupts[name]
                    if interruptData.requireTalent then
                        local talentTab, talentIndex = interruptData.requireTalent[1], interruptData.requireTalent[2]
                        local _, _, _, _, rank = GetTalentInfo(talentTab, talentIndex)
                        if rank and rank > 0 then
                            spellSlotCache[name] = slot
                        end
                    else
                        spellSlotCache[name] = slot
                    end
                end
            end
        end
    end

    function frame:RefreshTrinketCache()
        for itemName in pairs(interrupts) do
            trinketSlotCache[itemName] = nil
        end
        for slot = 13, 14 do
            local itemLink = GetInventoryItemLink('player', slot)
            if itemLink then
                local itemName = string.gsub(itemLink, '.*%[(.*)%].*', '%1')
                if itemName and interrupts[itemName] and interrupts[itemName].isItem then
                    trinketSlotCache[itemName] = slot
                end
            end
        end
    end

    function frame:FindHighestPriorityDebuff()
        local maxDuration = 0
        local maxData = nil
        local maxTexture = nil
        local maxPriority = 999
        local maxName = nil

        for i = 1, 16 do
            local effect, rank, texture, stacks, dtype, duration, timeleft = libdebuff:UnitDebuff('player', i)
            -- debugprint('Debuff '..i..': '..(effect or 'nil'))
            if effect and spells[effect] then
                local spellData = spells[effect]
                local typeEnabled = DF.profile.nocontrol['show'..spellData.type]
                if typeEnabled then
                    local config = typeConfig[spellData.type]
                    local priority = config and config.priority or 999

                    for j = 0, 31 do
                        local buffTexture = GetPlayerBuffTexture(j)
                        if buffTexture == texture then
                            local dur = GetPlayerBuffTimeLeft(j)
                            if effect == 'Pounce Bleed' then
                                dur = 2
                            end
                            if priority < maxPriority or (priority == maxPriority and dur > maxDuration) then
                                maxDuration = dur
                                maxData = spellData
                                maxTexture = texture
                                maxPriority = priority
                                maxName = effect
                            end
                            break
                        end
                    end
                end
            end
        end

        return maxData, maxTexture, maxDuration, maxName
    end

    function frame:FindAvailableInterrupt(ccType)
        local bestSpellName = nil
        local bestPriority = 999
        local hasForbearance = nil

        for i = 1, 16 do
            local debuff = libdebuff:UnitDebuff('player', i)
            if debuff == 'Forbearance' then
                hasForbearance = true
                break
            end
        end

        for spellName, interruptData in pairs(interrupts) do
            for _, breakType in ipairs(interruptData.breaks) do
                if breakType == ccType then
                    if hasForbearance and interruptData.sharedCooldown == 'Forbearance' then
                        break
                    end
                    local slot = spellSlotCache[spellName]
                    if slot then
                        local start, duration = GetSpellCooldown(slot, BOOKTYPE_SPELL)
                        if start == 0 then
                            local priority = interruptData.priority or 999
                            if priority < bestPriority then
                                bestPriority = priority
                                bestSpellName = spellName
                            end
                        end
                    end
                    local trinketSlot = trinketSlotCache[spellName]
                    if trinketSlot then
                        local start, duration = GetInventoryItemCooldown('player', trinketSlot)
                        if start == 0 then
                            local priority = interruptData.priority or 999
                            if priority < bestPriority then
                                bestPriority = priority
                                bestSpellName = spellName
                            end
                        end
                    end
                end
            end
        end

        return bestSpellName
    end

    function frame:OnAuraChange()
        local maxData, maxTexture, maxDuration, maxName = self:FindHighestPriorityDebuff()

        if maxData then
            local config = typeConfig[maxData.type]
            if DF.profile.nocontrol.showSpellName then
                nameFont:SetText(maxName)
            else
                nameFont:SetText('')
            end
            if DF.profile.nocontrol.showSpellLabel then
                typeFont:SetText(config.label or maxData.type)
            else
                typeFont:SetText('')
            end
            iconTexture:SetTexture(maxTexture)

            if config and config.color then
                iconBorder:SetVertexColor(config.color[1], config.color[2], config.color[3], 1)
                glowTop:SetVertexColor(config.color[1], config.color[2], config.color[3])
                glowBottom:SetVertexColor(config.color[1], config.color[2], config.color[3])
                if DF.profile.nocontrol.showGlow then
                    glowTop:Show()
                    glowBottom:Show()
                end
                if maxName ~= currentSpellID then
                    currentSpellID = maxName
                    if maxName == 'Pounce Bleed' then
                        pounceBleedShowTime = GetTime()
                    end
                end
            end

            local interruptSpellName = self:FindAvailableInterrupt(maxData.type)

            if DF.profile.nocontrol.showInterrupts and interruptSpellName then
                local slot = spellSlotCache[interruptSpellName]
                local trinketSlot = trinketSlotCache[interruptSpellName]
                local interruptTexture = slot and GetSpellTexture(slot, BOOKTYPE_SPELL) or trinketSlot and GetInventoryItemTexture('player', trinketSlot)
                if interruptTexture then
                    interruptIconTexture:SetTexture(interruptTexture)
                    interruptIconFrame:Show()
                    if DF.profile.nocontrol.interruptIconOnly then
                        interruptLabelFont:SetText('')
                        interruptNameFont:SetText('')
                    else
                        interruptLabelFont:SetText('Counter:')
                        interruptNameFont:SetText(interrupts[interruptSpellName].name)
                    end
                else
                    interruptIconFrame:Hide()
                    interruptLabelFont:SetText('')
                    interruptNameFont:SetText('')
                end
            else
                interruptIconFrame:Hide()
                interruptLabelFont:SetText('')
                interruptNameFont:SetText('')
            end

            CooldownFrame_SetTimer(cooldown, GetTime(), maxDuration, 1)
            self:Show()
        else
            currentSpellID = nil
            pounceBleedShowTime = nil
            interruptIconFrame:Hide()
            interruptLabelFont:SetText('')
            interruptNameFont:SetText('')
            glowTop:Hide()
            glowBottom:Hide()
            self:Hide()
        end
    end

    frame:RegisterEvent('SPELLS_CHANGED')
    frame:RegisterEvent('UNIT_INVENTORY_CHANGED')
    frame:SetScript('OnEvent', function()
        if event == 'SPELLS_CHANGED' and arg1 == nil then
            frame:RefreshSpellSlotCache()
        elseif event == 'UNIT_INVENTORY_CHANGED' and arg1 == 'player' then
            frame:RefreshTrinketCache()
        elseif event == 'PLAYER_AURAS_CHANGED' or event == 'UNIT_AURA' then
            frame:OnAuraChange()
        end
    end)

    frame:SetScript('OnUpdate', function()
        if frame:IsShown() then
            if currentSpellID == 'Pounce Bleed' and pounceBleedShowTime and GetTime() - pounceBleedShowTime > 2 then
                frame:Hide()
            end
            if DF.profile.nocontrol.showGlow then
                if not DF.profile.nocontrol.disableGlowAnimation then
                    glowAlpha = glowAlpha + (glowDirection * 0.01)
                    if glowAlpha <= 0.2 then
                        glowAlpha = 0.2
                        glowDirection = 1
                    elseif glowAlpha >= 1 then
                        glowAlpha = 1
                        glowDirection = -1
                    end
                    glowTop:SetAlpha(glowAlpha)
                    glowBottom:SetAlpha(glowAlpha)
                    iconBorder:SetAlpha(glowAlpha)
                else
                    glowTop:SetAlpha(1)
                    glowBottom:SetAlpha(1)
                    iconBorder:SetAlpha(1)
                end
            end
        end
    end)

    frame:RefreshSpellSlotCache()
    frame:RefreshTrinketCache()

    -- callbacks
    local callbacks = {}

    callbacks.showInterrupts = function(value)
        if not value then
            interruptIconFrame:Hide()
            interruptLabelFont:SetText('')
            interruptNameFont:SetText('')
        end
    end

    callbacks.interruptIconOnly = function(value)
        if value then
            interruptLabelFont:SetText('')
            interruptNameFont:SetText('')
        end
    end

    callbacks.showSpellName = function(value)
        frame:OnAuraChange()
    end

    callbacks.showSpellLabel = function(value)
        frame:OnAuraChange()
    end

    callbacks.showBackground = function(value)
        if value then
            bg:Show()
        else
            bg:Hide()
        end
    end

    callbacks.showGlow = function(value)
        if value then
            if frame:IsShown() then
                glowTop:Show()
                glowBottom:Show()
            end
        else
            glowTop:Hide()
            glowBottom:Hide()
        end
    end

    callbacks.disableGlowAnimation = function(value)
        frame:OnAuraChange()
    end

    callbacks.frameScale = function(value)
        frame:SetScale(value)
    end

    callbacks.backgroundAlpha = function(value)
        bg:SetVertexColor(1, 1, 1, value)
    end

    callbacks.spellFontSize = function(value)
        local font, _, flags = nameFont:GetFont()
        nameFont:SetFont(font, value, flags)
        typeFont:SetFont(font, value, flags)
    end

    callbacks.interruptFontSize = function(value)
        local font, _, flags = interruptLabelFont:GetFont()
        interruptLabelFont:SetFont(font, value, flags)
        interruptNameFont:SetFont(font, value, flags)
    end

    callbacks.spellIconSize = function(value)
        iconFrame:SetSize(value, value)
    end

    callbacks.interruptIconSize = function(value)
        interruptIconFrame:SetSize(value, value)
    end

    callbacks.spellFont = function(value)
        local _, size, flags = nameFont:GetFont()
        nameFont:SetFont(media[value], size, flags)
        typeFont:SetFont(media[value], size, flags)
    end

    callbacks.interruptFont = function(value)
        local _, size, flags = interruptLabelFont:GetFont()
        interruptLabelFont:SetFont(media[value], size, flags)
        interruptNameFont:SetFont(media[value], size, flags)
    end

    callbacks.showCC = function(value)
        frame:OnAuraChange()
    end

    callbacks.showDisorient = function(value)
        frame:OnAuraChange()
    end

    callbacks.showIncap = function(value)
        frame:OnAuraChange()
    end

    callbacks.showSilence = function(value)
        frame:OnAuraChange()
    end

    callbacks.showFear = function(value)
        frame:OnAuraChange()
    end

    callbacks.showCharm = function(value)
        frame:OnAuraChange()
    end

    callbacks.showSleep = function(value)
        frame:OnAuraChange()
    end

    callbacks.showRoot = function(value)
        frame:OnAuraChange()
    end

    callbacks.showSnare = function(value)
        frame:OnAuraChange()
    end

    DF:NewCallbacks('nocontrol', callbacks)
end)
