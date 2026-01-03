DRAGONFLIGHT()

DF:NewDefaults('tempfixes', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('tempfixes', 1, 'PLAYER_ENTERING_WORLD', function()
    DurabilityFrame:ClearAllPoints()
    DurabilityFrame:SetPoint('RIGHT', UIParent, 'RIGHT', -15, 200)
    DurabilityFrame:SetScale(0.7)
end)
