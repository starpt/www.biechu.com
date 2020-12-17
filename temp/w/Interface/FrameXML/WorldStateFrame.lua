NUM_ALWAYS_UP_UI_FRAMES = 0;
NUM_EXTENDED_UI_FRAMES = 0;
MAX_WORLDSTATE_SCORE_BUTTONS = 20;
MAX_NUM_STAT_COLUMNS = 7;
WORLDSTATESCOREFRAME_BASE_COLUMNS = 6;
WORLDSTATESCOREFRAME_PADDING = 35;
WORLDSTATESCOREFRAME_COLUMN_SPACING = 66;
WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET = -30;

CLASS_BUTTONS = {
	["WARRIOR"]	= {0, 0.25, 0, 0.25},
	["MAGE"]		= {0.25, 0.49609375, 0, 0.25},
	["ROGUE"]		= {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"]		= {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"]		= {0, 0.25, 0.25, 0.5},
	["SHAMAN"]	 	= {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"]		= {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"]	= {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"]		= {0, 0.25, 0.5, 0.75},
};


ExtendedUI = {};

-- Always up stuff (i.e. capture the flag indicators)
function WorldStateAlwaysUpFrame_OnLoad()
	this:RegisterEvent("UPDATE_WORLD_STATES");
	SHOW_BATTLEFIELD_MINIMAP = "0";
	RegisterForSavePerCharacter("SHOW_BATTLEFIELD_MINIMAP");
	WorldStateAlwaysUpFrame_Update();
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

	this:RegisterEvent("ZONE_CHANGED");
	this:RegisterEvent("ZONE_CHANGED_INDOORS");
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end

function WorldStateAlwaysUpFrame_OnEvent()
	if ( event == "UPDATE_WORLD_STATES" or event == "PLAYER_ENTERING_WORLD" ) then
		WorldStateFrame_ToggleMinimap();
	end
	WorldStateAlwaysUpFrame_Update();
end

function WorldStateAlwaysUpFrame_Update()
	local numUI = GetNumWorldStateUI();
	local name, frame, frameText, frameDynamicIcon, frameIcon, frameFlash, flashTexture, frameDynamicButton;
	local extendedUI, extendedUIState1, extendedUIState2, extendedUIState3, uiInfo; 
	local uiType, text, icon, state, dynamicIcon, tooltip, dynamicTooltip, flash, relative;
	local inInstance, instanceType = IsInInstance();
	local alwaysUpShown = 1;
	local extendedUIShown = 1;
	for i=1, numUI do
		uiType, state, text, icon, dynamicIcon, tooltip, dynamicTooltip, extendedUI, extendedUIState1, extendedUIState2, extendedUIState3 = GetWorldStateUIInfo(i);
		if ( (uiType ~= 1) or ((WORLD_PVP_OBJECTIVES_DISPLAY == "1") or (WORLD_PVP_OBJECTIVES_DISPLAY == "2" and IsSubZonePVPPOI()) or (instanceType == "pvp")) ) then
			if ( state > 0 ) then
				-- Handle always up frames and extended ui's completely differently
				if ( extendedUI ~= "" ) then
					-- extendedUI
					uiInfo = ExtendedUI[extendedUI]
					name = uiInfo.name..extendedUIShown;
					if ( extendedUIShown > NUM_EXTENDED_UI_FRAMES ) then
						frame = uiInfo.create(extendedUIShown);
						NUM_EXTENDED_UI_FRAMES = extendedUIShown;
					else
						frame = getglobal(name);
					end
					uiInfo.update(extendedUIShown, extendedUIState1, extendedUIState2, extendedUIState3);
					frame:Show();
					extendedUIShown = extendedUIShown + 1;
				else
					-- Always Up
					name = "AlwaysUpFrame"..alwaysUpShown;
					if ( alwaysUpShown > NUM_ALWAYS_UP_UI_FRAMES ) then
						frame = CreateFrame("Frame", name, WorldStateAlwaysUpFrame, "WorldStateAlwaysUpTemplate");
						NUM_ALWAYS_UP_UI_FRAMES = alwaysUpShown;
					else
						frame = getglobal(name);
					end
					if ( alwaysUpShown == 1 ) then
						frame:SetPoint("TOP", WorldStateAlwaysUpFrame, -23 , -20);
					else
						relative = getglobal("AlwaysUpFrame"..(alwaysUpShown - 1));
						frame:SetPoint("TOP", relative, "BOTTOM");
					end
					frameText = getglobal(name.."Text");
					frameIcon = getglobal(name.."Icon");
					frameDynamicIcon = getglobal(name.."DynamicIconButtonIcon");
					frameFlash = getglobal(name.."Flash");
					flashTexture = getglobal(name.."FlashTexture");
					frameDynamicButton = getglobal(name.."DynamicIconButton");

					frameText:SetText(text);
					frameIcon:SetTexture(icon);
					frameDynamicIcon:SetTexture(dynamicIcon);
					flash = nil;
					if ( dynamicIcon ~= "" ) then
						flash = dynamicIcon.."Flash"
					end
					flashTexture:SetTexture(flash);
					frameDynamicButton.tooltip = dynamicTooltip;
					if ( state == 2 ) then
						UIFrameFlash(frameFlash, 0.5, 0.5, -1);
						frameDynamicButton:Show();
					elseif ( state == 3 ) then
						UIFrameFlashStop(frameFlash);
						frameDynamicButton:Show();
					else
						UIFrameFlashStop(frameFlash);
						frameDynamicButton:Hide();
					end
					alwaysUpShown = alwaysUpShown + 1;
				end	
				if ( icon ~= "" ) then
					frame.tooltip = tooltip;
				else
					frame.tooltip = nil;
				end
				frame:Show();
			end
		end
	end
	for i=alwaysUpShown, NUM_ALWAYS_UP_UI_FRAMES do
		frame = getglobal("AlwaysUpFrame"..i);
		frame:Hide();
	end
	for i=extendedUIShown, NUM_EXTENDED_UI_FRAMES do
		frame = getglobal("WorldStateCaptureBar"..i);
		if ( frame ) then
			frame:Hide();
		end
	end
	UIParent_ManageFramePositions();
end

function WorldStateFrame_ToggleMinimap()
	local numUI = GetNumWorldStateUI();
	if ( SHOW_BATTLEFIELD_MINIMAP == "1" ) then
		if ( numUI == 0 ) then
			if ( not MiniMapBattlefieldFrame.status == "active" ) then
				if ( BattlefieldMinimap ) then
					BattlefieldMinimap:Hide();
				end
			end
		else
			if ( not BattlefieldMinimap ) then
				BattlefieldMinimap_LoadUI();
				BattlefieldMinimap:Show();
			else
				BattlefieldMinimap:Show();				
			end
		end
	end
end

-- UI Specific functions
function CaptureBar_Create(id)
	local frame = CreateFrame("Frame", "WorldStateCaptureBar"..id, UIParent, "WorldStateCaptureBarTemplate");
	return frame;
end

function CaptureBar_Update(id, value, neutralPercent)
	local position = 25 + 124*(1 - value/100);
	local bar = getglobal("WorldStateCaptureBar"..id);
	local barSize = 121;
	if ( not bar.oldValue ) then
		bar.oldValue = position;
	end
	-- Show an arrow in the direction the bar is moving
	if ( position < bar.oldValue ) then
		getglobal("WorldStateCaptureBar"..id.."IndicatorLeft"):Show();
		getglobal("WorldStateCaptureBar"..id.."IndicatorRight"):Hide();
	elseif ( position > bar.oldValue ) then
		getglobal("WorldStateCaptureBar"..id.."IndicatorLeft"):Hide();
		getglobal("WorldStateCaptureBar"..id.."IndicatorRight"):Show();
	else
		getglobal("WorldStateCaptureBar"..id.."IndicatorLeft"):Hide();
		getglobal("WorldStateCaptureBar"..id.."IndicatorRight"):Hide();
	end
	-- Figure out if the ticker is in neutral territory or on a faction's side
	if ( value > (50 + neutralPercent/2) ) then
		getglobal("WorldStateCaptureBar"..id.."LeftIconHighlight"):Show();
		getglobal("WorldStateCaptureBar"..id.."RightIconHighlight"):Hide();
	elseif ( value < (50 - neutralPercent/2) ) then
		getglobal("WorldStateCaptureBar"..id.."LeftIconHighlight"):Hide();
		getglobal("WorldStateCaptureBar"..id.."RightIconHighlight"):Show();
	else
		getglobal("WorldStateCaptureBar"..id.."LeftIconHighlight"):Hide();
		getglobal("WorldStateCaptureBar"..id.."RightIconHighlight"):Hide();
	end
	-- Setup the size of the neutral bar
	local middleBar = getglobal("WorldStateCaptureBar"..id.."MiddleBar");
	local leftLine = getglobal("WorldStateCaptureBar"..id.."LeftLine");
	if ( neutralPercent == 0 ) then
		middleBar:SetWidth(1);
		leftLine:Hide();
	else
		middleBar:SetWidth(neutralPercent/100*barSize);
		leftLine:Show();
	end

	bar.oldValue = position;
	getglobal("WorldStateCaptureBar"..id.."Indicator"):SetPoint("CENTER", "WorldStateCaptureBar"..id, "LEFT", position, 0);
end


-- This has to be after all the functions are loaded
ExtendedUI["CAPTUREPOINT"] = {
	name = "WorldStateCaptureBar",
	create = CaptureBar_Create,
	update = CaptureBar_Update,
	onHide = CaptureBar_Hide,
}

-------------- FINAL SCORE FUNCTIONS ---------------

function WorldStateScoreFrame_OnLoad()
	this:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	this:RegisterEvent("UPDATE_WORLD_STATES");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

	-- Tab Handling code
	PanelTemplates_SetNumTabs(this, 3);
end

function WorldStateScoreFrame_Update()
	local isArena, isRegistered = IsActiveBattlefieldArena();

	if ( isArena ) then
		-- Hide unused tabs
		WorldStateScoreFrameTab1:Hide();
		WorldStateScoreFrameTab2:Hide();
		WorldStateScoreFrameTab3:Hide();
	
		-- Hide unused columns
		WorldStateScoreFrameTeam:Hide();
		WorldStateScoreFrameDeaths:Hide();
		WorldStateScoreFrameHK:Hide();

		-- Reanchor some columns.
		WorldStateScoreFrameDamageDone:SetPoint("LEFT", "WorldStateScoreFrameKB", "RIGHT", -5, 0);
		if ( isRegistered ) then
			WorldStateScoreFrameTeam:Show();
			WorldStateScoreFrameHonorGainedText:SetText(SCORE_RATING_CHANGE);
			WorldStateScoreFrameHonorGained.sortType = "team";
			WorldStateScoreFrameKB:SetPoint("LEFT", "WorldStateScoreFrameTeam", "RIGHT", -10, 0);
		else
			WorldStateScoreFrameHonorGained:Hide();
			WorldStateScoreFrameKB:SetPoint("LEFT", "WorldStateScoreFrameName", "RIGHT", 4, 0);
		end
	else
		-- Show Tabs
		WorldStateScoreFrameTab1:Show();
		WorldStateScoreFrameTab2:Show();
		WorldStateScoreFrameTab3:Show();
		
		WorldStateScoreFrameTeam:Hide();
		WorldStateScoreFrameDeaths:Show();
		WorldStateScoreFrameHK:Show();
		WorldStateScoreFrameHonorGained.sortType = "cp";
		WorldStateScoreFrameHonorGainedText:SetText(SCORE_HONOR_GAINED);
		WorldStateScoreFrameHKText:SetText(SCORE_HONORABLE_KILLS);
		WorldStateScoreFrameHonorGained:Show();
		-- Reanchor some columns.
		WorldStateScoreFrameDamageDone:SetPoint("LEFT", "WorldStateScoreFrameHK", "RIGHT", -5, 0);
		WorldStateScoreFrameKB:SetPoint("LEFT", "WorldStateScoreFrameName", "RIGHT", 4, 0);
	end

	--Show the frame if its hidden and there is a victor
	if ( GetBattlefieldWinner() ) then
		-- Show the final score frame, set textures etc.
		ShowUIPanel(WorldStateScoreFrame);
		if ( isArena ) then
			WorldStateScoreFrameLeaveButton:SetText(LEAVE_ARENA);
			WorldStateScoreFrameTimerLabel:SetText(TIME_TO_PORT_ARENA);
		else
			WorldStateScoreFrameLeaveButton:SetText(LEAVE_BATTLEGROUND);				
			WorldStateScoreFrameTimerLabel:SetText(TIME_TO_PORT);
		end
		
		WorldStateScoreFrameLeaveButton:Show();
		WorldStateScoreFrameTimerLabel:Show();
		WorldStateScoreFrameTimer:Show();

		-- Show winner
		local battlefieldWinner = GetBattlefieldWinner(); 
		
		if ( isArena ) then
			if ( isRegistered ) then
				local teamName, teamRating, newTeamRating = GetBattlefieldTeamInfo(battlefieldWinner);
				if ( teamName ) then
					WorldStateScoreWinnerFrameText:SetText(format(VICTORY_TEXT_ARENA_WINS, teamName));			
				else
					WorldStateScoreWinnerFrameText:SetText(VICTORY_TEXT_ARENA_DRAW);							
				end
			else
				WorldStateScoreWinnerFrameText:SetText(getglobal("VICTORY_TEXT_ARENA"..battlefieldWinner));
			end
			if ( battlefieldWinner == 0 ) then
				-- Green Team won
				WorldStateScoreWinnerFrameLeft:SetVertexColor(0.19, 0.57, 0.11);
				WorldStateScoreWinnerFrameRight:SetVertexColor(0.19, 0.57, 0.11);
				WorldStateScoreWinnerFrameText:SetVertexColor(0.1, 1.0, 0.1);	
			else		
				-- Gold Team won
				WorldStateScoreWinnerFrameLeft:SetVertexColor(0.85, 0.71, 0.26);
				WorldStateScoreWinnerFrameRight:SetVertexColor(0.85, 0.71, 0.26);
				WorldStateScoreWinnerFrameText:SetVertexColor(1, 0.82, 0);	
			end
		else
			WorldStateScoreWinnerFrameText:SetText(getglobal("VICTORY_TEXT"..battlefieldWinner));
			if ( battlefieldWinner == 0 ) then
				-- Horde won
				WorldStateScoreWinnerFrameLeft:SetVertexColor(0.52, 0.075, 0.18);
				WorldStateScoreWinnerFrameRight:SetVertexColor(0.5, 0.075, 0.18);
				WorldStateScoreWinnerFrameText:SetVertexColor(1.0, 0.1, 0.1);
			else
				-- Alliance won
				WorldStateScoreWinnerFrameLeft:SetVertexColor(0.11, 0.26, 0.51);
				WorldStateScoreWinnerFrameRight:SetVertexColor(0.11, 0.26, 0.51);
				WorldStateScoreWinnerFrameText:SetVertexColor(0, 0.68, 0.94);	
			end
		end
		WorldStateScoreWinnerFrame:Show();
	else
		WorldStateScoreWinnerFrame:Hide();
		WorldStateScoreFrameLeaveButton:Hide();
		WorldStateScoreFrameTimerLabel:Hide();
		WorldStateScoreFrameTimer:Hide();
	end
	
	-- Update buttons
	local numScores = GetNumBattlefieldScores();

	local scoreButton, buttonIcon, buttonClass, buttonName, nameButton, buttonKills, buttonKillingBlows, buttonDeaths, buttonHonorGained, buttonFaction, columnButtonText, columnButtonIcon, buttonFactionLeft, buttonFactionRight, buttonDamage, buttonHealing, buttonTeam;
	local name, kills, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone;
	local teamName, teamRating, newTeamRating;
	local index;
	local columnData;

        -- ScrollFrame update
	local hasScrollBar;
	if ( numScores > MAX_WORLDSTATE_SCORE_BUTTONS ) then
		hasScrollBar = 1;
		WorldStateScoreScrollFrame:Show();
	else
		WorldStateScoreScrollFrame:Hide();
        end
	FauxScrollFrame_Update(WorldStateScoreScrollFrame, numScores, MAX_WORLDSTATE_SCORE_BUTTONS, 16 );

	-- Setup Columns
	local text, icon, tooltip, columnButton;
	local numStatColumns = GetNumBattlefieldStats();
	local columnButton, columnButtonText, columnTextButton, columnIcon;
	local honorGainedAnchorFrame = "WorldStateScoreFrameHealingDone";
	for i=1, MAX_NUM_STAT_COLUMNS do
		if ( i <= numStatColumns ) then
			text, icon, tooltip = GetBattlefieldStatInfo(i);
			columnButton = getglobal("WorldStateScoreColumn"..i);
			columnButtonText = getglobal("WorldStateScoreColumn"..i.."Text");
			columnButtonText:SetText(text);
			columnButton.icon = icon;
			columnButton.tooltip = tooltip;
			
			columnTextButton = getglobal("WorldStateScoreButton1Column"..i.."Text");

			if ( icon ~= "" ) then
				columnTextButton:SetPoint("CENTER", "WorldStateScoreColumn"..i, "CENTER", 6, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			else
				columnTextButton:SetPoint("CENTER", "WorldStateScoreColumn"..i, "CENTER", -1, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			end

			
			if ( i == numStatColumns ) then
				honorGainedAnchorFrame = "WorldStateScoreColumn"..i;
			end
		
			getglobal("WorldStateScoreColumn"..i):Show();
		else
			getglobal("WorldStateScoreColumn"..i):Hide();
		end
	end
	
	-- Anchor the bonus honor gained to the last column shown
	WorldStateScoreFrameHonorGained:SetPoint("LEFT", honorGainedAnchorFrame, "RIGHT", -5, 0);
	
	-- Last button shown is what the player count anchors to
	local lastButtonShown = "WorldStateScoreButton1";
	local teamDataFailed, coords;

	if ( isArena ) then
		for i=0, 1 do
			teamName, teamRating, newTeamRating = GetBattlefieldTeamInfo(i);
			if ( teamRating == 0 ) then
				teamDataFailed = 1;
			end
		end
	end
	
	for i=1, MAX_WORLDSTATE_SCORE_BUTTONS do
		-- Need to create an index adjusted by the scrollframe offset
		index = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame) + i;
		scoreButton = getglobal("WorldStateScoreButton"..i);
		if ( hasScrollBar ) then
			scoreButton:SetWidth(WorldStateScoreFrame.scrollBarButtonWidth);
		else
			scoreButton:SetWidth(WorldStateScoreFrame.buttonWidth);
		end
		if ( index <= numScores ) then
			buttonClass = getglobal("WorldStateScoreButton"..i.."ClassButtonIcon");
			buttonName = getglobal("WorldStateScoreButton"..i.."Name");
			buttonTeam =  getglobal("WorldStateScoreButton"..i.."Team");
			buttonKills = getglobal("WorldStateScoreButton"..i.."HonorableKills");
			buttonKillingBlows = getglobal("WorldStateScoreButton"..i.."KillingBlows");
			buttonDeaths = getglobal("WorldStateScoreButton"..i.."Deaths");
			buttonDamage = getglobal("WorldStateScoreButton"..i.."Damage");
			buttonHealing = getglobal("WorldStateScoreButton"..i.."Healing");
			buttonHonorGained = getglobal("WorldStateScoreButton"..i.."HonorGained");
			buttonFactionLeft = getglobal("WorldStateScoreButton"..i.."FactionLeft");
			buttonFactionRight = getglobal("WorldStateScoreButton"..i.."FactionRight");
			
			name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index);
			if ( classToken ) then
				coords = CLASS_BUTTONS[classToken];
				buttonClass:SetTexture("Interface\\WorldStateFrame\\Icons-Classes");
				buttonClass:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
				buttonClass:Show();
			else
				buttonClass:Hide();
			end
			
			buttonName:SetText(name);
			if ( not race ) then
				race = "";
			end
			if ( not class ) then
				class = "";
			end
			buttonName.name = name;
			buttonName.tooltip = race.." "..class;
			getglobal("WorldStateScoreButton"..i.."ClassButton").tooltip = class;
			buttonKillingBlows:SetText(killingBlows);
			buttonDamage:SetText(damageDone);
			buttonHealing:SetText(healingDone);
			teamName, teamRating, newTeamRating = GetBattlefieldTeamInfo(faction);
			if ( isArena ) then
				if ( isRegistered ) then
					buttonTeam:SetText(teamName);
					buttonTeam:Show();
					if ( teamDataFailed ) then
						buttonHonorGained:SetText("-------");
					else
						buttonHonorGained:SetText(tostring(newTeamRating - teamRating));
					end
					buttonHonorGained:Show();
				else
					buttonHonorGained:Hide();
					buttonTeam:Hide();
				end
				buttonKills:Hide();
				buttonDeaths:Hide();
			else
				buttonKills:SetText(honorableKills);
				buttonDeaths:SetText(deaths);
				buttonHonorGained:SetText(honorGained);
				buttonTeam:Hide();
				buttonKills:Show();
				buttonDeaths:Show();
				buttonHonorGained:Show();
			end
			
			for j=1, MAX_NUM_STAT_COLUMNS do
				columnButtonText = getglobal("WorldStateScoreButton"..i.."Column"..j.."Text");
				columnButtonIcon = getglobal("WorldStateScoreButton"..i.."Column"..j.."Icon");
				if ( j <= numStatColumns ) then
					-- If there's an icon then move the icon left and format the text with an "x" in front
					columnData = GetBattlefieldStatData(index, j);
					if ( getglobal("WorldStateScoreColumn"..j).icon ~= "" ) then
						if ( columnData > 0 ) then
							columnButtonText:SetText(format(FLAG_COUNT_TEMPLATE, columnData));
							columnButtonIcon:SetTexture(getglobal("WorldStateScoreColumn"..j).icon..faction);
							columnButtonIcon:Show();
						else
							columnButtonText:SetText("");
							columnButtonIcon:Hide();
						end
						
					else
						columnButtonText:SetText(columnData);
						columnButtonIcon:Hide();
					end
					columnButtonText:Show();
				else
					columnButtonText:Hide();
					columnButtonIcon:Hide();
				end
			end
			if ( faction ) then
				if ( faction == 0 ) then
					if ( isArena ) then
						-- Green Team 
						buttonFactionLeft:SetVertexColor(0.19, 0.57, 0.11);
						buttonFactionRight:SetVertexColor(0.19, 0.57, 0.11);
						buttonName:SetVertexColor(0.1, 1.0, 0.1);	
					else
						-- Horde
						buttonFactionLeft:SetVertexColor(0.52, 0.075, 0.18);
						buttonFactionRight:SetVertexColor(0.5, 0.075, 0.18);
						buttonName:SetVertexColor(1.0, 0.1, 0.1);
					end
				else
					if ( isArena ) then
						-- Gold Team 
						buttonFactionLeft:SetVertexColor(0.85, 0.71, 0.26);
						buttonFactionRight:SetVertexColor(0.85, 0.71, 0.26);
						buttonName:SetVertexColor(1, 0.82, 0);	
					else
						-- Alliance 
						buttonFactionLeft:SetVertexColor(0.11, 0.26, 0.51);
						buttonFactionRight:SetVertexColor(0.11, 0.26, 0.51);
						buttonName:SetVertexColor(0, 0.68, 0.94);	
					end
				end
				if ( ( not isArena ) and ( name == UnitName("player") ) ) then
					buttonName:SetVertexColor(1.0, 0.82, 0);
				end
				buttonFactionLeft:Show();
				buttonFactionRight:Show();
			else
				buttonFactionLeft:Hide();
				buttonFactionRight:Hide();
			end
			lastButtonShown = scoreButton:GetName();
			scoreButton:Show();
		else
			scoreButton:Hide();
		end
	end

	-- Count number of players on each side
	local numHorde = 0;
	local numAlliance = 0;
	for i=1, numScores do
		name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(i);	
		if ( faction ) then
			if ( faction == 0 ) then
				numHorde = numHorde + 1;
			else
				numAlliance = numAlliance + 1;
			end
		end
	end
	
	-- Set count text and anchor team count to last button shown
	WorldStateScorePlayerCount:Show();
	if ( numHorde > 0 and numAlliance > 0 ) then
		WorldStateScorePlayerCount:SetText(format(GetText("PLAYER_COUNT_ALLIANCE", nil, numAlliance), numAlliance).." / "..format(GetText("PLAYER_COUNT_HORDE", nil, numHorde), numHorde));
	elseif ( numAlliance > 0 ) then
		WorldStateScorePlayerCount:SetText(format(GetText("PLAYER_COUNT_ALLIANCE", nil, numAlliance), numAlliance));
	elseif ( numHorde > 0 ) then
		WorldStateScorePlayerCount:SetText(format(GetText("PLAYER_COUNT_HORDE", nil, numHorde), numHorde));
	else
		WorldStateScorePlayerCount:Hide();
	end
	if ( isArena ) then
		WorldStateScorePlayerCount:Hide();
	end

	WorldStateScorePlayerCount:SetPoint("TOPLEFT", lastButtonShown, "BOTTOMLEFT", 15, -6);
	WorldStateScoreBattlegroundRunTime:SetText(TIME_ELAPSED.." "..SecondsToTime(GetBattlefieldInstanceRunTime()/1000, 1));
	WorldStateScoreBattlegroundRunTime:SetPoint("TOPRIGHT", lastButtonShown, "BOTTOMRIGHT", -20, -7);
end

function WorldStateScoreFrame_Resize(width)
	local isArena, isRegistered = IsActiveBattlefieldArena();
	local columns = WORLDSTATESCOREFRAME_BASE_COLUMNS;
	local scrollBar = 37;
	local name;
	--debugbreak();
	if ( not width ) then

		width = WORLDSTATESCOREFRAME_PADDING + WorldStateScoreFrameName:GetWidth() + WorldStateScoreFrameClass:GetWidth();

		if ( isArena ) then
			columns = 3;
			if ( isRegistered ) then
				columns = 4;
				width = width + WorldStateScoreFrameTeam:GetWidth();
			else
				width = width + 43;
			end
		end

		columns = columns + 1 + GetNumBattlefieldStats();
	
		width = width + (columns*WORLDSTATESCOREFRAME_COLUMN_SPACING);

		if ( WorldStateScoreScrollFrame:IsShown() ) then
			width = width + scrollBar;
		end
	end
	
	WorldStateScoreFrame:SetWidth(width);
	
	WorldStateScoreFrameTopBackground:SetWidth(WorldStateScoreFrame:GetWidth()-129);
	WorldStateScoreFrameTopBackground:SetTexCoord(0, WorldStateScoreFrameTopBackground:GetWidth()/256, 0, 1.0);
	WorldStateScoreFrame.scrollBarButtonWidth = WorldStateScoreFrame:GetWidth() - 165;
	WorldStateScoreFrame.buttonWidth = WorldStateScoreFrame:GetWidth() - 137;
	WorldStateScoreScrollFrame:SetWidth(WorldStateScoreFrame.scrollBarButtonWidth);

	-- Position Column data horizontally
	local buttonTeam, buttonKills, buttonDeaths, buttonDamage, buttonHealing, buttonHonorGained, buttonReturnedIcon, buttonCapturedIcon;
	for i=1, MAX_WORLDSTATE_SCORE_BUTTONS do
		if ( isRegistered ) then
			buttonTeam = getglobal("WorldStateScoreButton"..i.."Team");
		end
		
		buttonKills = getglobal("WorldStateScoreButton"..i.."HonorableKills");
		buttonKillingBlows = getglobal("WorldStateScoreButton"..i.."KillingBlows");
		buttonDeaths = getglobal("WorldStateScoreButton"..i.."Deaths");
		buttonDamage = getglobal("WorldStateScoreButton"..i.."Damage");
		buttonHealing = getglobal("WorldStateScoreButton"..i.."Healing");
		buttonHonorGained = getglobal("WorldStateScoreButton"..i.."HonorGained");
		if ( i == 1 ) then
			if ( isRegistered ) then
				buttonTeam:SetPoint("LEFT", "WorldStateScoreFrameTeam", "LEFT", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			end
			buttonKills:SetPoint("CENTER", "WorldStateScoreFrameHK", "CENTER", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			buttonKillingBlows:SetPoint("CENTER", "WorldStateScoreFrameKB", "CENTER", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			buttonDeaths:SetPoint("CENTER", "WorldStateScoreFrameDeaths", "CENTER", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			buttonDamage:SetPoint("CENTER", "WorldStateScoreFrameDamageDone", "CENTER", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			buttonHealing:SetPoint("CENTER", "WorldStateScoreFrameHealingDone", "CENTER", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			buttonHonorGained:SetPoint("CENTER", "WorldStateScoreFrameHonorGained", "CENTER", 0, WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			for j=1, MAX_NUM_STAT_COLUMNS do
				getglobal("WorldStateScoreButton"..i.."Column"..j.."Text"):SetPoint("CENTER", getglobal("WorldStateScoreColumn"..j), "CENTER", 0,  WORLDSTATECOREFRAME_BUTTON_TEXT_OFFSET);
			end
		else
			if ( isRegistered ) then
				buttonTeam:SetPoint("LEFT", "WorldStateScoreButton"..(i-1).."Team", "LEFT", 0,  -16);
			end
			buttonKills:SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."HonorableKills", "CENTER", 0, -16);
			buttonKillingBlows:SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."KillingBlows", "CENTER", 0, -16);
			buttonDeaths:SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."Deaths", "CENTER", 0, -16);
			buttonDamage:SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."Damage", "CENTER", 0, -16);
			buttonHealing:SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."Healing", "CENTER", 0, -16);
			buttonHonorGained:SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."HonorGained", "CENTER", 0, -16);
			for j=1, MAX_NUM_STAT_COLUMNS do
				getglobal("WorldStateScoreButton"..i.."Column"..j.."Text"):SetPoint("CENTER", "WorldStateScoreButton"..(i-1).."Column"..j.."Text", "CENTER", 0, -16);
			end
		end
	end
	return width;
end

function WorldStateScoreFrameTab_OnClick(tab)
	if ( not tab ) then
		tab = this;
	end
	local faction = tab:GetID();
	PanelTemplates_SetTab(WorldStateScoreFrame, faction);
	if ( faction == 2 ) then
		faction = 1;
	elseif ( faction == 3 ) then
		faction = 0;
	else
		faction = nil;
	end
	WorldStateScoreFrameLabel:SetText(format(STAT_TEMPLATE, tab:GetText()));
	SetBattlefieldScoreFaction(faction);
	PlaySound("igCharacterInfoTab");
end

function ToggleWorldStateScoreFrame()
	if ( WorldStateScoreFrame:IsShown() ) then
		HideUIPanel(WorldStateScoreFrame);
	else
		if ( not IsActiveBattlefieldArena() and MiniMapBattlefieldFrame.status == "active" ) then
			ShowUIPanel(WorldStateScoreFrame);
		end
	end
end
