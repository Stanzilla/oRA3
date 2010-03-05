local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local util = oRA.util
local module = oRA:NewModule("Tanks", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")
local AceGUI = LibStub("AceGUI-3.0")

module.VERSION = tonumber(("$Revision$"):sub(12, -3))

local frame = nil
local indexedTanks = {} -- table containing the final tank list
local namedTanks = {} -- table containing current active tanks by name
local tmpTanks = {} -- temp tank table reused
local namedPersistent = {} -- table containing named persistent list filled from db.persistentTanks
local allIndexedTanks = {} -- table containing the top scroll sorted list of indexed tanks
local sessionTanks = {} -- Tanks you pushed to the top for this session
local namedHidden = {} -- Named hidden tanks for this session

-- Lists containing the scrolling rows of tanks in the GUI
local top = {}
local bottom = {}

local function showConfig()
	if not frame then module:CreateFrame() end
	oRA:SetAllPointsToPanel(frame)
	frame:Show()
	module:UpdateScrolls()
end

local function hideConfig()
	if frame then
		frame:Hide()
	end
end

function module:OnRegister()
	local database = oRA.db:RegisterNamespace("Tanks", {
		factionrealm = {
			persistentTanks = {},
		},
	})
	self.db = database.factionrealm
	oRA:RegisterPanel(
		L["Tanks"],
		showConfig,
		hideConfig
	)
	for k, tank in next, self.db.persistentTanks do
		namedPersistent[tank] = true
		sessionTanks[tank] = true
		allIndexedTanks[#allIndexedTanks + 1] = tank
	end
	oRA.RegisterCallback(self, "OnTanksChanged")
	oRA.RegisterCallback(self, "OnGroupChanged")
	oRA.RegisterCallback(self, "OnPromoted")
	oRA.RegisterCallback(self, "OnDemoted")
end

local function sortTanks()
	wipe(indexedTanks)
	for k, tank in next, allIndexedTanks do
		if namedTanks[tank] and not namedHidden[tank] then
			indexedTanks[#indexedTanks + 1] = tank
		end
	end
	if oRA:InRaid() then
		oRA.callbacks:Fire("OnTanksUpdated", indexedTanks)
	end
end

function module:OnPromoted(event, status)
	if not frame then return end
	for k, v in next, top do
		v.tank:Enable()
	end
end

function module:OnDemoted(event, status)
	if not frame then return end
	for k, v in next, top do
		v.tank:Disable()
	end
end

function module:OnGroupChanged(event, status, members, updateSort)
	if oRA:InRaid() then
		wipe(tmpTanks)
		for tank, v in pairs(namedTanks) do
			tmpTanks[tank] = v
		end
		for k, tank in next, members do
			-- mix in the persistentTanks
			if namedPersistent[tank] and not namedTanks[tank] then
				updateSort = true
				namedTanks[tank] = true
			end
			tmpTanks[tank] = nil
		end
		-- remove obsolete tanks
		for tank, v in pairs(tmpTanks) do -- remove members nolonger in the group
			updateSort = true
			namedTanks[tank] = nil
		end
		if updateSort then
			sortTanks()
		end
		if frame and frame:IsVisible() then
			self:UpdateScrolls()
		end
	end
end

function module:OnTanksChanged(event, tanks, updateSort)
	wipe(tmpTanks)
	for tank, v in pairs(namedTanks) do
		tmpTanks[tank] = v
	end
	for k, tank in next, tanks do
		if not namedTanks[tank] then
			allIndexedTanks[#allIndexedTanks + 1] = tank
			updateSort = true
			namedTanks[tank] = true
		end
		tmpTanks[tank] = nil
	end
	for tank, v in pairs(tmpTanks) do
		-- remove any leftover tanks that are not persistent or set for the session
		if not namedPersistent[tank] and not sessionTanks[tank] then 
			for kk, vv in next, allIndexedTanks do
				if vv == tank then
					table.remove(allIndexedTanks, kk)
					break
				end
			end
			updateSort = true
			namedTanks[tank] = nil
		end
	end
	if updateSort then
		sortTanks()
	end
	if frame and frame:IsVisible() then
		self:UpdateScrolls()
	end
end

local function OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:AddLine(self.tooltipTitle)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function OnLeave(self)
	GameTooltip:Hide()
end

local function createButton(parent, template)
	local frame = CreateFrame("Button", nil, parent, template)
	frame:SetWidth(16)
	frame:SetHeight(16)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

	local image = frame:CreateTexture(nil, "BACKGROUND")
	frame.icon = image
	image:SetAllPoints(frame)
	return frame
end

local function topScrollDeleteClick(self)
	local value = self:GetParent().unitName
	local btanks = oRA:GetBlizzardTanks()
	if util:inTable(btanks, value) then return end
	-- remove from persistent if in there
	for k, v in next, module.db.persistentTanks do
		if v == value then
			table.remove(module.db.persistentTanks, k)
			break
		end
	end
	namedPersistent[value] = nil
	-- remove from the list
	for k, v in next, allIndexedTanks do
		if v == value then
			table.remove(allIndexedTanks, k)
		end
	end
	sessionTanks[value] = nil
	PlaySound("igMainMenuOptionCheckBoxOff")
	-- update
	module:OnGroupChanged("OnGroupChanged", nil, oRA:GetGroupMembers())
	module:OnTanksChanged("OnTanksChanged", oRA:GetBlizzardTanks())
end

local function topScrollHiddenClick(self)
	local value = self:GetParent().unitName
	if namedHidden[value] then
		namedHidden[value] = nil
		self:SetChecked(false)
		PlaySound("igMainMenuOptionCheckBoxOff")
	else
		namedHidden[value] = true
		self:SetChecked(true)
		PlaySound("igMainMenuOptionCheckBoxOn")
	end
	module:OnTanksChanged("OnTanksChanged", oRA:GetBlizzardTanks(), true)
end

local function topScrollSaveClick(self)
	local value = self:GetParent().unitName
	local k = util:inTable(module.db.persistentTanks, value)
	if k then
		PlaySound("igMainMenuOptionCheckBoxOff")
		table.remove(module.db.persistentTanks, k)
		namedPersistent[value] = nil
	else
		PlaySound("igMainMenuOptionCheckBoxOn")
		namedPersistent[value] = true
		wipe(module.db.persistentTanks)
		for k, v in next, allIndexedTanks do
			if namedPersistent[v] then
				module.db.persistentTanks[#module.db.persistentTanks + 1] = v
			end
		end
	end
	module:OnGroupChanged("OnGroupChanged", nil, oRA:GetGroupMembers())
	module:OnTanksChanged("OnTanksChanged", oRA:GetBlizzardTanks())
end

local function topScrollUpClick(self)
	local k = util:inTable(allIndexedTanks, self.unitName)
	local temp = allIndexedTanks[k]
	if k == 1 then
		allIndexedTanks[k] = allIndexedTanks[#allIndexedTanks]
		allIndexedTanks[#allIndexedTanks] = temp
	else
		allIndexedTanks[k] = allIndexedTanks[k - 1]
		allIndexedTanks[k - 1] = temp
	end
	wipe(module.db.persistentTanks)
	for k, v in next, allIndexedTanks do
		if namedPersistent[v] then
			module.db.persistentTanks[#module.db.persistentTanks + 1] = v
		end
	end
	PlaySound("UChatScrollButton")
	module:OnTanksChanged("OnTanksChanged", oRA:GetBlizzardTanks(), true)
end

local function bottomScrollClick(self)
	local value = self.unitName
	if util:inTable(allIndexedTanks, value) then return true end
	allIndexedTanks[#allIndexedTanks + 1] = value
	sessionTanks[value] = true
	namedTanks[value] = true
	PlaySound("igMainMenuOptionCheckBoxOn")
	module:OnTanksChanged("OnTanksChanged", oRA:GetBlizzardTanks(), true)
	module:UpdateScrolls()
end

function module:CreateFrame()
	frame = CreateFrame("Frame")

	local centerBar = CreateFrame("Button", nil, frame)
	centerBar:SetPoint("BOTTOMLEFT", frame, -5, 142)
	centerBar:SetPoint("BOTTOMRIGHT", frame, 0, 142)
	centerBar:SetHeight(8)
	local texture = centerBar:CreateTexture(nil, "BORDER")
	texture:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
	texture:SetAllPoints(centerBar)
	texture:SetTexCoord(0.29296875, 1, 0, 0.25)

	local topBar = CreateFrame("Button", nil, frame)
	topBar:SetPoint("TOPLEFT", frame, -5, -42)
	topBar:SetPoint("TOPRIGHT", frame, 0, -42)
	topBar:SetHeight(8)
	texture = topBar:CreateTexture(nil, "BORDER")
	texture:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
	texture:SetAllPoints(topBar)
	texture:SetTexCoord(0.29296875, 1, 0, 0.25)

	frame.topscroll = CreateFrame("ScrollFrame", "oRA3TankTopScrollFrame", frame, "FauxScrollFrameTemplate")
	frame.topscroll:SetPoint("TOPLEFT", topBar, "BOTTOMLEFT", 4, 2)
	frame.topscroll:SetPoint("BOTTOMRIGHT", centerBar, "TOPRIGHT", -22, -2)

	frame.bottomscroll = CreateFrame("ScrollFrame", "oRA3TankBottomScrollFrame", frame, "FauxScrollFrameTemplate")
	frame.bottomscroll:SetPoint("TOPLEFT", centerBar, "BOTTOMLEFT", 4, 2) 
	frame.bottomscroll:SetPoint("BOTTOMRIGHT", frame, -22, 0)

	local help = frame:CreateFontString(nil, "ARTWORK")
	help:SetFontObject(GameFontNormal)
	help:SetPoint("TOPLEFT")
	help:SetPoint("BOTTOMRIGHT", topBar, "TOPRIGHT", -20, 0)
	help:SetText(L["Top List: Sorted Tanks. Bottom List: Potential Tanks."])
	
	local helpButton = createButton(frame)
	helpButton:SetPoint("TOPRIGHT", -4, -4)
	helpButton.icon:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon")
	helpButton.tooltipTitle = L["What is all this?"]
	helpButton.tooltipText = L.tankHelp

	-- 10 top
	-- 9 bottom
	for i = 1, 10 do
		local t = CreateFrame("Button", nil, frame)
		t:SetHeight(16)
		t:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
		t:SetScript("OnClick", topScrollUpClick)
		t:SetScript("OnLeave", OnLeave)
		t:SetScript("OnEnter", OnEnter)
		t.tooltipTitle = L["Sort"]
		t.tooltipText = L["Click to move this tank up."]

		if i == 1 then
			t:SetPoint("TOPLEFT", frame.topscroll)
			t:SetPoint("TOPRIGHT", frame.topscroll)
		else
			t:SetPoint("TOPLEFT", top[i - 1], "BOTTOMLEFT")
			t:SetPoint("TOPRIGHT", top[i - 1], "BOTTOMRIGHT")
		end

		local hidden = CreateFrame("CheckButton", "oRA3TankHideButton"..i, t, "UICheckButtonTemplate")
		hidden:SetPoint("TOPLEFT", t)
		hidden:SetWidth(16)
		hidden:SetHeight(16)
		hidden:SetScript("OnLeave", OnLeave)
		hidden:SetScript("OnEnter", OnEnter)
		hidden:SetScript("OnClick", topScrollHiddenClick)
		hidden.tooltipTitle = L.Hide
		hidden.tooltipText = L.hideButtonHelp
		t.hidden = hidden
		
		local name = oRA:CreateScrollEntry(t)
		name:SetPoint("TOPLEFT", hidden, "TOPRIGHT", 4, 0)
		name:SetText(L["Name"])
		t.label = name

		local delete = createButton(t)
		delete:SetPoint("TOPRIGHT", t)
		delete.icon:SetTexture("Interface\\AddOns\\oRA3\\images\\close")
		delete:SetScript("OnClick", topScrollDeleteClick)
		delete.tooltipTitle = L.Remove
		delete.tooltipText = L.deleteButtonHelp
		t.delete = delete

		local tank = createButton(t, "SecureActionButtonTemplate")
		tank:SetPoint("TOPRIGHT", delete, "TOPLEFT", -2, 0)
--		tank.icon:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-MainTank")
		tank.icon:SetTexture("Interface\\AddOns\\oRA3\\images\\maintank")
--		tank.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		tank:SetAttribute("type", "maintank")
		tank:SetAttribute("action", "toggle")
		if oRA:IsPromoted() then
			tank:Enable()
		else
			tank:Disable()
		end
		tank.tooltipTitle = L["Blizzard Main Tank"]
		tank.tooltipText = L.tankButtonHelp
		t.tank = tank

		local save = createButton(t)
		save:SetPoint("TOPRIGHT", tank, "TOPLEFT", -2, 0)
		save.icon:SetTexture(READY_CHECK_READY_TEXTURE)
		save:SetScript("OnClick", topScrollSaveClick)
		save.tooltipTitle = L.Save
		save.tooltipText = L.saveButtonHelp
		t.save = save

		top[i] = t
	end

	for i = 1, 9 do
		local b = CreateFrame("Button", nil, frame)
		b:SetHeight(16)
		b:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
		b:SetScript("OnClick", bottomScrollClick)
		if i == 1 then
			b:SetPoint("TOPLEFT", frame.bottomscroll)
			b:SetPoint("TOPRIGHT", frame.bottomscroll)
		else
			b:SetPoint("TOPLEFT", bottom[i - 1], "BOTTOMLEFT")
			b:SetPoint("TOPRIGHT", bottom[i - 1], "BOTTOMRIGHT")
		end
		local name = oRA:CreateScrollEntry(b)
		name:SetPoint("TOPLEFT", b)
		name:SetPoint("BOTTOMRIGHT", b)
		name:SetText(L["Name"])
		b.label = name
		b.unitName = L["Name"]
		bottom[i] = b
	end
	
	local function updTopScroll() module:UpdateTopScroll() end
	local function updBottomScroll() module:UpdateBottomScroll() end
	frame.topscroll:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 16, updTopScroll)
	end)
	frame.bottomscroll:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 16, updBottomScroll)
	end)
	self.CreateFrame = nil
end

function module:UpdateScrolls()
	self:UpdateTopScroll()
	self:UpdateBottomScroll()
end

local ngroup = {}
function module:UpdateTopScroll()
	if not frame then return end
	local nr = #allIndexedTanks
	local btanks = oRA:GetBlizzardTanks()
	FauxScrollFrame_Update(frame.topscroll, nr, 10, 16)
	for i, v in next, top do
		local j = i + FauxScrollFrame_GetOffset(frame.topscroll)
		if j <= nr then
			if util:inTable(btanks, allIndexedTanks[j]) then
				v.tank:SetAlpha(1)
				v.delete:SetAlpha(.3)
				v.delete:Disable()
				v.hidden:Disable()
				v.hidden:SetAlpha(.3)
			else
				v.tank:SetAlpha(.3)
				v.delete:SetAlpha(1)
				v.delete:Enable()
				v.hidden:SetAlpha(1)
				v.hidden:Enable()
			end
			if namedPersistent[allIndexedTanks[j]] then
				v.save:SetAlpha(1)
			else
				v.save:SetAlpha(.3)
			end
			v.hidden:SetChecked( namedHidden[allIndexedTanks[j]] )

			v.unitName = allIndexedTanks[j]
			v.tank:SetAttribute("unit", allIndexedTanks[j])
			v.label:SetText(oRA.coloredNames[allIndexedTanks[j]])
			v:Show()
		else
			v:Hide()
		end
	end
end

function module:UpdateBottomScroll()
	if not frame then return end
	local group = oRA:GetGroupMembers()
	wipe(ngroup)
	for	k, v in pairs(group) do
		if not namedTanks[v] then -- only add not in the tanklist
			ngroup[#ngroup + 1] = v
		end
	end
	table.sort(ngroup)
	local nr = #ngroup
	FauxScrollFrame_Update(frame.bottomscroll, nr, 9, 16)
	for i, v in next, bottom do
		local j = i + FauxScrollFrame_GetOffset(frame.bottomscroll)
		if j <= nr then
			v.unitName = ngroup[j]
			v.label:SetText(oRA.coloredNames[ngroup[j]])
			v:Show()
		else
			v:Hide()
		end
	end
end

function oRA:GetSortedTanks()
	return indexedTanks
end

