DRAGONFLIGHT()

DF:NewDefaults('gui-performance', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('gui-performance', 2, function()
    local setup = DF.setups.guiBase
    if not setup then return end

    local performancePanel = setup.panels['performance']

    local statsHeader = DF.ui.Font(performancePanel, 12, 'System Stats', {1, 0.82, 0})
    statsHeader:SetPoint('TOPLEFT', performancePanel, 'TOPLEFT', 10, -15)
    statsHeader:SetJustifyH('LEFT')

    local statsHeaderLabel = DF.ui.Font(performancePanel, 10, 'Metric', {0.6, 0.6, 0.6})
    statsHeaderLabel:SetPoint('TOPLEFT', performancePanel, 'TOPLEFT', 10, -68)
    statsHeaderLabel:SetJustifyH('LEFT')

    local statsHeaderValue = DF.ui.Font(performancePanel, 10, 'Value', {0.6, 0.6, 0.6})
    statsHeaderValue:SetPoint('LEFT', statsHeaderLabel, 'RIGHT', 185, -0)
    statsHeaderValue:SetJustifyH('RIGHT')

    local stats = DF.ui.Scrollframe(performancePanel, 250, 120)
    stats:SetPoint('TOPLEFT', performancePanel, 'TOPLEFT', 5, -85)
    stats:EnableMouse(true)
    stats.bg = stats:CreateTexture(nil, 'BACKGROUND')
    stats.bg:SetTexture('Interface\\Buttons\\WHITE8X8')
    stats.bg:SetAllPoints(stats)
    stats.bg:SetVertexColor(0, 0, 0, 0.2)

    stats.active = false
    stats.startMem = 0
    stats.lastMem = 0
    stats.peakMem = 0
    stats.startTime = 0
    stats.lastGC = 0
    stats.fpsMin = 999
    stats.fpsMax = 0
    stats.fpsTotal = 0
    stats.fpsCount = 0
    stats.helper = CreateFrame('Frame')

    local statsBtn1 = DF.ui.Button(stats, 'Start', 45, 20)
    statsBtn1:SetPoint('BOTTOMLEFT', stats, 'TOPLEFT', 0, 22)

    local statsBtn2 = DF.ui.Button(stats, 'Stop', 45, 20)
    statsBtn2:SetPoint('BOTTOMRIGHT', stats, 'TOPRIGHT', 0, 22)

    local labels = {'FPS:', 'FPS M/A/M:', 'Mem:', 'Rate:', 'Delta:', 'Peak:', 'Last GC:', 'Uptime:'}
    stats.statLabels = {}
    stats.statValues = {}

    for i = 1, 8 do
        stats.statLabels[i] = DF.ui.Font(stats.content, 10, labels[i], {0.7, 0.7, 0.7})
        stats.statLabels[i]:SetPoint('TOPLEFT', stats.content, 'TOPLEFT', 5, -5 - (i-1)*13)
        stats.statLabels[i]:SetJustifyH('LEFT')

        stats.statValues[i] = DF.ui.Font(stats.content, 10, '', {1, 1, 1})
        stats.statValues[i]:SetPoint('TOPRIGHT', stats.content, 'TOPRIGHT', -5, -5 - (i-1)*13)
        stats.statValues[i]:SetJustifyH('RIGHT')
    end

    function stats:UpdateStats()
        local fps = GetFramerate()
        local mem = gcinfo()

        local fpsColor = fps > 50 and {0.5, 1, 0.5} or fps > 30 and {1, 1, 0.5} or {1, 0.5, 0.5}
        self.statValues[1]:SetText(string.format('%.1f', fps))
        self.statValues[1]:SetTextColor(fpsColor[1], fpsColor[2], fpsColor[3])

        if fps < self.fpsMin then self.fpsMin = fps end
        if fps > self.fpsMax then self.fpsMax = fps end
        self.fpsTotal = self.fpsTotal + fps
        self.fpsCount = self.fpsCount + 1
        local fpsAvg = self.fpsTotal / self.fpsCount
        self.statValues[2]:SetText('|cffff6666' .. string.format('%.0f', self.fpsMin) .. '|r/' .. string.format('%.0f', fpsAvg) .. '/|cff66ff66' .. string.format('%.0f', self.fpsMax) .. '|r')
        self.statValues[2]:SetTextColor(1, 1, 1)

        self.statValues[3]:SetText(string.format('%.2f', mem / 1024) .. ' MB')
        self.statValues[3]:SetTextColor(1, 1, 1)

        local rate = mem - self.lastMem
        local rateColor = rate < 50 and {0.5, 1, 0.5} or rate < 200 and {1, 1, 0.5} or {1, 0.5, 0.5}
        self.statValues[4]:SetText(string.format('%.1f', rate) .. ' kB/s')
        self.statValues[4]:SetTextColor(rateColor[1], rateColor[2], rateColor[3])

        if mem < self.lastMem - 100 then
            self.lastGC = GetTime()
        end
        self.lastMem = mem

        local delta = mem - self.startMem
        local deltaColor = delta < 1024 and {0.5, 1, 0.5} or delta < 5120 and {1, 1, 0.5} or {1, 0.5, 0.5}
        self.statValues[5]:SetText(string.format('%+.2f', delta / 1024) .. ' MB')
        self.statValues[5]:SetTextColor(deltaColor[1], deltaColor[2], deltaColor[3])

        if mem > self.peakMem then self.peakMem = mem end
        self.statValues[6]:SetText(string.format('%.2f', self.peakMem / 1024) .. ' MB')
        self.statValues[6]:SetTextColor(1, 1, 1)

        if self.lastGC > 0 then
            local gcAgo = GetTime() - self.lastGC
            self.statValues[7]:SetText(string.format('%.0f', gcAgo) .. 's ago')
            self.statValues[7]:SetTextColor(1, 1, 1)
        else
            self.statValues[7]:SetText('N/A')
            self.statValues[7]:SetTextColor(0.7, 0.7, 0.7)
        end

        local uptime = GetTime() - self.startTime
        self.statValues[8]:SetText(string.format('%.0f', uptime) .. 's')
        self.statValues[8]:SetTextColor(1, 1, 1)
    end

    statsBtn1:SetScript('OnClick', function()
        stats.active = true
        stats.startMem = gcinfo()
        stats.lastMem = stats.startMem
        stats.peakMem = stats.startMem
        stats.startTime = GetTime()
        stats.lastGC = 0
        stats.fpsMin = 999
        stats.fpsMax = 0
        stats.fpsTotal = 0
        stats.fpsCount = 0

        stats.helper:SetScript('OnUpdate', function()
            if (this.tick or 0) < GetTime() then
                this.tick = GetTime() + 1.0
                stats:UpdateStats()
            end

        end)
        stats:UpdateStats()
    end)

    statsBtn2:SetScript('OnClick', function()
        stats.active = false
        stats.helper:SetScript('OnUpdate', nil)
        for i = 1, 8 do
            stats.statValues[i]:SetText('')
        end
    end)

    local scannerHeader = DF.ui.Font(performancePanel, 12, 'Frame Scanner', {1, 0.82, 0})
    scannerHeader:SetPoint('TOP', performancePanel, 'TOP', -20, -15)
    scannerHeader:SetJustifyH('RIGHT')

    local printCheckbox = DF.ui.Checkbox(performancePanel, 'Print active scanner', 20, 20, 'LEFT')
    printCheckbox:SetPoint('TOPRIGHT', performancePanel, 'TOPRIGHT', -10, -10)
    printCheckbox:SetChecked(false)

    local scanner = DF.ui.Scrollframe(performancePanel, 400, 402)
    scanner:SetPoint('TOPRIGHT', performancePanel, 'TOPRIGHT', -5, -85)
    scanner:EnableMouse(true)

    scanner.bg = scanner:CreateTexture(nil, 'BACKGROUND')
    scanner.bg:SetTexture('Interface\\Buttons\\WHITE8X8')
    scanner.bg:SetAllPoints(scanner)
    scanner.bg:SetVertexColor(0, 0, 0, 0.2)

    local scannerBtnStart = DF.ui.Button(scanner, 'Start', 45, 20)
    scannerBtnStart:SetPoint('BOTTOMLEFT', scanner, 'TOPLEFT', 0, 23)
    scannerBtnStart:SetScript('OnClick', function()
        scanner.data = {}
        scanner.monitoring = true
        scanner:StartMonitoring(true)
        scanner:ScanAndHook()
    end)

    local scannerBtnStop = DF.ui.Button(scanner, 'Stop', 45, 20)
    scannerBtnStop:SetPoint('BOTTOMRIGHT', scanner, 'TOPRIGHT', 0, 23)
    scannerBtnStop:SetScript('OnClick', function()
        scanner.monitoring = false
        scanner:StartMonitoring(false)
        for frame in pairs(scanner.hooked_frames) do
            DF.hooks.Unhook(frame, 'OnEvent')
            DF.hooks.Unhook(frame, 'OnUpdate')
        end
        scanner.hooked_frames = {}
        scanner.data = {}
        for i = 1, table.getn(scanner.labels) do
            if scanner.ranks[i] then scanner.ranks[i]:Hide() end
            scanner.labels[i]:Hide()
            scanner.calls[i]:Hide()
            scanner.times[i]:Hide()
            if scanner.avgs[i] then scanner.avgs[i]:Hide() end
        end
    end)

    local scannerBtnMode = DF.ui.Button(scanner, 'OnEvent', 45, 20)
    scannerBtnMode:SetPoint('BOTTOM', scanner, 'TOP', -120, 23)
    scannerBtnMode:SetScript('OnClick', function()
        if scanner.scanMode == 'event' then
            scanner.scanMode = 'update'
            scannerBtnMode.text:SetText('OnUpdate')
        elseif scanner.scanMode == 'update' then
            scanner.scanMode = 'both'
            scannerBtnMode.text:SetText('Both')
        else
            scanner.scanMode = 'event'
            scannerBtnMode.text:SetText('OnEvent')
        end
    end)

    local headerName = DF.ui.Font(performancePanel, 10, 'Frame Name', {0.6, 0.6, 0.6})
    headerName:SetPoint('TOPLEFT', scanner, 'TOPLEFT', 25, 18)
    headerName:SetJustifyH('LEFT')

    local headerCalls = DF.ui.Font(performancePanel, 10, 'Total Calls', {0.6, 0.6, 0.6})
    headerCalls:SetPoint('TOPRIGHT', scanner, 'TOPRIGHT', -140, 18)
    headerCalls:SetJustifyH('RIGHT')

    local headerTotal = DF.ui.Font(performancePanel, 10, 'Total Time', {0.6, 0.6, 0.6})
    headerTotal:SetPoint('TOPRIGHT', scanner, 'TOPRIGHT', -70, 18)
    headerTotal:SetJustifyH('RIGHT')

    local headerAvg = DF.ui.Font(performancePanel, 10, 'Average Time', {0.6, 0.6, 0.6})
    headerAvg:SetPoint('TOPRIGHT', scanner, 'TOPRIGHT', -5, 18)
    headerAvg:SetJustifyH('RIGHT')

    scanner.data = {}
    scanner.monitoring = false
    scanner.hooked_frames = {}
    scanner.ranks = {}
    scanner.labels = {}
    scanner.calls = {}
    scanner.times = {}
    scanner.avgs = {}
    scanner.scanMode = 'event'
    scanner.helper = CreateFrame('Frame')
    scanner.sortedData = nil

    for i = 1, 30 do
        scanner.ranks[i] = DF.ui.Font(scanner.content, 11, '', {0.6, 0.6, 0.6})
        scanner.ranks[i]:SetJustifyH('LEFT')
        scanner.ranks[i]:Hide()

        scanner.labels[i] = DF.ui.Font(scanner.content, 11, '', {1, 1, 1})
        scanner.labels[i]:SetJustifyH('LEFT')
        scanner.labels[i]:Hide()

        scanner.calls[i] = DF.ui.Font(scanner.content, 11, '', {1, 1, 1})
        scanner.calls[i]:SetJustifyH('RIGHT')
        scanner.calls[i]:Hide()

        scanner.times[i] = DF.ui.Font(scanner.content, 11, '', {1, 1, 1})
        scanner.times[i]:SetJustifyH('RIGHT')
        scanner.times[i]:Hide()

        scanner.avgs[i] = DF.ui.Font(scanner.content, 11, '', {1, 1, 1})
        scanner.avgs[i]:SetJustifyH('RIGHT')
        scanner.avgs[i]:Hide()
    end

    local origOnMouseWheel = scanner:GetScript('OnMouseWheel')
    scanner:SetScript('OnMouseWheel', function()
        if origOnMouseWheel then origOnMouseWheel() end
        scanner:RenderVisible()
    end)

    scanner.scrollBar:SetScript('OnValueChanged', function()
        local value = this:GetValue()
        scanner:SetVerticalScroll(value)
        scanner:RenderVisible()
    end)

    function scanner:ScanAndHook()
        local function scanTree(parent, frames)
            table.insert(frames, parent)
            if parent.GetChildren then
                local children = {parent:GetChildren()}
                for _, child in pairs(children) do
                    scanTree(child, frames)
                end
            end
        end

        local allFrames = {}
        scanTree(UIParent, allFrames)

        for name, obj in pairs(_G) do
            if type(obj) == 'table' and obj.GetScript then
                table.insert(allFrames, obj)
            end
        end

        for _, frame in pairs(allFrames) do
            if frame ~= scanner and frame.GetScript and not self.hooked_frames[frame] then
                if self.scanMode == 'event' or self.scanMode == 'both' then
                    local original = frame:GetScript('OnEvent')
                    if original and not DF.hooks.IsHooked(frame, 'OnEvent') then
                        self.hooked_frames[frame] = true
                        local frameName = (frame.GetName and frame:GetName()) or tostring(frame)

                        DF.hooks.registry[frame] = DF.hooks.registry[frame] or {}
                        DF.hooks.registry[frame]['OnEvent'] = original

                        frame:SetScript('OnEvent', function()
                            if not scanner.monitoring then
                                original()
                                return
                            end

                            if not scanner.data[frameName] then
                                scanner.data[frameName] = {0, 0}
                            end

                            local start = GetTime()
                            original()
                            local runtime = GetTime() - start

                            scanner.data[frameName][1] = scanner.data[frameName][1] + 1
                            scanner.data[frameName][2] = scanner.data[frameName][2] + runtime
                        end)
                    end
                end

                if self.scanMode == 'update' or self.scanMode == 'both' then
                    local original = frame:GetScript('OnUpdate')
                    if original and not DF.hooks.IsHooked(frame, 'OnUpdate') then
                        self.hooked_frames[frame] = true
                        local frameName = (frame.GetName and frame:GetName()) or tostring(frame)

                        DF.hooks.registry[frame] = DF.hooks.registry[frame] or {}
                        DF.hooks.registry[frame]['OnUpdate'] = original

                        frame:SetScript('OnUpdate', function()
                            if not scanner.monitoring then
                                original()
                                return
                            end

                            if not scanner.data[frameName] then
                                scanner.data[frameName] = {0, 0}
                            end

                            local start = GetTime()
                            original()
                            local runtime = GetTime() - start

                            scanner.data[frameName][1] = scanner.data[frameName][1] + 1
                            scanner.data[frameName][2] = scanner.data[frameName][2] + runtime
                        end)
                    end
                end
            end
        end
    end

    function scanner:DisplayUpdate()
        if not self.monitoring then return end

        self.sortedData = {}
        for name, data in pairs(self.data) do
            table.insert(self.sortedData, {name, data[1], data[2]})
        end
        table.sort(self.sortedData, function(a, b) return a[2] > b[2] end)

        if printCheckbox:GetChecked() then
            print('Scanner update: ' .. table.getn(self.sortedData) .. ' frames tracked')
        end

        local totalItems = table.getn(self.sortedData)
        self.content:SetHeight(math.max(400, totalItems * 15))
        self.updateScrollBar()

        self:RenderVisible()
    end

    function scanner:RenderVisible()
        if not self.sortedData then return end

        local scrollOffset = scanner:GetVerticalScroll()
        local startIndex = math.floor(scrollOffset / 15) + 1
        local totalItems = table.getn(self.sortedData)

        for i = 1, 30 do
            local dataIndex = startIndex + i - 1

            if dataIndex <= totalItems then
                local name, count, time = self.sortedData[dataIndex][1], self.sortedData[dataIndex][2], self.sortedData[dataIndex][3]
                local colorCode = dataIndex <= 10 and '|cffff8080' or '|cffffffff'
                local yOffset = (dataIndex - 1) * 15

                self.ranks[i]:SetPoint('TOPLEFT', self.content, 'TOPLEFT', 5, -yOffset)
                self.ranks[i]:SetText(dataIndex .. '.')
                self.ranks[i]:Show()

                self.labels[i]:SetPoint('TOPLEFT', self.content, 'TOPLEFT', 25, -yOffset)
                self.labels[i]:SetText(name)
                self.labels[i]:Show()

                self.calls[i]:SetPoint('TOPRIGHT', self.content, 'TOPRIGHT', -140, -yOffset)
                self.calls[i]:SetText(colorCode .. count .. '|r calls')
                self.calls[i]:Show()

                self.times[i]:SetPoint('TOPRIGHT', self.content, 'TOPRIGHT', -70, -yOffset)
                self.times[i]:SetText(colorCode .. string.format('%.3f', time * 1000) .. '|r ms')
                self.times[i]:Show()

                local avgTime = (time / count) * 1000
                self.avgs[i]:SetPoint('TOPRIGHT', self.content, 'TOPRIGHT', -5, -yOffset)
                self.avgs[i]:SetText(colorCode .. string.format('%.3f', avgTime) .. '|r avg')
                self.avgs[i]:Show()
            else
                self.ranks[i]:Hide()
                self.labels[i]:Hide()
                self.calls[i]:Hide()
                self.times[i]:Hide()
                self.avgs[i]:Hide()
            end
        end
    end

    function scanner:StartMonitoring(active)
        if active then
            self.helper:SetScript('OnUpdate', function()
                if (this.tick or 0) < GetTime() then
                    this.tick = GetTime() + 1.0
                    scanner:DisplayUpdate()
                end
            end)
        else
            self.helper:SetScript('OnUpdate', nil)
        end
    end

    local addonMemHeader = DF.ui.Font(performancePanel, 12, 'Addon Performance', {1, 0.82, 0})
    addonMemHeader:SetPoint('BOTTOMLEFT', performancePanel, 'BOTTOMLEFT', 10, 260)
    addonMemHeader:SetJustifyH('LEFT')

    local addonHeaderName = DF.ui.Font(performancePanel, 10, 'Name', {0.6, 0.6, 0.6})
    addonHeaderName:SetPoint('BOTTOMLEFT', performancePanel, 'BOTTOMLEFT', 10, 240)
    addonHeaderName:SetJustifyH('LEFT')

    local addonHeaderTime = DF.ui.Font(performancePanel, 10, 'Time', {0.6, 0.6, 0.6})
    addonHeaderTime:SetPoint('LEFT', addonHeaderName, 'RIGHT', 130, 0)
    addonHeaderTime:SetJustifyH('RIGHT')

    local addonHeaderMem = DF.ui.Font(performancePanel, 10, 'Memory', {0.6, 0.6, 0.6})
    addonHeaderMem:SetPoint('LEFT', addonHeaderTime, 'RIGHT', 27, 0)
    addonHeaderMem:SetJustifyH('RIGHT')

    local addonMem = DF.ui.Scrollframe(performancePanel, 250, 230)
    addonMem:SetPoint('BOTTOMLEFT', performancePanel, 'BOTTOMLEFT', 5, 3)
    addonMem:EnableMouse(true)

    addonMem.bg = addonMem:CreateTexture(nil, 'BACKGROUND')
    addonMem.bg:SetTexture('Interface\\Buttons\\WHITE8X8')
    addonMem.bg:SetAllPoints(addonMem)
    addonMem.bg:SetVertexColor(0, 0, 0, 0.2)

    addonMem.labels = {}
    addonMem.times = {}
    addonMem.mems = {}

    local sorted = {}
    for addonName, data in pairs(performance) do
        if type(data) == 'table' and data.time and data.memory then
            table.insert(sorted, {addonName, data.time, data.memory})
        end
    end
    table.sort(sorted, function(a, b) return a[3] > b[3] end)

    local yOffset = 5
    for i = 1, table.getn(sorted) do
        local name, time, mem = sorted[i][1], sorted[i][2], sorted[i][3]

        addonMem.labels[i] = DF.ui.Font(addonMem.content, 10, name, {1, 1, 1})
        addonMem.labels[i]:SetPoint('TOPLEFT', addonMem.content, 'TOPLEFT', 5, -yOffset)
        addonMem.labels[i]:SetJustifyH('LEFT')

        addonMem.times[i] = DF.ui.Font(addonMem.content, 10, '|cffffffff' .. string.format('%.3f', time) .. '|r|cffb3b3b3 s|r', {1, 1, 1})
        addonMem.times[i]:SetPoint('TOPRIGHT', addonMem.content, 'TOPRIGHT', -60, -yOffset)
        addonMem.times[i]:SetJustifyH('RIGHT')

        addonMem.mems[i] = DF.ui.Font(addonMem.content, 10, '|cffffffff' .. string.format('%.0f', mem) .. '|r|cffb3b3b3 kb|r', {1, 1, 1})
        addonMem.mems[i]:SetPoint('TOPRIGHT', addonMem.content, 'TOPRIGHT', -5, -yOffset)
        addonMem.mems[i]:SetJustifyH('RIGHT')

        yOffset = yOffset + 13
    end

    addonMem.content:SetHeight(math.max(400, yOffset))
    addonMem.updateScrollBar()
end)
