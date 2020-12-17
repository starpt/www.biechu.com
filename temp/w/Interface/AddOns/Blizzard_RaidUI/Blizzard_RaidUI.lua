MAX_RAID_GROUPS = 8;
MOVING_RAID_MEMBER = nil;
TARGET_RAID_SLOT = nil;
RAID_SUBGROUP_LISTS = {};
NUM_RAID_PULLOUT_FRAMES = 0;
RAID_PULLOUT_BUTTON_HEIGHT = 40;
MOVING_RAID_PULLOUT = nil;
RAID_PULLOUT_POSITIONS = {};
RAID_SINGLE_POSITIONS = {};

RAID_CLASS_BUTTONS = {
	["WARRIOR"]	= {button = 1, coords = {0, 0.25, 0, 0.25};},
	["MAGE"]		= {button = 7, coords = {0.25, 0.49609375, 0, 0.25};},
	["ROGUE"]		= {button = 6, coords = {0.49609375, 0.7421875, 0, 0.25};},
	["DRUID"]		= {button = 5, coords = {0.7421875, 0.98828125, 0, 0.25};},
	["HUNTER"]		= {button = 9, coords = {0, 0.25, 0.25, 0.5};},
	["SHAMAN"]	 	= {button = 4, coords = {0.25, 0.49609375, 0.25, 0.5};},
	["PRIEST"]		= {button = 3, coords = {0.49609375, 0.7421875, 0.25, 0.5};},
	["WARLOCK"]	= {button = 8, coords = {0.7421875, 0.98828125, 0.25, 0.5};},
	["PALADIN"]		= {button = 2, coords = {0, 0.25, 0.5, 0.75};},
	["PETS"]		= {button = 10, coords = {0, 1, 0, 1};},
	["MAINTANK"]	= {button = 11, coords = {0, 1, 0, 1};},
	["MAINASSIST"]	= {button = 12, coords = {0, 1, 0, 1};}
};
MAX_CLASSES = 12;

function RaidClassButton_OnLoad()
	this:RegisterForDrag("LeftButton");
	local id = this:GetID();
	local icon = getglobal(this:GetName().."IconTexture");
	for index, value in pairs(RAID_CLASS_BUTTONS) do
		if ( id ==  value.button ) then
			this.class = index;
			if ( index == "PETS" ) then
				icon:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-Pets");
			elseif ( index == "MAINTANK" ) then
				icon:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-MainTank");
			elseif ( index == "MAINASSIST" ) then
				icon:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-MainAssist");
			else
				icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
			end
			icon:SetTexCoord(value.coords[1], value.coords[2], value.coords[3], value.coords[4]);

		end
	end
	getglobal(this:GetName().."Count"):SetTextHeight(9);
end

function RaidClassButton_Update()
	-- Update Actual Count
	local button, icon, count;
	for index, value in pairs(RAID_CLASS_BUTTONS) do
		button  = getglobal("RaidClassButton"..value.button);
		count = getglobal("RaidClassButton"..value.button.."Count");
		icon = getglobal("RaidClassButton"..value.button.."IconTexture");

		if ( index == "PETS" ) then
			local petCount = 0;
			for i, v in pairs(RAID_SUBGROUP_LISTS[index]) do
				if ( UnitExists("raidpet"..RAID_SUBGROUP_LISTS[index][i]) ) then
					petCount = petCount + 1;
				end
			end
			button.count = petCount;
		else
			local countValue = getn(RAID_SUBGROUP_LISTS[index]);
			if ( countValue ) then
				button.count = countValue;
			end
		end
		
		if ( button.count > 0 ) then
			SetItemButtonDesaturated(button, nil);
			icon:SetAlpha(1);
			count:SetText(button.count);
			count:Show();
			if ( index == "PETS" ) then
				button.class = PETS;
				button.fileName = index;
			elseif ( index == "MAINTANK" ) then
				button.class = MAINTANK;
				button.fileName = index;
				button.id = RAID_SUBGROUP_LISTS[index][1];
				count:Hide();
			elseif ( index == "MAINASSIST"  ) then
				button.class = MAINASSIST;
				button.fileName = index;
				button.id = RAID_SUBGROUP_LISTS[index][1];
				count:Hide();
			else
				button.class, button.fileName = UnitClass("raid"..RAID_SUBGROUP_LISTS[index][1]);
			end
			button:Enable();
		else
			button:Disable();
			icon:SetAlpha(0.5);
			SetItemButtonDesaturated(button, 1);
			count:Hide();
			button.class = nil;
			button.fileName = nil;
		end
	end
end

function RaidClassButton_OnEnter()
	this.tooltip = this.class..NORMAL_FONT_COLOR_CODE.." ("..this.count..")"..FONT_COLOR_CODE_CLOSE;
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
	GameTooltip:SetText(this.tooltip, 1, 1, 1, 1, 1);
	local classList;
	if ( getn(RAID_SUBGROUP_LISTS[this.fileName]) > 0 ) then
		local unit = "raid";
		if ( this.fileName == "PETS" ) then
			unit = "raidpet";
		end
		for index, value in pairs(RAID_SUBGROUP_LISTS[this.fileName]) do
			if (  UnitExists(unit..value) ) then
				if ( classList ) then
					classList = classList..", "..UnitName(unit..value);
				else
					classList = UnitName(unit..value);
				end
			end
		end
	end
	GameTooltip:AddLine(classList, 1, 1, 1);
	GameTooltip:AddLine(TOOLTIP_RAID_CLASS_BUTTON, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	GameTooltip:Show();
end

function RaidGroupFrame_OnLoad()
	RaidFrame:RegisterEvent("UNIT_PET");
	RaidFrame:RegisterEvent("UNIT_NAME_UPDATE");
	RaidFrame:RegisterEvent("UNIT_LEVEL");
	RaidFrame:RegisterEvent("UNIT_HEALTH");
	RaidFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	RaidFrame:SetScript("OnHide", RaidGroupFrame_OnHide);
	RaidFrame:SetScript("OnEvent", RaidGroupFrame_OnEvent);
	RaidFrame:SetScript("OnUpdate", RaidGroupFrame_OnUpdate);
end

function RaidGroupFrame_OnHide()
	-- If there's a selected button then call the onmouseup function on it when the frame is hidden
	if ( MOVING_RAID_MEMBER ) then
		RaidGroupButton_OnDragStop(MOVING_RAID_MEMBER);
	end
end

function RaidGroupFrame_OnEvent()
	RaidFrame_OnEvent();
	if ( event == "UNIT_LEVEL" ) then
		local id, found = gsub(arg1, "raid([0-9]+)", "%1");
		if ( found == 1 ) then
			RaidGroupFrame_UpdateLevel(id);
		end
	end
	if ( event == "UNIT_HEALTH" ) then
		local id, found = gsub(arg1, "raid([0-9]+)", "%1");
		if ( found == 1 ) then
			RaidGroupFrame_UpdateHealth(id);
		end
	end
	if ( event == "UNIT_PET" or event == "UNIT_NAME_UPDATE" ) then
		RaidClassButton_Update();
	end
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		RaidFrameReadyCheckButton_Update();
		RaidFrameAddMemberButton_Update();
		RaidPullout_RenewFrames();
	end
end

function RaidGroupFrame_Update()

	-- Update raid group labels
	if ( GetNumRaidMembers() == 0 ) then
		for i=1, NUM_RAID_GROUPS do
			getglobal("RaidGroup"..i):Hide();
		end
		for i=1, MAX_CLASSES do
			getglobal("RaidClassButton"..i):Hide();
		end
		RaidFrameReadyCheckButton:Hide();
	else
		for i=1, NUM_RAID_GROUPS do
			getglobal("RaidGroup"..i):Show();
		end
		for i=1, MAX_CLASSES do
			getglobal("RaidClassButton"..i):Show();
		end
	end

	RaidFrameReadyCheckButton_Update();
	RaidFrameAddMemberButton_Update();
	if ( RaidFrameReadyCheckButton:IsShown() ) then
		RaidFrameRaidInfoButton:SetPoint("LEFT", "RaidFrameReadyCheckButton", "RIGHT", 2, 0);
	end


	-- Reset group index counters;
	for i=1, NUM_RAID_GROUPS do
		getglobal("RaidGroup"..i).nextIndex = 1;
	end
	-- Clear out all the slots buttons
	RaidGroup_ResetSlotButtons();

	-- Clear out subgroup list
	RAID_SUBGROUP_LISTS = {};
	for i=1, NUM_RAID_GROUPS do
		RAID_SUBGROUP_LISTS[i] = {};
	end

	-- Use the class color list to clear out the class list
	for index, value in pairs(RAID_CLASS_BUTTONS) do
		RAID_SUBGROUP_LISTS[index] = {};
	end

	-- Fill out buttons
	local numRaidMembers = GetNumRaidMembers();
	local raidGroup, color;
	local buttonName, buttonLevel, buttonClass, buttonRank;
	local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, loot;
	local buttons = {};
	local buttonCount;
	for i=1, MAX_RAID_MEMBERS do
		button = getglobal("RaidGroupButton"..i);
		if ( i <= numRaidMembers ) then
			name, rank, subgroup, level, class, fileName, zone, online, isDead, role, loot = GetRaidRosterInfo(i);
			raidGroup = getglobal("RaidGroup"..subgroup);
			-- To prevent errors when the server hiccups
			if ( raidGroup.nextIndex <= MEMBERS_PER_RAID_GROUP ) then
				buttonName = getglobal("RaidGroupButton"..i.."Name");
				buttonClass = getglobal("RaidGroupButton"..i.."Class");
				buttonLevel = getglobal("RaidGroupButton"..i.."Level");
				buttonRank = getglobal("RaidGroupButton"..i.."Rank");
				buttonRole = getglobal("RaidGroupButton"..i.."Role");
				buttonLoot = getglobal("RaidGroupButton"..i.."Loot");
				buttonRankTexture = getglobal("RaidGroupButton"..i.."RankTexture");
				buttonRoleTexture = getglobal("RaidGroupButton"..i.."RoleTexture");
				buttonLootTexture = getglobal("RaidGroupButton"..i.."LootTexture");
				
				button.name = name;
				button.class = fileName;

				if ( level == 0 ) then
					level = "";
				end
				
				if ( not name ) then
					name = UNKNOWN;
				end

				-- Fill in subgroup list
				tinsert(RAID_SUBGROUP_LISTS[subgroup], i);

				-- Fill in class list
				if ( fileName ) then
					tinsert(RAID_SUBGROUP_LISTS[fileName], i);
					--if ( UnitExists("raidpet"..i) ) then
					if ( fileName == "HUNTER" or fileName == "WARLOCK" ) then
						tinsert(RAID_SUBGROUP_LISTS["PETS"], i);
					end		
					--end
				end
				
				-- Place Main Tank & Main Assist into a subgroup
				if ( role ) then
					tinsert(RAID_SUBGROUP_LISTS[role], i);
				end

				buttonName:SetText(name);
				if ( class ) then
					buttonClass:SetText(class);
				else
					buttonClass:SetText("");
				end
				if ( level ) then
					buttonLevel:SetText(level);
				else
					buttonLevel:SetText("");
				end
				if ( online ) then
					if ( isDead ) then
						buttonName:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
						buttonClass:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
						buttonLevel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
					else
						color = RAID_CLASS_COLORS[fileName];
						if ( color ) then
							buttonName:SetTextColor(color.r, color.g, color.b);
							buttonClass:SetTextColor(color.r, color.g, color.b);
							buttonLevel:SetTextColor(color.r, color.g, color.b);
						end
					end
				else
					buttonName:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					buttonClass:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					buttonLevel:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				end

				-- Sets the Leader/Assistant Icon
				if ( rank == 2 ) then
					buttonRankTexture:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon");
				elseif ( rank == 1 ) then
					buttonRankTexture:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon");
				else 
					buttonRankTexture:SetTexture("");
				end
			
				-- Sets the Main Tank/Assist Icon
				if ( role == "MAINTANK" ) then
					buttonRoleTexture:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon");
				elseif (role == "MAINASSIST" ) then
					buttonRoleTexture:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon");
				else
					buttonRoleTexture:SetTexture("");
				end

				-- Sets the Master Looter Icon
				if ( loot ) then
					buttonLootTexture:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter");
				else
					buttonLootTexture:SetTexture("");
				end
				
				-- Resizes if there are all 3 visible
				if ( ( rank > 0 ) and role and loot ) then
					buttonRank:SetWidth(10);
					buttonRank:SetHeight(10);
					buttonRole:SetWidth(10);
					buttonRole:SetHeight(10);
					buttonLoot:SetWidth(9);
					buttonLoot:SetHeight(9);
				else
					buttonRank:SetWidth(11);
					buttonRank:SetHeight(11);
					buttonRole:SetWidth(11);
					buttonRole:SetHeight(11);
					buttonLoot:SetWidth(11);
					buttonLoot:SetHeight(11);
				end
				
				buttons = {};

				if ( rank > 0 ) then
					tinsert(buttons, buttonRank);
				else
					buttonRank:Hide();
				end

				if ( role ) then
					tinsert(buttons, buttonRole);			
				else
					buttonRole:Hide();
				end

				if ( loot ) then
					tinsert(buttons, buttonLoot);			
				else
					buttonLoot:Hide();
				end

				buttonCount = getn(buttons);
				
				for i=1, buttonCount, 1 do
					if ( i == 1 ) then
						buttons[i]:SetPoint("LEFT", button, "LEFT", 2, 0);
					else
						buttons[i]:SetPoint("LEFT", buttons[i-1], "RIGHT", -1, 0);
					end
					buttons[i]:Show();
				end

				-- Anchor button to slot
				if ( MOVING_RAID_MEMBER ~= button  ) then
					button:SetPoint("TOPLEFT", "RaidGroup"..subgroup.."Slot"..raidGroup.nextIndex, "TOPLEFT", 0, 0);
				end
				
				-- Save slot for future use
				button.slot = "RaidGroup"..subgroup.."Slot"..raidGroup.nextIndex;
				-- Save the button's subgroup too
				button.subgroup = subgroup;
				-- Tell the slot what button is in it
				getglobal("RaidGroup"..subgroup.."Slot"..raidGroup.nextIndex).button = button:GetName();
				raidGroup.nextIndex = raidGroup.nextIndex + 1;
				button.rank = rank;
				button.role = role;
				button.loot = loot;
				button:SetID(i);
				button:Show();
			end
		else
			button:Hide();
		end
	end
	
	-- Update Class Count Buttons
	RaidClassButton_Update();
end

function RaidGroupFrame_UpdateLevel(id)
	local unit = "raid"..id;
	local buttonLevel = getglobal("RaidGroupButton"..id.."Level");

	buttonLevel:SetText(UnitLevel(unit));
end

function RaidGroupFrame_UpdateHealth(id)
	local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(id);

	local buttonName = getglobal("RaidGroupButton"..id.."Name");
	local buttonClass = getglobal("RaidGroupButton"..id.."Class");
	local buttonLevel = getglobal("RaidGroupButton"..id.."Level");

	if ( online ) then
		if ( isDead ) then
			buttonName:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			buttonClass:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			buttonLevel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		else
			color = RAID_CLASS_COLORS[fileName];
			if ( color ) then
				buttonName:SetTextColor(color.r, color.g, color.b);
				buttonClass:SetTextColor(color.r, color.g, color.b);
				buttonLevel:SetTextColor(color.r, color.g, color.b);
			end
		end
	else
		buttonName:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		buttonClass:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		buttonLevel:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
end

function RaidGroupFrame_OnUpdate(elapsed)
	if ( MOVING_RAID_MEMBER ) then
		local button, slot;
		TARGET_RAID_SLOT = nil;
		for i=1, NUM_RAID_GROUPS do
			for j=1, MEMBERS_PER_RAID_GROUP do
				slot = getglobal("RaidGroup"..i.."Slot"..j);
				if ( MouseIsOver(slot) ) then
					slot:LockHighlight();
					TARGET_RAID_SLOT = slot;
				else
					slot:UnlockHighlight();
				end
			end
		end
	end
end

function RaidGroupButton_ShowMenu()
	HideDropDownMenu(1);
	if ( this.id and this.name ) then
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize;
		FriendsDropDown.displayMode = "MENU";
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor");
	end
end

function RaidGroupButton_OnLoad(raidButton)
	this:SetFrameLevel(this:GetFrameLevel() + 2);
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this.raidButton = raidButton;
	
	if ( not raidButton ) then
		raidButton = this;
	end	

	raidButton.id = raidButton:GetID();
	raidButton.unit = "raid"..raidButton.id;
end

function RaidGroupButton_OnDragStart(raidButton)
	if ( not IsRaidLeader() and not IsRaidOfficer() ) then
		return;
	end
	if ( not raidButton ) then
		raidButton = this;
	end	
	local cursorX, cursorY = GetCursorPosition();
	raidButton:StartMoving();
	raidButton:ClearAllPoints();
	raidButton:SetPoint("CENTER", nil, "BOTTOMLEFT", cursorX*GetScreenWidthScale(), cursorY*GetScreenHeightScale());
	MOVING_RAID_MEMBER = raidButton;
	SetRaidRosterSelection(raidButton.id);
end

function RaidGroupButton_OnDragStop(raidButton)
	if ( not IsRaidLeader() and not IsRaidOfficer() ) then
		return;
	end
	if ( not raidButton ) then
		raidButton = this;
	end
	
	raidButton:StopMovingOrSizing();
	MOVING_RAID_MEMBER = nil;
	if ( TARGET_RAID_SLOT and TARGET_RAID_SLOT:GetParent():GetID() ~= raidButton.subgroup ) then
		if (TARGET_RAID_SLOT.button) then
			local button = getglobal(TARGET_RAID_SLOT.button);
			--button:SetPoint("TOPLEFT", this, "TOPLEFT", 0, 0);
			SwapRaidSubgroup(raidButton:GetID(), button:GetID());
		else
			local slot = TARGET_RAID_SLOT:GetParent():GetName().."Slot"..TARGET_RAID_SLOT:GetParent().nextIndex;
			raidButton:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 0);
			TARGET_RAID_SLOT:UnlockHighlight();
			SetRaidSubgroup(raidButton:GetID(), TARGET_RAID_SLOT:GetParent():GetID());
		end
	else
		if ( TARGET_RAID_SLOT ) then
			TARGET_RAID_SLOT:UnlockHighlight();
		end
		raidButton:SetPoint("TOPLEFT", raidButton.slot, "TOPLEFT", 0, 0);
	end
end

function RaidGroupButton_OnEnter(raidbutton)
	local unit = raidbutton.unit;

	if ( SpellIsTargeting() ) then
		if ( SpellCanTargetUnit(unit) ) then
			SetCursor("CAST_CURSOR");
		else
			SetCursor("CAST_ERROR_CURSOR");
		end
	end

	GameTooltip_SetDefaultAnchor(GameTooltip, raidbutton);

	if ( GameTooltip:SetUnit(unit) ) then
		raidbutton.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		raidbutton.updateTooltip = nil;
	end

	raidbutton.r, raidbutton.g, raidbutton.b = GameTooltip_UnitColor(unit);
	GameTooltipTextLeft1:SetTextColor(raidbutton.r, raidbutton.g, raidbutton.b);
end

function RaidFrameDropDown_Initialize()
	UnitPopup_ShowMenu(getglobal(UIDROPDOWNMENU_OPEN_MENU), "RAID", this.unit, this.name, this.id);
end

function RaidGroup_ResetSlotButtons()
	for i=1, NUM_RAID_GROUPS do
		for j=1, MEMBERS_PER_RAID_GROUP do
			getglobal("RaidGroup"..i.."Slot"..j).button = nil;
		end
	end
end

function RaidButton_OnClick()
	SetRaidRosterSelection(this.index);
	RaidFrame_Update();
end

-------------------- Pullout Button Functions --------------------
function RaidPullout_OnEvent()
	if ( ( event == "RAID_ROSTER_UPDATE" or event == "UNIT_PET" or event == "UNIT_NAME_UPDATE" ) and this:IsShown() ) then
		RaidPullout_Update();	
	end
end

function RaidPullout_GeneratePulloutFrame(fileName, class)
	-- Get a handle on a pullout frame
	local pullOutFrame = RaidPullout_GetFrame(fileName);
	if ( pullOutFrame ) then
		local pullOutName = getglobal(pullOutFrame:GetName().."Name");

		pullOutFrame.filterID = fileName;
		pullOutFrame.showBuffs = nil;

		-- Set pullout name
		if ( class ) then
			pullOutFrame.class = class;
			pullOutName:SetText(class);
		elseif ( tonumber(fileName) ) then
			pullOutName:SetText(GROUP.." "..fileName);
		else
			pullOutName:SetText("");
		end

		if ( fileName == "MAINTANK" or fileName == "MAINASSIST" ) then
			pullOutFrame.showTarget = 1;
			if (  fileName == "MAINTANK" ) then
				pullOutFrame.showTargetTarget = 1;
			else 
				pullOutFrame.showTargetTarget = nil;
			end
		elseif ( class ) then
			pullOutFrame.showTargetTarget = nil;
			pullOutFrame.showTarget = nil;
			pullOutFrame.name = nil;
		end

		if ( RaidPullout_Update(pullOutFrame) ) then
			return pullOutFrame;		
		end
	end
end

function RaidPullout_UpdateTarget(pullOutFrame, pullOutButton, unit, which)
	pullOutFrame = getglobal(pullOutFrame);
	local statusBar = getglobal(pullOutButton..which);
	local name = getglobal(pullOutButton..which.."Name");
	local frame = getglobal(pullOutButton..which.."Frame");
	if ( not pullOutFrame.showTarget ) then
		pullOutFrame.showTargetTarget = nil;
	end
	if ( pullOutFrame["show"..which] ) then
		if ( ( not getglobal(pullOutFrame:GetName().."MenuBackdrop"):IsShown() ) and which == "TargetTarget" ) then
			frame:Hide();
		else
			frame:Show();
		end
		statusBar:Show();
	
		if ( UnitName(unit) ) then
			-- Init the Healthbars
			local temp, class = UnitClass(unit);
			name:SetText(UnitName(unit));
			UnitFrameHealthBar_Initialize(unit, statusBar);
			UnitFrameHealthBar_Update(statusBar, unit);
			
			-- If Unknown, turn the bar grey and fill it
			if ( not class ) then
				statusBar:SetMinMaxValues(0,1);
				statusBar:SetValue(1);
				statusBar:SetStatusBarColor(0.5, 0.5, 0.5, 1.0);
			end

			-- Color the name if the unit is a player
			if ( UnitCanCooperate("player", unit) ) then
				local color = RAID_CLASS_COLORS[class];
				if ( color ) then
					name:SetVertexColor(color.r, color.g, color.b);
				end
			else
				name:SetVertexColor(1.0, 0.82, 0);
			end

			local r, g, b;
			if ( UnitPlayerControlled(unit) ) then
				-- Color the name if the unit is a player
				if ( UnitCanAttack(unit, "player") ) then
					if ( not UnitCanAttack("player", unit) ) then
						r = 0.0;
						g = 1.0;
						b = 0.0;
					else
						-- Hostile players are red
						r = UnitReactionColor[2].r;
						g = UnitReactionColor[2].g;
						b = UnitReactionColor[2].b;
					end
				elseif ( UnitCanAttack("player", unit) ) then
					-- Players we can attack but which are not hostile are yellow
					r = UnitReactionColor[4].r;
					g = UnitReactionColor[4].g;
					b = UnitReactionColor[4].b;
				elseif ( UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player") ) then
					-- Players we can assist but are PvP flagged are green
					r = UnitReactionColor[6].r;
					g = UnitReactionColor[6].g;
					b = UnitReactionColor[6].b;
				else
					-- All other players are blue (the usual state on the "blue" server)
					r = 0.0;
					g = 1.0;
					b = 0.0;
				end
				statusBar:SetStatusBarColor(r, g, b);
			else
				local reaction = UnitReaction(unit, "player");
				if ( reaction ) then
					r = UnitReactionColor[reaction].r;
					g = UnitReactionColor[reaction].g;
					b = UnitReactionColor[reaction].b;
					statusBar:SetStatusBarColor(r, g, b);
				else
					statusBar:SetStatusBarColor(0, 1.0, 0);
				end
			end
			name:Show();

		else
			statusBar:SetMinMaxValues(0,1);
			statusBar:SetValue(1);
			name:SetText("");
			name:Hide();							
			statusBar:SetStatusBarColor(0.5, 0.5, 0.5, 1.0);
			if ( which == "TargetTarget" ) then
				statusBar:Hide();
				frame:Hide();
			else
				frame:Show();
				statusBar:Show();
			end
		end
	else
		statusBar:Hide();
		name:Hide();
		frame:Hide();
	end
end

function RaidPullout_OnUpdate()
	local elapsed = arg1;
	if ( getglobal(this:GetName().."Target"):IsVisible() ) then
		if ( not this.timer ) then
			this.timer = .25;
		elseif ( this.timer < 0 ) then
			local parent = this:GetParent():GetName();
			local frame = this:GetName();
			RaidPullout_UpdateTarget(parent, frame, this.unit.."target", "Target");
			if ( this:GetParent().showTargetTarget ) then
				RaidPullout_UpdateTarget(parent, frame, this.unit.."targettarget", "TargetTarget");
			end
			this.timer = .25;
		else
			this.timer = this.timer - elapsed;
		end
	end
end

function RaidPullout_Update(pullOutFrame)
	if ( not pullOutFrame ) then
		pullOutFrame = this;
	end
	local id, single;
	local filterID = pullOutFrame.filterID;
	local numPulloutEntries = 0;
	if ( RAID_SUBGROUP_LISTS[filterID] ) then
		numPulloutEntries = getn(RAID_SUBGROUP_LISTS[filterID]);
		-- Hide the pullout if no entries
		if ( numPulloutEntries == 0 ) then
			pullOutFrame:Hide();
			return nil;
		end
	else
		numPulloutEntries = 1;
		single = 1;
	end
	local pulloutList = RAID_SUBGROUP_LISTS[filterID];

	-- Fill out the buttons
	local pulloutButton, pulloutButtonName, color, unit, target;
	local pulloutHealthBar, pulloutManaBar;
	local pulloutClearButton;
	if ( numPulloutEntries > pullOutFrame.numPulloutButtons ) then
		local index = pullOutFrame.numPulloutButtons + 1;
		local relative;
		for i=index, numPulloutEntries do
			pulloutButton = CreateFrame("Frame", pullOutFrame:GetName().."Button"..i, pullOutFrame, "RaidPulloutButtonTemplate");
			if ( i == 1 ) then
				pulloutButton:SetPoint("TOP", pullOutFrame, "TOP", 1, -10);
			else
				relative = getglobal(pullOutFrame:GetName().."Button"..(i-1));
				pulloutButton:SetPoint("TOP", relative, "BOTTOM", 0, -8);
			end
		end
		pullOutFrame.numPulloutButtons = numPulloutEntries;
	end
	-- Populate Data
	local name, rank, subgroup, level, class, fileName, zone, online, isDead, role;
	local debuff;
	for i=1, pullOutFrame.numPulloutButtons do
		pulloutButton = getglobal(pullOutFrame:GetName().."Button"..i);
		if ( i <= numPulloutEntries ) then
			pulloutButtonName = getglobal(pulloutButton:GetName().."Name");
			pulloutHealthBar = getglobal(pulloutButton:GetName().."HealthBar");
			pulloutManaBar = getglobal(pulloutButton:GetName().."ManaBar");
			if ( pulloutList ) then
				id = pulloutList[i];
			elseif ( single ) then
				id = RaidPullout_MatchName(filterID);
			end
			-- Hide the pullout if no name
			if ( single and pullOutFrame:IsShown() ) then
				if ( not id ) then
					pullOutFrame:Hide();
					return nil;
				end
			end

			name, rank, subgroup, level, class, fileName, zone, online, isDead, role = GetRaidRosterInfo(id);

			pulloutButton:SetScript("OnUpdate", RaidPullout_OnUpdate);

			if ( pullOutFrame.showTarget ) then
				pulloutButton:SetHeight(40);
			else
				pulloutButton:SetHeight(25);
			end

			-- Set Unit Values
			if ( filterID == "PETS" ) then
				unit = "raidpet"..id;
				if ( not UnitExists("raidpet"..id) ) then
					online = nil;
				end
			else
				unit = "raid"..id;
			end

			name = UnitName(unit);
			pulloutButtonName:SetText(name);
			pulloutButton.unit = unit;
			
			-- Set for tooltip support
			pulloutClearButton = getglobal(pulloutButton:GetName().."ClearButton");
			SecureUnitButton_OnLoad(pulloutClearButton, unit, RaidPulloutButton_ShowMenu);
			pullOutFrame.name = name;
			pullOutFrame.single = single;
			pulloutButton.raidIndex = id;
			pulloutButton.manabar = pulloutManaBar;
			pulloutManaBar.unit = unit;

			UnitFrameHealthBar_Initialize(unit, pulloutHealthBar);
			UnitFrameManaBar_Initialize(unit, pulloutManaBar);
			UnitFrameHealthBar_Update(pulloutHealthBar, unit);
			UnitFrameManaBar_Update(pulloutManaBar, unit);

			local minVal, maxVal;
			if ( online ) then	
				RaidPulloutButton_UpdateDead(pulloutButton, isDead, fileName);
			else
				-- Offline so set the bars and name grey
				pulloutButtonName:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
			end
			
			-- Handle unit's target
			RaidPullout_UpdateTarget(pullOutFrame:GetName(), pulloutButton:GetName(), pulloutButton.unit.."target", "Target");
			RaidPullout_UpdateTarget(pullOutFrame:GetName(), pulloutButton:GetName(), pulloutButton.unit.."targettarget", "TargetTarget");
			
			-- Handle buffs/debuffs
			RefreshBuffs(pulloutButton, pullOutFrame.showBuffs, unit);

			pulloutButton:RegisterEvent("UNIT_HEALTH");
			pulloutButton:RegisterEvent("UNIT_AURA");
			pulloutButton:RegisterEvent("UNIT_NAME_UPDATE");
			pulloutButton:Show();
		else
			pulloutButton:UnregisterEvent("UNIT_HEALTH");
			pulloutButton:UnregisterEvent("UNIT_AURA");
			pulloutButton:UnregisterEvent("UNIT_NAME_UPDATE");
			pulloutButton:Hide();
		end
	end

	local buttonHeight = RAID_PULLOUT_BUTTON_HEIGHT;
	local height;

	if ( numPulloutEntries == 1 ) then
		buttonHeight = buttonHeight + 8;
	end

	if ( pullOutFrame.showTarget ) then
		buttonHeight = buttonHeight + 14;
	end
	
	pullOutFrame:SetHeight(numPulloutEntries * buttonHeight);
	pullOutFrame:Show();
	return 1;
end

function RaidPulloutButton_OnEvent()
	local speaker = getglobal(this:GetName().."Speaker");
	if ( event == "UNIT_HEALTH" ) then
		if ( arg1 == this.unit ) then
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(this.raidIndex);
			if ( online ) then
				RaidPulloutButton_UpdateDead(this, isDead, fileName);
			end
		end
	elseif ( event == "UNIT_AURA" ) then
		if ( arg1 == this.unit ) then
			RefreshBuffs(this, this:GetParent().showBuffs, this.unit);
		end
	end
end

function RaidPulloutButton_UpdateDead(button, isDead, class)
	local unit;
	local pulloutButtonName = getglobal(button:GetName().."Name");
	if ( isDead ) then
		pulloutButtonName:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	else
		if ( class == "PETS" ) then
			class = UnitClass(gsub(button.unit, "raidpet", "raid"));
		end
		local color = RAID_CLASS_COLORS[class];
		if ( color ) then
			pulloutButtonName:SetVertexColor(color.r, color.g, color.b);
		end
	end
end

function RaidPulloutButton_ShowMenu()
	ToggleDropDownMenu(1, nil, getglobal(this:GetParent():GetParent():GetName().."DropDown"));
end

function RaidPulloutButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:SetFrameLevel(this:GetFrameLevel() + 1);

	this.showmenu = RaidPulloutButton_ShowMenu;
end

function RaidPulloutButton_OnDragStart(frame)
	if ( not frame ) then
		MOVING_RAID_PULLOUT = nil;
		return;
	end
	local cursorX, cursorY = GetCursorPosition();
	frame:SetFrameStrata("DIALOG");
	frame:StartMoving();
	frame:ClearAllPoints();
	frame:SetPoint("TOP", nil, "BOTTOMLEFT", cursorX*GetScreenWidthScale(), cursorY*GetScreenHeightScale());
	MOVING_RAID_PULLOUT = frame;
end

function RaidPulloutStopMoving()
	if ( MOVING_RAID_PULLOUT ) then
		MOVING_RAID_PULLOUT:StopMovingOrSizing();
		MOVING_RAID_PULLOUT:SetFrameStrata("BACKGROUND");
		ValidateFramePosition(MOVING_RAID_PULLOUT, 25);
		
		-- Save the end positions
		RaidPullout_SaveFrames(MOVING_RAID_PULLOUT);
	end
end

function RaidPullout_SaveFrames(pullOutFrame)
	local point, relativeTo, relativePoint, offsetX, offsetY = pullOutFrame:GetPoint();
	local filterID = tostring(pullOutFrame.filterID);
	if ( pullOutFrame:IsShown() ) then
		if ( pullOutFrame.single ) then
			-- Check for an existing entry
			for index, value in pairs(RAID_SINGLE_POSITIONS) do
				if ( index > 19 ) then
					tremove(RAID_SINGLE_POSITIONS, index);
				end
				if ( value["name"] == pullOutFrame.name ) then
					tremove(RAID_SINGLE_POSITIONS, index);
				end
			end
			-- Save its position
			tinsert(RAID_SINGLE_POSITIONS, 1, { x = offsetX, y = offsetY, name = pullOutFrame.filterID });
		else
			if ( not RAID_PULLOUT_POSITIONS[filterID] ) then
				RAID_PULLOUT_POSITIONS[filterID] = {};
			end
			RAID_PULLOUT_POSITIONS[filterID].x = offsetX;
			RAID_PULLOUT_POSITIONS[filterID].y = offsetY;
			-- Save detail information such as name and class value
			if ( pullOutFrame.id ) then
				RAID_PULLOUT_POSITIONS[filterID].name = UnitName("raid"..pullOutFrame.id);
			end
			if ( pullOutFrame.class ) then
				RAID_PULLOUT_POSITIONS[filterID].class = pullOutFrame.class;
			end
		end
	end
end

function RaidPullout_RenewFrames()
	local pullOutFrame;
	for index, value in pairs(RAID_PULLOUT_POSITIONS) do
		if ( tonumber(index) ) then
			pullOutFrame = RaidPullout_GeneratePulloutFrame(tonumber(index));		
		else
			pullOutFrame = RaidPullout_GeneratePulloutFrame(index, value["class"]);
		end
		if ( pullOutFrame and value.x ) then
			pullOutFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", value["x"], value["y"]);
		end
	end
	for index, value in pairs(RAID_SINGLE_POSITIONS) do
		if ( RaidPullout_MatchName(value["name"]) ) then
			pullOutFrame = RaidPullout_GeneratePulloutFrame(value["name"], nil );
			if ( pullOutFrame and value.x ) then
				pullOutFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", value["x"], value["y"]);
			end
		end
	end
end

function RaidPullout_MatchName(name)
	if ( name ) then
		for i=1, GetNumRaidMembers(), 1 do
			if ( name == GetRaidRosterInfo(i) ) then
				return i;
			end			
		end	
	end
end

function RaidPullout_GetFrame(filterID)
	-- Grab an available pullout frame
	local frame;
	for i=1, NUM_RAID_PULLOUT_FRAMES do
		frame = getglobal("RaidPullout"..i);
		-- if frame is visible see if its group id is already taken
		if ( frame:IsShown() and filterID == frame.filterID ) then
			return nil;
		end
	end
	for i=1, NUM_RAID_PULLOUT_FRAMES do
		frame = getglobal("RaidPullout"..i);
		if ( not frame:IsShown() ) then
			return frame;
		end
	end
	NUM_RAID_PULLOUT_FRAMES = NUM_RAID_PULLOUT_FRAMES + 1;
	frame = CreateFrame("Button", "RaidPullout"..NUM_RAID_PULLOUT_FRAMES, UIParent, "RaidPulloutFrameTemplate");
	frame.numPulloutButtons = 0;
	return frame;
end

function RaidPulloutDropDown_OnLoad()
	this.raidPulloutDropDown = true;
	UIDropDownMenu_Initialize(this, RaidPulloutDropDown_Initialize, "MENU");
	UIDropDownMenu_SetAnchor(0, 0, this, "TOPLEFT", this:GetParent():GetName(), "TOPRIGHT")
end

function RaidPulloutDropDown_Initialize()
	if ( not UIDROPDOWNMENU_OPEN_MENU or not getglobal(UIDROPDOWNMENU_OPEN_MENU).raidPulloutDropDown ) then
		return;
	end
	local currentPullout = getglobal(UIDROPDOWNMENU_OPEN_MENU):GetParent();
	local unit = getglobal(UIDROPDOWNMENU_OPEN_MENU).unit;
	local info = UIDropDownMenu_CreateInfo();

	-- Show target if it is allowed
	info.text = SHOW_TARGET;
	info.func = function()
		if ( currentPullout.showTarget == 1 ) then
			currentPullout.showTarget = nil;
		else
			currentPullout.showTarget = 1;
		end
		RaidPullout_Update(currentPullout);
	end;
	info.checked = currentPullout.showTarget;
	UIDropDownMenu_AddButton(info);

	if ( currentPullout.showTarget == 1 ) then
		info.text = "Show Target of Target";
		info.func = function()
			if ( currentPullout.showTargetTarget == 1 ) then
				currentPullout.showTargetTarget = nil;
			else
				currentPullout.showTargetTarget = 1;
			end
			RaidPullout_Update(currentPullout);
		end;
		info.checked = currentPullout.showTargetTarget;
		UIDropDownMenu_AddButton(info);
	end

	-- Show buffs or debuffs they are exclusive for now
	info.text = SHOW_BUFFS;
	info.func = function()
		currentPullout.showBuffs = 1;
		RaidPullout_Update(currentPullout);
	end;
	info.checked = currentPullout.showBuffs;
	UIDropDownMenu_AddButton(info);

	info.text = SHOW_DEBUFFS;
	info.func = function()
		currentPullout.showBuffs = nil;
		RaidPullout_Update(currentPullout);
	end;
	info.checked = (not currentPullout.showBuffs);
	UIDropDownMenu_AddButton(info);
	
	-- Hide background option
	local backdrop = getglobal(currentPullout:GetName().."MenuBackdrop");
	info.text = HIDE_PULLOUT_BG;
	info.func = function ()
		if ( backdrop:IsShown() ) then
			backdrop:Hide();
		else
			backdrop:Show();
		end
	end;
	info.checked = (not backdrop:IsShown());
	UIDropDownMenu_AddButton(info);

	-- Close option
	info.text = CLOSE;
	info.func = function()
		if ( currentPullout.showTarget == 1 ) then
			currentPullout.showTarget = nil;
		end
		if ( RAID_PULLOUT_POSITIONS[tostring(currentPullout.filterID)] ) then
			RAID_PULLOUT_POSITIONS[tostring(currentPullout.filterID)] = nil;
		end
		for index, value in pairs(RAID_SINGLE_POSITIONS) do
			if ( value["name"] == currentPullout.filterID ) then
				tremove(RAID_SINGLE_POSITIONS, index);
			end
		end 
		currentPullout:Hide();
	end;
	info.checked = nil;
	UIDropDownMenu_AddButton(info);
end

-- Ready Check Functions
function ShowReadyCheck(initiator)
	local name, leader;
	for i=1, MAX_RAID_MEMBERS do
		name = GetRaidRosterInfo(i);
		if ( name and name == initiator) then
			leader = "raid"..i;
			break;
		end
	end
	if ( not leader ) then
		leader = "party"..GetPartyLeaderIndex();
		name = UnitName(leader);
	end
	SetPortraitTexture(ReadyCheckPortrait, leader);
	ReadyCheckFrameText:SetText(format(READY_CHECK_MESSAGE, initiator));
	ReadyCheckFrame:Show();
	ReadyCheckFrame.timer = 30;
	PlaySound("ReadyCheck");
end

function ReadyCheck_OnUpdate(elapsed)
	if ( not ReadyCheckFrame.timer ) then
		return;
	end
	ReadyCheckFrame.timer = ReadyCheckFrame.timer-elapsed;
	if ( ReadyCheckFrame.timer < 0 ) then
		-- Timed out
		local info = ChatTypeInfo["SYSTEM"];
		DEFAULT_CHAT_FRAME:AddMessage(READY_CHECK_YOU_WERE_AFK, info.r, info.g, info.b, info.id);
		ReadyCheckFrame.timer = nil;
		ReadyCheckFrame:Hide();
	end
	
end

function RaidFrameReadyCheckButton_Update()
	if ( GetNumRaidMembers() > 0 and (IsRaidLeader() or IsRaidOfficer()) ) then
		RaidFrameReadyCheckButton:Show();
	else
		RaidFrameReadyCheckButton:Hide();
	end
end

function RaidFrameAddMemberButton_Update()
	if ( GetNumRaidMembers() > 0 ) then
		RaidFrameAddMemberButton:Show();
		if ( IsRaidLeader() or IsRaidOfficer() ) then
			RaidFrameAddMemberButton:Enable();
		else
			RaidFrameAddMemberButton:Disable();
		end
	else	
		RaidFrameAddMemberButton:Hide();
	end
end
