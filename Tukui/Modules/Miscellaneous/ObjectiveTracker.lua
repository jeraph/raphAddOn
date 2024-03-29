local T, C, L = select(2, ...):unpack()
local ObjectiveTracker = CreateFrame("Frame", nil, UIParent)
local Misc = T["Miscellaneous"]
local Movers = T["Movers"]
local Class = select(2, UnitClass("player"))
local CustomClassColor = T.Colors.class[Class]
local QuestWatchFrame = QuestWatchFrame
local Anchor1, Parent, Anchor2, X, Y = "TOPRIGHT", UIParent, "TOPRIGHT", -280, -400
local ClickFrames = {}

function ObjectiveTracker:CreateHolder()
	local ObjectiveFrameHolder = CreateFrame("Frame", "TukuiObjectiveTracker", UIParent)
	ObjectiveFrameHolder:Size(130, 22)
	ObjectiveFrameHolder:SetPoint(Anchor1, Parent, Anchor2, X, Y)
	
	self.Holder = ObjectiveFrameHolder
end

function ObjectiveTracker:SetDefaultPosition()
	local Data = TukuiData[GetRealmName()][UnitName("Player")]
	local ObjectiveFrameHolder = self.Holder
	
	QuestWatchFrame:SetParent(ObjectiveFrameHolder)
	QuestWatchFrame:ClearAllPoints()
	QuestWatchFrame:SetPoint("TOPLEFT")
	
	if Data and Data.Move and Data.Move.TukuiObjectiveTracker then
		ObjectiveFrameHolder:ClearAllPoints()
		ObjectiveFrameHolder:SetPoint(unpack(Data.Move.TukuiObjectiveTracker))
	end
	
	Movers:RegisterFrame(ObjectiveFrameHolder)
end

function ObjectiveTracker:Skin()
	local HeaderBar = CreateFrame("StatusBar", nil, QuestWatchFrame)
	local HeaderText = HeaderBar:CreateFontString(nil, "OVERLAY")
	local Font = T.GetFont(C.Misc.ObjectiveTrackerFont)
	
	HeaderBar:Size(QuestWatchFrame:GetWidth(), 2)
	HeaderBar:SetPoint("TOPLEFT", QuestWatchFrame, 0, -4)
	HeaderBar:SetStatusBarTexture(C.Medias.Blank)
	HeaderBar:SetStatusBarColor(unpack(CustomClassColor))
	HeaderBar:SetTemplate()
	HeaderBar:CreateShadow()
	
	HeaderText:SetFontObject(Font)
	HeaderText:Point("LEFT", HeaderBar, "LEFT", -2, 14)
	HeaderText:SetText(CURRENT_QUESTS)
	
	-- Change font of watched quests
	for i = 1, 30 do
		local Line = _G["QuestWatchLine"..i]

		Line:SetFontObject(Font)
	end
	
	self.HeaderBar = HeaderBar
	self.HeaderText = HeaderText
end

function ObjectiveTracker:SkinQuestTimer()
	local Timer = QuestTimerFrame
	local HeaderBar = self.HeaderBar
	local HeaderTimerBar = CreateFrame("StatusBar", nil, QuestTimerFrame)
	
	HeaderTimerBar:Size(QuestWatchFrame:GetWidth(), 2)
	HeaderTimerBar:SetPoint("TOPLEFT", QuestWatchFrame, 0, 56)
	HeaderTimerBar:SetStatusBarTexture(C.Medias.Blank)
	HeaderTimerBar:SetStatusBarColor(unpack(CustomClassColor))
	HeaderTimerBar:SetTemplate()
	HeaderTimerBar:CreateShadow()
	
	Timer:StripTextures()
	Timer:SetParent(UIParent)
	Timer:ClearAllPoints()
	Timer:SetPoint("TOPLEFT", HeaderBar, "TOPLEFT", -205, 80)
end

function ObjectiveTracker:OnQuestClick()
	ShowUIPanel(QuestLogFrame)

	QuestLog_SetSelection(self.Quest)
	
	QuestLog_Update()
end

function ObjectiveTracker:SetClickFrame(index, quest, text)
	if not ClickFrames[index] then
		ClickFrames[index] = CreateFrame("Frame")
		ClickFrames[index]:SetScript("OnMouseUp", self.OnQuestClick)
	end
	
	local Frame = ClickFrames[index]
	
	Frame:SetAllPoints(text)
	Frame.Quest = quest
end

function ObjectiveTracker:AddQuestClick()
	local Index = 0
	
	for i = 1, GetNumQuestWatches() do
		local Quest = GetQuestIndexForWatch(i)

		if Quest then
			local NumQuest = GetNumQuestLeaderBoards(Quest)

			if NumQuest > 0 then
				Index = Index + 1
				
				local Text = _G["QuestWatchLine"..Index]

				for j = 1, NumQuest do
					Index = Index + 1
				end

				ObjectiveTracker:SetClickFrame(i, Quest, Text)
			end
		end
	end
end

function ObjectiveTracker:AddHooks()
	hooksecurefunc("QuestWatch_Update", self.AddQuestClick)
end

function ObjectiveTracker:Enable()
	if self.IsEnabled then
		return
	end
	
	self:CreateHolder()
	self:SetDefaultPosition()
	self:Skin()
	self:SkinQuestTimer()
	self:AddHooks()
	
	self.IsEnabled = true
end

Misc.ObjectiveTracker = ObjectiveTracker