
CRAFTS_DISPLAYED = 8;
MAX_CRAFT_REAGENTS = 8;
CRAFT_SKILL_HEIGHT = 16;

CraftTypeColor = { };
CraftTypeColor["optimal"]	= { r = 1.00, g = 0.50, b = 0.25 };
CraftTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00 };
CraftTypeColor["easy"]		= { r = 0.25, g = 0.75, b = 0.25 };
CraftTypeColor["trivial"]	= { r = 0.50, g = 0.50, b = 0.50 };
CraftTypeColor["used"]	= { r = 0.50, g = 0.50, b = 0.50 };
CraftTypeColor["header"]	= { r = 1.00, g = 0.82, b = 0 };
CraftTypeColor["none"]		= { r = 0.25, g = 0.75, b = 0.25 };

CraftSubTypeColor = { };
CraftSubTypeColor["optimal"]	= { r = 1.00, g = 0.50, b = 0.25 };
CraftSubTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00 };
CraftSubTypeColor["easy"]		= { r = 0.25, g = 0.75, b = 0.25 };
CraftSubTypeColor["trivial"]	= { r = 0.50, g = 0.50, b = 0.50 };
CraftSubTypeColor["used"]	= { r = 0.50, g = 0.50, b = 0.50 };
CraftSubTypeColor["header"]	= { r = 1.00, g = 0.82, b = 0 };
CraftSubTypeColor["none"]		= { r = 0, g = 0.45, b = 0 };

UIPanelWindows["CraftFrame"] = { area = "left", pushable = 4 };

function CraftFrame_Show()
	ShowUIPanel(CraftFrame);
	if ( not CraftFrame:IsShown() ) then
		CloseCraft();
		return;
	end

	CraftCreateButton:Disable();	
	if ( GetNumCrafts() > 0 ) then
		-- Check to see if has headers, if so select the second slot if not select the first slot
		local indexToSelect;
		local craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(1);
		if ( craftType == "header" ) then
			indexToSelect = 2;
		else
			indexToSelect = 1;
		end
		CraftFrame_SetSelection(indexToSelect);
	end
	FauxScrollFrame_SetOffset(CraftListScrollFrame, 0);
	CraftListScrollFrameScrollBar:SetMinMaxValues(0, 0); 
	CraftListScrollFrameScrollBar:SetValue(0);
	CraftFrame_Update();
end

function CraftFrame_Hide()
	HideUIPanel(CraftFrame);
end

function CraftFrame_OnLoad()
	this:RegisterEvent("CRAFT_UPDATE");
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	this:RegisterEvent("SPELLS_CHANGED");
	this:RegisterEvent("UNIT_PET_TRAINING_POINTS");
	FauxScrollFrame_SetOffset(CraftListScrollFrame, 0);
end

function CraftFrame_OnEvent()
	if ( not this:IsShown() ) then
		return;
	end

	if ( event == "CRAFT_UPDATE" ) then
		CraftCreateButton:Disable();
		if ( GetCraftSelectionIndex() > 1 ) then
			CraftFrame_SetSelection(GetCraftSelectionIndex());
		else
			if ( GetNumCrafts() > 0 ) then
				-- Check to see if has headers, if so select the second slot if not select the first slot
				local indexToSelect;
				local craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(1);
				if ( craftType == "header" ) then
					indexToSelect = 2;
				else
					indexToSelect = 1;
				end
				CraftFrame_SetSelection(indexToSelect);
				FauxScrollFrame_SetOffset(CraftListScrollFrame, 0);
			end
			CraftListScrollFrameScrollBar:SetValue(0);
		end
		CraftFrame_Update();
	elseif ( event == "UNIT_PORTRAIT_UPDATE" ) then
		if ( arg1 == "player" ) then
			SetPortraitTexture(CraftFramePortrait, "player");
		end
	elseif ( event == "SPELLS_CHANGED" ) then
		CraftFrame_Update();
	elseif ( event == "UNIT_PET_TRAINING_POINTS" ) then
		Craft_UpdateTrainingPoints();
	end
end

function CraftFrame_Update()
	SetPortraitTexture(CraftFramePortrait, "player");
	CraftFrameTitleText:SetText(GetCraftName());
	
	local name, rank, maxRank = GetCraftDisplaySkillLine();
	local numCrafts = GetNumCrafts();
	local craftOffset = FauxScrollFrame_GetOffset(CraftListScrollFrame);

	if ( CraftIsEnchanting() ) then
		-- Hide the search box if skill less than 75	
		if ( rank < 75 ) then
			CraftFrameEditBox:Hide();
		else
			CraftFrameEditBox:Show();
		end
		CraftFrameFilterDropDown:Show();
		CraftFrameAvailableFilterCheckButton:Show();
	else
		CraftFrameEditBox:Hide();
		CraftFrameFilterDropDown:Hide();
		CraftFrameAvailableFilterCheckButton:Hide();
	end

	-- Set the action button text
	CraftCreateButton:SetText(getglobal(GetCraftButtonToken()));

	-- Set the craft skill line status bar info
	if ( name ) then
		CraftRankFrame:SetStatusBarColor(0.0, 0.0, 1.0, 0.5);
		CraftRankFrameBackground:SetVertexColor(0.0, 0.0, 0.75, 0.5);
		CraftRankFrame:SetMinMaxValues(0, maxRank);
		CraftRankFrame:SetValue(rank);
		CraftRankFrameSkillRank:SetText(rank.."/"..maxRank);
		CraftRankFrame:Show();
	else
		CraftRankFrame:Hide();
	end

	-- Hide the expand all button if less than 2 crafts learned	
	if ( numCrafts <=1 ) then
		CraftExpandButtonFrame:Hide();
	else
		CraftExpandButtonFrame:Show();
	end
	-- If no Crafts
	if ( numCrafts == 0 ) then
		CraftName:Hide();
		CraftRequirements:Hide();
		CraftIcon:Hide();
		CraftReagentLabel:Hide();
		CraftDescription:Hide();
		for i=1, MAX_CRAFT_REAGENTS, 1 do
			getglobal("CraftReagent"..i):Hide();
		end
		CraftDetailScrollFrameScrollBar:Hide();
		CraftDetailScrollFrameTop:Hide();
		CraftDetailScrollFrameBottom:Hide();
		CraftListScrollFrame:Hide();
		for i=1, CRAFTS_DISPLAYED, 1 do
			getglobal("Craft"..i):Hide();
		end
		CraftHighlightFrame:Hide();
		CraftRequirements:Hide();
		return;
	end
	
	-- If has crafts
	CraftName:Show();
	CraftRequirements:Show();
	CraftIcon:Show();
	CraftDescription:Show();
	CraftCollapseAllButton:Enable();
	
	-- ScrollFrame update
	FauxScrollFrame_Update(CraftListScrollFrame, numCrafts, CRAFTS_DISPLAYED, CRAFT_SKILL_HEIGHT, nil, nil, nil, CraftHighlightFrame, 293, 316 );
	
	CraftHighlightFrame:Hide();
	
	local craftIndex, craftName, craftButton, craftButtonSubText, craftButtonCost, craftButtonText;
	for i=1, CRAFTS_DISPLAYED, 1 do
		craftIndex = i + craftOffset;
		craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(craftIndex);
		craftButton = getglobal("Craft"..i);
		craftButtonSubText = getglobal("Craft"..i.."SubText");
		craftButtonCost = getglobal("Craft"..i.."Cost");
		craftButtonText = getglobal("Craft"..i.."Text");
		if ( craftIndex <= numCrafts ) then	
			-- Set button widths if scrollbar is shown or hidden
			if ( CraftListScrollFrame:IsShown() ) then
				craftButton:SetWidth(293);
				-- HACK to fix a bug with (Rank) rendering in Beast Training --
				if ( not trainingPointCost ) then
					craftButtonText:SetWidth(290);
				end
			else
				craftButton:SetWidth(323);
				-- HACK to fix a bug with (Rank) rendering in Beast Training --
				if ( not trainingPointCost ) then
					craftButtonText:SetWidth(320);
				end
			end
			local color = CraftTypeColor[craftType];
			local subColor = CraftSubTypeColor[craftType];
			craftButton:SetTextColor(color.r, color.g, color.b);
			craftButton.r = color.r;
			craftButton.g = color.g;
			craftButton.b = color.b;
			craftButtonCost:SetTextColor(color.r, color.g, color.b);
			craftButtonSubText:SetTextColor(color.r, color.g, color.b);
			craftButton:SetID(craftIndex);
			craftButton:Show();
			-- Handle headers
			if ( craftType == "header" ) then
				craftButton:SetText(craftName);
				craftButtonSubText:SetText("");
				if ( isExpanded ) then
					craftButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					craftButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
				getglobal("Craft"..i.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
				getglobal("Craft"..i):UnlockHighlight();
			else
				craftButton:SetNormalTexture("");
				getglobal("Craft"..i.."Highlight"):SetTexture("");
				if ( numAvailable == 0 ) then
					craftButton:SetText(" "..craftName);
				else
					craftButton:SetText(" "..craftName.." ["..numAvailable.."]");
				end
				if ( craftSubSpellName ~= "" ) then
					craftButtonSubText:SetText(format(PARENS_TEMPLATE, craftSubSpellName));
				else 
					craftButtonSubText:SetText("");
				end
				if ( trainingPointCost > 0 ) then
					craftButtonCost:SetText(format(TRAINER_LIST_TP, trainingPointCost));
				else
					craftButtonCost:SetText("");
				end
				craftButtonSubText:SetPoint("LEFT", "Craft"..i.."Text", "RIGHT", 10, 0);
				-- Place the highlight and lock the highlight state
				if ( GetCraftSelectionIndex() == craftIndex ) then
					CraftHighlightFrame:SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 0, 0);
					CraftHighlightFrame:Show();
					craftButtonSubText:SetTextColor(1.0, 1.0, 1.0);
					craftButtonCost:SetTextColor(1.0, 1.0, 1.0);
					getglobal("Craft"..i):LockHighlight();
				else
					getglobal("Craft"..i):UnlockHighlight();
				end
			end
			
		else
			craftButton:Hide();
		end
	end
	
	-- If player has training points show them here
	Craft_UpdateTrainingPoints();

	-- Set the expand/collapse all button texture
	local numHeaders = 0;
	local notExpanded = 0;
	for i=1, numCrafts, 1 do
		local craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(i);
		if ( craftName and craftType == "header" ) then
			numHeaders = numHeaders + 1;
			if ( not isExpanded ) then
				notExpanded = notExpanded + 1;
			end
		end
	end
	-- If all headers are not expanded then show collapse button, otherwise show the expand button
	if ( notExpanded ~= numHeaders ) then
		CraftCollapseAllButton.collapsed = nil;
		CraftCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	else
		CraftCollapseAllButton.collapsed = 1;
		CraftCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end

	-- If has headers show the expand all button
	if ( numHeaders > 0 ) then
		-- If has headers then move all the names to the right
		for i=1, CRAFTS_DISPLAYED, 1 do
			getglobal("Craft"..i.."Text"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 21, 0);
		end
		CraftExpandButtonFrame:Show();
	else
		-- If no headers then move all the names to the left
		for i=1, CRAFTS_DISPLAYED, 1 do
			getglobal("Craft"..i.."Text"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 3, 0);
		end
		CraftExpandButtonFrame:Hide();
	end
end

function CraftFrame_SetSelection(id)
	if ( not id ) then
		return;
	end
	local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(id);
	CraftHighlightFrame:Show();
	-- If the type of the selection is header, don't process all the craft details
	if ( craftType == "header" ) then
		CraftHighlightFrame:Hide();
		if ( isExpanded ) then
			CollapseCraftSkillLine(id);
		else
			ExpandCraftSkillLine(id);
		end
		return;
	end
	SelectCraft(id);
	if ( GetCraftSelectionIndex() > GetNumCrafts() ) then
		return;
	end
	local color = CraftTypeColor[craftType];
	CraftHighlight:SetVertexColor(color.r, color.g, color.b);

	-- General Info
	CraftName:SetText(craftName);

	-- Set cooldown data
	if ( GetCraftCooldown(id) ) then
		CraftCooldown:SetText(COOLDOWN_REMAINING.." "..SecondsToTime(GetCraftCooldown(id)));
	else
		CraftCooldown:SetText("");
	end
	
	-- Set Recipe Icon
	CraftIcon:SetNormalTexture(GetCraftIcon(id));
	
	-- Set number of items that are generated
	local minMade,maxMade = GetCraftNumMade(id);
	if ( maxMade > 1 ) then
		if ( minMade == maxMade ) then
			CraftIconCount:SetText(minMade);
		else
			CraftIconCount:SetText(minMade.."-"..maxMade);
		end
		if ( CraftIconCount:GetWidth() > 39 ) then
			CraftIconCount:SetText("~"..floor((minMade + maxMade)/2));
		end
	else
		CraftIconCount:SetText("");
	end

	if ( GetCraftDescription(id) ) then
		CraftDescription:SetText(GetCraftDescription(id));
		CraftReagentLabel:SetPoint("TOPLEFT", "CraftDescription", "BOTTOMLEFT", 0, -10);
	else
		CraftDescription:SetText(" ");
		CraftReagentLabel:SetPoint("TOPLEFT", "CraftDescription", "TOPLEFT", 0, 0);
	end
	
	-- Reagents
	local creatable = 1;
	local numReagents = GetCraftNumReagents(id);
	
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(id, i);
		local reagent = getglobal("CraftReagent"..i)
		local name = getglobal("CraftReagent"..i.."Name");
		local count = getglobal("CraftReagent"..i.."Count");
		if ( not reagentName or not reagentTexture ) then
			reagent:Hide();
		else
			reagent:Show();
			SetItemButtonTexture(reagent, reagentTexture);
			name:SetText(reagentName);
			-- Grayout items
			if ( playerReagentCount < reagentCount ) then
				SetItemButtonTextureVertexColor(reagent, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				name:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				creatable = nil;
			else
				SetItemButtonTextureVertexColor(reagent, 1.0, 1.0, 1.0);
				name:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			end
			if ( playerReagentCount >= 100 ) then
				playerReagentCount = "*";
			end
			count:SetText(playerReagentCount.." /"..reagentCount);
		end
	end
	
	if ( numReagents > 0 ) then
		CraftReagentLabel:Show();
	else
		CraftReagentLabel:Hide();
	end
	for i=numReagents + 1, MAX_CRAFT_REAGENTS, 1 do
		getglobal("CraftReagent"..i):Hide();
	end

	local requiredTotems = BuildColoredListString(GetCraftSpellFocus(id));
	if ( requiredTotems ) then
		CraftRequirements:SetText(REQUIRES_LABEL.." "..requiredTotems);
	elseif ( requiredLevel and requiredLevel > 0 ) then
		if ( UnitLevel("pet") >= requiredLevel ) then
			CraftRequirements:SetText(REQUIRES_LABEL.." "..format(TRAINER_PET_LEVEL, requiredLevel));
		else
			CraftRequirements:SetText(REQUIRES_LABEL.." "..format(TRAINER_PET_LEVEL_RED, requiredLevel));
		end
	else
		CraftRequirements:SetText("");
	end

	if ( trainingPointCost > 0 ) then
		local totalPoints, spent = GetPetTrainingPoints();
		local usablePoints = totalPoints - spent;
		if ( usablePoints >= trainingPointCost ) then
			CraftCost:SetText(COSTS_LABEL.." "..trainingPointCost.." "..TRAINING_POINTS_LABEL);
		else
			CraftCost:SetText(COSTS_LABEL.." "..RED_FONT_COLOR_CODE..trainingPointCost..FONT_COLOR_CODE_CLOSE.." "..TRAINING_POINTS_LABEL);
		end
		
		CraftCost:Show();
	else
		CraftCost:Hide();
	end

	if ( craftType == "used" ) then
		creatable = nil;
	end

	if ( creatable ) then
		CraftCreateButton:Enable();
	else
		CraftCreateButton:Disable();
	end
	CraftDetailScrollFrame:UpdateScrollChildRect();
	-- Show or hide scrollbar
	if ((CraftDetailScrollFrameScrollBarScrollUpButton:IsEnabled() == 0) and (CraftDetailScrollFrameScrollBarScrollDownButton:IsEnabled() == 0) ) then
		CraftDetailScrollFrameScrollBar:Hide();
		CraftDetailScrollFrameTop:Hide();
		CraftDetailScrollFrameBottom:Hide();
	else
		CraftDetailScrollFrameScrollBar:Show();
		CraftDetailScrollFrameTop:Show();
		CraftDetailScrollFrameBottom:Show();
	end
end

function CraftButton_OnClick(button)
	if ( button == "LeftButton" ) then
		CraftFrame_SetSelection(this:GetID());
		CraftFrame_Update();
	end
end

function CraftCollapseAllButton_OnClick()
	if (this.collapsed) then
		this.collapsed = nil;
		ExpandCraftSkillLine(0);
	else
		this.collapsed = 1;
		CraftListScrollFrameScrollBar:SetValue(0);
		CollapseCraftSkillLine(0);
	end
end

function CraftFilter_OnTextChanged()
	local text = this:GetText();

	if ( text == SEARCH ) then
		SetCraftItemNameFilter("");
		return;
	end
	SetCraftItemNameFilter(text);
end

function Craft_UpdateTrainingPoints()
	local totalPoints, spent = GetPetTrainingPoints();
	if ( totalPoints > 0 ) then
		CraftFramePointsLabel:Show();
		CraftFramePointsText:Show();
		CraftFramePointsText:SetText(totalPoints - spent);
	else
		CraftFramePointsLabel:Hide();
		CraftFramePointsText:Hide();
	end	
end

function CraftFrameFilterDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CraftFrameFilterDropDown_Initialize);
	UIDropDownMenu_SetWidth(120);
	UIDropDownMenu_SetSelectedID(CraftFrameFilterDropDown, 1);
end

function CraftFrameFilterDropDown_OnShow()
	-- Hack to quickly reset the ShowMakeable filter
	CraftOnlyShowMakeable(0);
	CraftFrameAvailableFilterCheckButton:SetChecked(0);
	UIDropDownMenu_Initialize(this, CraftFrameFilterDropDown_Initialize);
	if ( GetCraftFilter(0) ) then
		UIDropDownMenu_SetSelectedID(CraftFrameFilterDropDown, 1);
	end
end

function CraftFrameFilterDropDown_Initialize()
	CraftFrameFilterDropDown_LoadInvSlots(GetCraftSlots());
end

function CraftFrameFilterDropDown_LoadInvSlots(...)
	local allChecked = GetCraftFilter(0);
	local info = UIDropDownMenu_CreateInfo();
	if ( select("#", ...) > 1 ) then
		info.text = ALL_INVENTORY_SLOTS;
		info.func = CraftFrameFilterDropDown_OnClick;
		info.checked = allChecked;
		UIDropDownMenu_AddButton(info);
	end
	
	local checked;
	for i=1, select("#", ...), 1 do
		if ( allChecked and select("#", ...) > 1 ) then
			checked = nil;
			UIDropDownMenu_SetText(ALL_INVENTORY_SLOTS, CraftFrameFilterDropDown);
		else
			checked = GetCraftFilter(i);
			if ( checked ) then
				UIDropDownMenu_SetText(getglobal(select(i, ...)), CraftFrameFilterDropDown);
			end
		end
		info.text = getglobal(select(i, ...));
		info.func = CraftFrameFilterDropDown_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
	end
end

function CraftFrameFilterDropDown_OnClick()	
	UIDropDownMenu_SetSelectedID(CraftFrameFilterDropDown, this:GetID());
	SetCraftFilter(this:GetID());
end
