
UNITPOPUP_TITLE_HEIGHT = 26;
UNITPOPUP_BUTTON_HEIGHT = 15;
UNITPOPUP_BORDER_HEIGHT = 8;
UNITPOPUP_BORDER_WIDTH = 19;

UNITPOPUP_NUMBUTTONS = 9;
UNITPOPUP_TIMEOUT = 5;

UNITPOPUP_SPACER_SPACING = 6;

UnitPopupButtons = { };
UnitPopupButtons["CANCEL"] = { text = CANCEL, dist = 0, space = 1 };
UnitPopupButtons["TRADE"] = { text = TRADE, dist = 2 };
UnitPopupButtons["INSPECT"] = { text = INSPECT, dist = 1 };
UnitPopupButtons["TARGET"] = { text = TARGET, dist = 0 };
UnitPopupButtons["IGNORE"]	= { text = IGNORE, dist = 0 };
UnitPopupButtons["REPORT_SPAM"]	= { text = REPORT_SPAM, dist = 0 };
UnitPopupButtons["DUEL"] = { text = DUEL, dist = 3, space = 1 };
UnitPopupButtons["WHISPER"]	= { text = WHISPER, dist = 0 };
UnitPopupButtons["INVITE"]	= { text = PARTY_INVITE, dist = 0 };
UnitPopupButtons["UNINVITE"] = { text = PARTY_UNINVITE, dist = 0 };
UnitPopupButtons["PROMOTE"] = { text = PARTY_PROMOTE, dist = 0 };
UnitPopupButtons["GUILD_PROMOTE"] = { text = GUILD_PROMOTE, dist = 0 };
UnitPopupButtons["GUILD_LEAVE"] = { text = GUILD_LEAVE, dist = 0 };
UnitPopupButtons["TEAM_PROMOTE"] = { text = TEAM_PROMOTE, dist = 0 };
UnitPopupButtons["TEAM_KICK"] = { text = TEAM_KICK, dist = 0 };
UnitPopupButtons["TEAM_LEAVE"] = { text = TEAM_LEAVE, dist = 0 };
UnitPopupButtons["LEAVE"] = { text = PARTY_LEAVE, dist = 0 };
UnitPopupButtons["FOLLOW"] = { text = FOLLOW, dist = 4 };
UnitPopupButtons["PET_DISMISS"] = { text = PET_DISMISS, dist = 0 };
UnitPopupButtons["PET_ABANDON"] = { text = PET_ABANDON, dist = 0 };
UnitPopupButtons["PET_PAPERDOLL"] = { text = PET_PAPERDOLL, dist = 0 };
UnitPopupButtons["PET_RENAME"] = { text = PET_RENAME, dist = 0 };

UnitPopupButtons["LOOT_METHOD"] = { text = LOOT_METHOD, dist = 0, nested = 1};
UnitPopupButtons["FREE_FOR_ALL"] = { text = LOOT_FREE_FOR_ALL, dist = 0 };
UnitPopupButtons["ROUND_ROBIN"] = { text = LOOT_ROUND_ROBIN, dist = 0 };
UnitPopupButtons["MASTER_LOOTER"] = { text = LOOT_MASTER_LOOTER, dist = 0 };
UnitPopupButtons["GROUP_LOOT"] = { text = LOOT_GROUP_LOOT, dist = 0 };
UnitPopupButtons["NEED_BEFORE_GREED"] = { text = LOOT_NEED_BEFORE_GREED, dist = 0 };
UnitPopupButtons["RESET_INSTANCES"] = { text = RESET_INSTANCES, dist = 0 };

UnitPopupButtons["DUNGEON_DIFFICULTY"] = { text = DUNGEON_DIFFICULTY, dist = 0,  nested = 1};
UnitPopupButtons["DUNGEON_DIFFICULTY1"] = { text = DUNGEON_DIFFICULTY1, dist = 0 };
UnitPopupButtons["DUNGEON_DIFFICULTY2"] = { text = DUNGEON_DIFFICULTY2, dist = 0 };
--UnitPopupButtons["DUNGEON_DIFFICULTY3"] = { text = DUNGEON_DIFFICULTY3, dist = 0 };

UnitPopupButtons["PVP_FLAG"] = { text = PVP_FLAG, dist = 0, nested = 1};
UnitPopupButtons["PVP_ENABLE"] = { text = ENABLE, dist = 0, checkable = 1 };
UnitPopupButtons["PVP_DISABLE"] = { text = DISABLE, dist = 0, checkable = 1 };

UnitPopupButtons["LOOT_THRESHOLD"] = { text = LOOT_THRESHOLD, dist = 0, nested = 1 };
UnitPopupButtons["LOOT_PROMOTE"] = { text = LOOT_PROMOTE, dist = 0 };
UnitPopupButtons["ITEM_QUALITY2_DESC"] = { text = ITEM_QUALITY2_DESC, dist = 0, color = ITEM_QUALITY_COLORS[2] };
UnitPopupButtons["ITEM_QUALITY3_DESC"] = { text = ITEM_QUALITY3_DESC, dist = 0, color = ITEM_QUALITY_COLORS[3] };
UnitPopupButtons["ITEM_QUALITY4_DESC"] = { text = ITEM_QUALITY4_DESC, dist = 0, color = ITEM_QUALITY_COLORS[4] };

UnitPopupButtons["RAID_LEADER"] = { text = SET_RAID_LEADER, dist = 0 };
UnitPopupButtons["RAID_PROMOTE"] = { text = SET_RAID_ASSISTANT, dist = 0 };
UnitPopupButtons["RAID_MAINTANK"] = { text = SET_MAIN_TANK, dist = 0 };
UnitPopupButtons["RAID_MAINASSIST"] = { text = SET_MAIN_ASSIST, dist = 0 };
UnitPopupButtons["RAID_DEMOTE"] = { text = DEMOTE, dist = 0 };
UnitPopupButtons["RAID_REMOVE"] = { text = REMOVE, dist = 0 };

UnitPopupButtons["RAID_TARGET_ICON"] = { text = RAID_TARGET_ICON, dist = 0, nested = 1 };
UnitPopupButtons["RAID_TARGET_1"] = { text = RAID_TARGET_1, dist = 0, checkable = 1, color = {r = 1.0, g = 0.92, b = 0}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0, tCoordRight = 0.25, tCoordTop = 0, tCoordBottom = 0.25 };
UnitPopupButtons["RAID_TARGET_2"] = { text = RAID_TARGET_2, dist = 0, checkable = 1, color = {r = 0.98, g = 0.57, b = 0}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0.25, tCoordRight = 0.5, tCoordTop = 0, tCoordBottom = 0.25 };
UnitPopupButtons["RAID_TARGET_3"] = { text = RAID_TARGET_3, dist = 0, checkable = 1, color = {r = 0.83, g = 0.22, b = 0.9}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0.5, tCoordRight = 0.75, tCoordTop = 0, tCoordBottom = 0.25 };
UnitPopupButtons["RAID_TARGET_4"] = { text = RAID_TARGET_4, dist = 0, checkable = 1, color = {r = 0.04, g = 0.95, b = 0}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0.75, tCoordRight = 1, tCoordTop = 0, tCoordBottom = 0.25 };
UnitPopupButtons["RAID_TARGET_5"] = { text = RAID_TARGET_5, dist = 0, checkable = 1, color = {r = 0.7, g = 0.82, b = 0.875}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0, tCoordRight = 0.25, tCoordTop = 0.25, tCoordBottom = 0.5 };
UnitPopupButtons["RAID_TARGET_6"] = { text = RAID_TARGET_6, dist = 0, checkable = 1, color = {r = 0, g = 0.71, b = 1}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0.25, tCoordRight = 0.5, tCoordTop = 0.25, tCoordBottom = 0.5 };
UnitPopupButtons["RAID_TARGET_7"] = { text = RAID_TARGET_7, dist = 0, checkable = 1, color = {r = 1.0, g = 0.24, b = 0.168}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0.5, tCoordRight = 0.75, tCoordTop = 0.25, tCoordBottom = 0.5 };
UnitPopupButtons["RAID_TARGET_8"] = { text = RAID_TARGET_8, dist = 0, checkable = 1, color = {r = 0.98, g = 0.98, b = 0.98}, icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", tCoordLeft = 0.75, tCoordRight = 1, tCoordTop = 0.25, tCoordBottom = 0.5 };
UnitPopupButtons["RAID_TARGET_NONE"] = { text = NONE, dist = 0, checkable = 1, };

-- First level menus
UnitPopupMenus = { };
UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "LEAVE", "CANCEL" };
UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
UnitPopupMenus["PARTY"] = { "WHISPER", "PROMOTE", "LOOT_PROMOTE", "UNINVITE", "INSPECT", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "CANCEL" };
UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "CANCEL" };
UnitPopupMenus["RAID_PLAYER"] = { "WHISPER", "INSPECT", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "CANCEL" };
UnitPopupMenus["RAID"] = { "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "CANCEL" };
UnitPopupMenus["FRIEND"] = { "WHISPER", "INVITE", "TARGET", "IGNORE", "REPORT_SPAM", "GUILD_PROMOTE", "GUILD_LEAVE", "CANCEL" };
UnitPopupMenus["TEAM"] = { "WHISPER", "INVITE", "TARGET", "TEAM_PROMOTE", "TEAM_KICK", "TEAM_LEAVE", "CANCEL" };
UnitPopupMenus["RAID_TARGET_ICON"] = { "RAID_TARGET_1", "RAID_TARGET_2", "RAID_TARGET_3", "RAID_TARGET_4", "RAID_TARGET_5", "RAID_TARGET_6", "RAID_TARGET_7", "RAID_TARGET_8", "RAID_TARGET_NONE" };

-- Second level menus
UnitPopupMenus["PVP_FLAG"] = { "PVP_ENABLE", "PVP_DISABLE"};
UnitPopupMenus["LOOT_METHOD"] = { "FREE_FOR_ALL", "ROUND_ROBIN", "MASTER_LOOTER", "GROUP_LOOT", "NEED_BEFORE_GREED", "CANCEL" };
UnitPopupMenus["LOOT_THRESHOLD"] = { "ITEM_QUALITY2_DESC", "ITEM_QUALITY3_DESC", "ITEM_QUALITY4_DESC", "CANCEL" };
UnitPopupMenus["DUNGEON_DIFFICULTY"] = { "DUNGEON_DIFFICULTY1", "DUNGEON_DIFFICULTY2" };

UnitPopupShown = {};
UnitPopupShown[1] = {};
UnitPopupShown[2] = {};
UnitPopupShown[3] = {};

UnitLootMethod = {};
UnitLootMethod["freeforall"] = { text = LOOT_FREE_FOR_ALL, tooltipText = NEWBIE_TOOLTIP_UNIT_FREE_FOR_ALL };
UnitLootMethod["roundrobin"] = { text = LOOT_ROUND_ROBIN, tooltipText = NEWBIE_TOOLTIP_UNIT_ROUND_ROBIN };
UnitLootMethod["master"] = { text = LOOT_MASTER_LOOTER, tooltipText = NEWBIE_TOOLTIP_UNIT_MASTER_LOOTER };
UnitLootMethod["group"] = { text = LOOT_GROUP_LOOT, tooltipText = NEWBIE_TOOLTIP_UNIT_GROUP_LOOT };
UnitLootMethod["needbeforegreed"] = { text = LOOT_NEED_BEFORE_GREED, tooltipText = NEWBIE_TOOLTIP_UNIT_NEED_BEFORE_GREED };


UnitPopupFrames = {
	"PlayerFrameDropDown",
	"TargetFrameDropDown",
	"PartyMemberFrame1DropDown",
	"PartyMemberFrame2DropDown",
	"PartyMemberFrame3DropDown",
	"PartyMemberFrame4DropDown",
	"FriendsDropDown"
};

function UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
	local server
	-- Init variables
	dropdownMenu.which = which;
	dropdownMenu.unit = unit;
	if ( unit ) then
		name, server = UnitName(unit, true);
	end
	dropdownMenu.name = name;
	dropdownMenu.userData = userData;
	dropdownMenu.server = server;

	-- Determine which buttons should be shown or hidden
	UnitPopup_HideButtons();
	
	-- If only one menu item (the cancel button) then don't show the menu
	local count = 0;
	for index, value in ipairs(UnitPopupMenus[which]) do
		if( UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] == 1 and value ~= "CANCEL" ) then
			count = count + 1;
		end
	end
	if ( count < 1 ) then
		return;
	end
	
	-- Determine which loot method and which loot threshold are selected and set the corresponding buttons to the same text
	dropdownMenu.selectedLootMethod = UnitLootMethod[GetLootMethod()].text;
	UnitPopupButtons["LOOT_METHOD"].text = dropdownMenu.selectedLootMethod;
	UnitPopupButtons["LOOT_METHOD"].tooltipText = UnitLootMethod[GetLootMethod()].tooltipText;
	dropdownMenu.selectedLootThreshold = getglobal("ITEM_QUALITY"..GetLootThreshold().."_DESC");
	UnitPopupButtons["LOOT_THRESHOLD"].text = dropdownMenu.selectedLootThreshold;
	-- This allows player to view loot settings if he's not the leader
	if ( ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) and IsPartyLeader() ) then
		-- If this is true then player is the party leader
		UnitPopupButtons["LOOT_METHOD"].nested = 1;
		UnitPopupButtons["LOOT_THRESHOLD"].nested = 1;
	else
		UnitPopupButtons["LOOT_METHOD"].nested = nil;
		UnitPopupButtons["LOOT_THRESHOLD"].nested = nil;
	end

	-- If level 2 dropdown
	local info;
	local color;
	local icon;
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		dropdownMenu.which = UIDROPDOWNMENU_MENU_VALUE;
		-- Set which menu is being opened
		OPEN_DROPDOWNMENUS[UIDROPDOWNMENU_MENU_LEVEL] = {which = dropdownMenu.which, unit = dropdownMenu.unit};
		info = UIDropDownMenu_CreateInfo();
		for index, value in ipairs(UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE]) do
			info.text = UnitPopupButtons[value].text;
			info.owner = UIDROPDOWNMENU_MENU_VALUE;
			-- Set the text color
			color = UnitPopupButtons[value].color;
			if ( color ) then
				info.textR = color.r;
				info.textG = color.g;
				info.textB = color.b;
			else
				info.textR = nil;
				info.textG = nil;
				info.textB = nil;
			end
			-- Icons
			info.icon = UnitPopupButtons[value].icon;
			info.tCoordLeft = UnitPopupButtons[value].tCoordLeft;
			info.tCoordRight = UnitPopupButtons[value].tCoordRight;
			info.tCoordTop = UnitPopupButtons[value].tCoordTop;
			info.tCoordBottom = UnitPopupButtons[value].tCoordBottom;
			-- Checked conditions
			info.checked = nil;
			if ( info.text == dropdownMenu.selectedLootMethod  ) then
				info.checked = 1;
			elseif ( info.text == dropdownMenu.selectedLootThreshold ) then
				info.checked = 1;
			elseif ( strsub(value, 1, 12) == "RAID_TARGET_" ) then
				local raidTargetIndex = GetRaidTargetIndex(unit);
				if ( raidTargetIndex == index ) then
					info.checked = 1;
				end
			elseif ( strsub(value, 1, 18) == "DUNGEON_DIFFICULTY" and (strlen(value) > 18)) then
				local dungeonDifficulty = GetCurrentDungeonDifficulty();
				if ( dungeonDifficulty == index ) then
					info.checked = 1;
				end
				local inParty = 0;
				if ( (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0) ) then
					inParty = 1;
				end
				local isLeader = 0;
				if ( IsPartyLeader() ) then
					isLeader = 1;
				end
				local inInstance, instanceType = IsInInstance();
				if ( ( inParty == 1 and isLeader == 0 ) or inInstance ) then
					info.disabled = 1;	
				end					

			-- Adds (Default) to the difficulty string.  Removed per request.
			--[[	local defaultDungeonDifficullty = GetDefaultDungeonDifficulty();
				if ( defaultDungeonDifficullty == index ) then
					info.text = info.text.." ("..DEFAULT..")";
				end   ]]
			elseif ( value == "PVP_ENABLE" ) then
				if ( GetPVPDesired() == 1 ) then
					info.checked = 1;
				end
			elseif ( value == "PVP_DISABLE" ) then
				if ( GetPVPDesired() == 0 ) then
					info.checked = 1;
				end
			end
			
			info.value = value;
			info.func = UnitPopup_OnClick;
			-- Setup newbie tooltips
			info.tooltipTitle = UnitPopupButtons[value].text;
			info.tooltipText = getglobal("NEWBIE_TOOLTIP_UNIT_"..value);
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
		end
		return;			
	end

	-- Add dropdown title
	if ( unit or name ) then
		info = UIDropDownMenu_CreateInfo();
		if ( name ) then
			info.text = name;
		else
			info.text = UNKNOWN;
		end
		info.isTitle = 1;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
	end
	
	-- Set which menu is being opened
	OPEN_DROPDOWNMENUS[UIDROPDOWNMENU_MENU_LEVEL] = {which = dropdownMenu.which, unit = dropdownMenu.unit};
	-- Show the buttons which are used by this menu
	local tooltipText;
	info = UIDropDownMenu_CreateInfo();
	for index, value in ipairs(UnitPopupMenus[which]) do
		if( UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] == 1 ) then
			info.text = UnitPopupButtons[value].text;
			info.value = value;
			info.owner = which;
			info.func = UnitPopup_OnClick;
			if ( not UnitPopupButtons[value].checkable ) then
				info.notCheckable = 1;
			else
				info.notCheckable = nil;
			end
			-- Text color
			if ( value == "LOOT_THRESHOLD" ) then
				-- Set the text color
				color = ITEM_QUALITY_COLORS[GetLootThreshold()];
			else
				color = UnitPopupButtons[value].color;
			end
			if ( color ) then
				info.textR = color.r;
				info.textG = color.g;
				info.textB = color.b;
			else
				info.textR = nil;
				info.textG = nil;
				info.textB = nil;
			end
			-- Icons
			info.icon = UnitPopupButtons[value].icon;
			info.tCoordLeft = UnitPopupButtons[value].tCoordLeft;
			info.tCoordRight = UnitPopupButtons[value].tCoordRight;
			info.tCoordTop = UnitPopupButtons[value].tCoordTop;
			info.tCoordBottom = UnitPopupButtons[value].tCoordBottom;
			-- Checked conditions
			info.checked = nil;
			if ( strsub(value, 1, 12) == "RAID_TARGET_" ) then
				local raidTargetIndex = GetRaidTargetIndex("target");
				if ( raidTargetIndex == index ) then
					info.checked = 1;
				end
			end

			if ( UnitPopupButtons[value].nested ) then
				info.hasArrow = 1;
			else
				info.hasArrow = nil;
			end
			
			-- Setup newbie tooltips
			info.tooltipTitle = UnitPopupButtons[value].text;
			tooltipText = getglobal("NEWBIE_TOOLTIP_UNIT_"..value);
			if ( not tooltipText ) then
				tooltipText = UnitPopupButtons[value].tooltipText;
			end
			info.tooltipText = tooltipText;
			UIDropDownMenu_AddButton(info);
		end
	end
	PlaySound("igMainMenuOpen");
end

function UnitPopup_HideButtons()
	local dropdownMenu = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local inInstance, instanceType = IsInInstance();
	local inParty = 0;
	if ( (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0) ) then
		inParty = 1;
	end

	local isLeader = 0;
	if ( IsPartyLeader() ) then
		isLeader = 1;
	end

	local isAssistant = 0;
	if ( IsRaidOfficer() ) then
		isAssistant = 1;
	end

	local canCoop = 0;
	if ( dropdownMenu.unit and UnitCanCooperate("player", dropdownMenu.unit) ) then
		canCoop = 1;
	end
	for index, value in ipairs(UnitPopupMenus[dropdownMenu.which]) do
		UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 1;
		if ( value == "TRADE" ) then
			if ( canCoop == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "INVITE" ) then
			if ( dropdownMenu.unit ) then
				if ( canCoop == 0  or dropdownMenu.name == UnitName("player") ) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
				end
			elseif ( (dropdownMenu == PVPDropDown) and not PVPDropDown.online ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			else
				if ( dropdownMenu.name == UnitName("party1") or
					 dropdownMenu.name == UnitName("party2") or
					 dropdownMenu.name == UnitName("party3") or
					 dropdownMenu.name == UnitName("party4") or
					 dropdownMenu.name == UnitName("player")) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
				end
			end
		elseif ( value == "FOLLOW" ) then
			if ( canCoop == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "WHISPER" ) then
			if ( dropdownMenu.unit ) then
				if ( canCoop == 0  or dropdownMenu.name == UnitName("player") ) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
				end
			elseif ( (dropdownMenu == PVPDropDown) and not PVPDropDown.online ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "DUEL" ) then
			if ( canCoop == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "INSPECT" ) then
			if ( canCoop == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "IGNORE" ) then
			if ( dropdownMenu.name == UnitName("player") and dropdownMenu.unit and canCoop == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "REPORT_SPAM" ) then
			if ( not dropdownMenu.lineID or not CanComplainChat(dropdownMenu.lineID) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "TARGET" ) then
			-- We don't want to show a menu option that will end up being blocked
			if ( InCombatLockdown() or not issecure() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( (dropdownMenu == PVPDropDown) and not PVPDropDown.online ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "PROMOTE" ) then
			if ( (inParty == 0) or (isLeader == 0) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "GUILD_PROMOTE" ) then
			if ( not IsGuildLeader() or dropdownMenu.name == UnitName("player") or not GuildFrame:IsShown() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "GUILD_LEAVE" ) then
			if ( dropdownMenu.name ~= UnitName("player") or not GuildFrame:IsShown() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "TEAM_PROMOTE" ) then
			if ( dropdownMenu.name == UnitName("player") or not PVPTeamDetails:IsShown() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( PVPTeamDetails:IsShown() and not IsArenaTeamCaptain(PVPTeamDetails.team) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "TEAM_KICK" ) then
			if ( dropdownMenu.name == UnitName("player") or not PVPTeamDetails:IsShown() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( PVPTeamDetails:IsShown() and not IsArenaTeamCaptain(PVPTeamDetails.team) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "TEAM_LEAVE" ) then
			if ( dropdownMenu.name ~= UnitName("player") or not PVPTeamDetails:IsShown() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "UNINVITE" ) then
			if ( (inParty == 0) or (isLeader == 0) or (instanceType == "pvp") or (instanceType == "arena") ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "LEAVE" ) then
			if ( (inParty == 0) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "FREE_FOR_ALL" ) then
			if ( (inParty == 0) or ((isLeader == 0) and (GetLootMethod() ~= "freeforall")) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "ROUND_ROBIN" ) then
			if ( (inParty == 0) or ((isLeader == 0) and (GetLootMethod() ~= "roundrobin")) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "MASTER_LOOTER" ) then
			if ( (inParty == 0) or ((isLeader == 0) and (GetLootMethod() ~= "master")) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "GROUP_LOOT" ) then
			if ( (inParty == 0) or ((isLeader == 0) and (GetLootMethod() ~= "group")) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "NEED_BEFORE_GREED" ) then
			if ( (inParty == 0) or ((isLeader == 0) and (GetLootMethod() ~= "needbeforegreed")) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "LOOT_THRESHOLD" ) then
			if ( inParty == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "LOOT_PROMOTE" ) then
			local lootMethod;
			local partyIndex, raidIndex;
			local isMaster = nil;
			lootMethod, partyIndex, raidIndex = GetLootMethod();
			if ( (dropdownMenu.which == "RAID") or (dropdownMenu.which == "RAID_PLAYER") ) then
				if ( raidIndex and (dropdownMenu.unit == "raid"..raidIndex) ) then
					isMaster = 1;
				end
			elseif ( dropdownMenu.which == "SELF" ) then
				 if ( partyIndex and (partyIndex == 0) ) then
					isMaster = 1;
				 end
			else
				if ( partyIndex and (dropdownMenu.unit == "party"..partyIndex) ) then
					isMaster = 1;
				end
			end
			if ( (inParty == 0) or (isLeader == 0) or (lootMethod ~= "master") or isMaster ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "LOOT_METHOD" ) then
			if ( inParty == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "RESET_INSTANCES" ) then
			if ( ( inParty == 1 and isLeader == 0 ) or inInstance) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "DUNGEON_DIFFICULTY" ) then
			if ( UnitLevel("player") < 65 and GetCurrentDungeonDifficulty() == 1) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end

		elseif ( value == "RAID_LEADER" ) then
			if ( (isLeader == 0) or UnitIsPartyLeader(dropdownMenu.unit)or not dropdownMenu.name ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "RAID_PROMOTE" ) then
			if ( isLeader == 0 ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( isLeader == 1 ) then
				if ( UnitIsRaidOfficer(dropdownMenu.unit) ) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
				end			
			end
		elseif ( value == "RAID_DEMOTE" ) then
			if ( ( isLeader == 0 and isAssistant == 0 ) or not dropdownMenu.name ) then			
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( not GetPartyAssignment("MAINTANK", dropdownMenu.name, 1) and not GetPartyAssignment("MAINASSIST", dropdownMenu.name, 1) ) then
				if ( isLeader == 0  and isAssistant == 1 and UnitIsRaidOfficer(dropdownMenu.unit) ) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
				elseif ( isLeader == 1 or isAssistant == 1 ) then
					if ( UnitIsPartyLeader(dropdownMenu.unit) or not UnitIsRaidOfficer(dropdownMenu.unit)) then
						UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
					end
				end
			end
		elseif ( value == "RAID_MAINTANK" ) then
			-- We don't want to show a menu option that will end up being blocked
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role = GetRaidRosterInfo(dropdownMenu.userData);
			if ( not issecure() or (isLeader == 0 and isAssistant == 0) or (role == "MAINTANK") or not dropdownMenu.name ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "RAID_MAINASSIST" ) then
			-- We don't want to show a menu option that will end up being blocked
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role = GetRaidRosterInfo(dropdownMenu.userData);
			if ( not issecure() or (isLeader == 0 and isAssistant == 0) or (role == "MAINASSIST") or not dropdownMenu.name ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "RAID_REMOVE" ) then
			if ( ( isLeader == 0 and isAssistant == 0 ) or not dropdownMenu.name ) then			
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( isLeader == 0 and isAssistant == 1 and UnitIsRaidOfficer(dropdownMenu.unit) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			elseif ( isLeader == 1 and UnitIsUnit(dropdownMenu.unit, "player") ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "PET_PAPERDOLL" ) then
			if( not PetCanBeAbandoned() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "PET_RENAME" ) then
			if( not PetCanBeAbandoned() or not PetCanBeRenamed() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "PET_ABANDON" ) then
			if( not PetCanBeAbandoned() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "PET_DISMISS" ) then
			if( PetCanBeAbandoned() ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( strsub(value, 1, 12)  == "RAID_TARGET_" ) then
			if ( (inParty == 0) or ((isLeader == 0) and (isAssistant == 0)) ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
			if ( not (dropdownMenu.which == "SELF") ) then
				if ( UnitExists("target") and not UnitPlayerOrPetInParty("target") and not UnitPlayerOrPetInRaid("target") ) then
					if ( UnitIsPlayer("target") and (not UnitCanCooperate("player", "target") and not UnitIsUnit("target", "player")) ) then
						UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
					end
				end
			end
		end
	end
end

function UnitPopup_OnUpdate(elapsed)
	if ( not DropDownList1:IsShown() ) then
		return;
	end

	-- If none of the untipopup frames are visible then return
	for index, value in ipairs(UnitPopupFrames) do
		if ( UIDROPDOWNMENU_OPEN_MENU == value ) then
			break;
		elseif ( index == #UnitPopupFrames ) then
			return;
		end
	end

	local inParty = 0;
	if ( (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0) ) then
		inParty = 1;
	end

	local isCaptain
	if (PVPTeamDetails.team and IsArenaTeamCaptain(PVPTeamDetails.team) ) then
		isCaptain = 1;
	end

	local isLeader = 0;
	if ( IsPartyLeader() ) then
		isLeader = 1;
	end
	local isAssistant = 0;
	if ( IsRaidOfficer() ) then
		isAssistant = 1;
	end
	-- Loop through all menus and enable/disable their buttons appropriately
	local count, tempCount;
	local inInstance, instanceType = IsInInstance();
	for level, dropdownFrame in pairs(OPEN_DROPDOWNMENUS) do
		if ( dropdownFrame ) then
			count = 0;
			for index, value in ipairs(UnitPopupMenus[dropdownFrame.which]) do				
				if ( UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] == 1 ) then
					count = count + 1;
					local enable = 1;
					if ( UnitPopupButtons[value].dist > 0 ) then
						if ( not CheckInteractDistance(dropdownFrame.unit, UnitPopupButtons[value].dist) ) then
							enable = 0;
						end
					end
					
					if ( value == "TRADE" ) then
						if ( UnitIsDeadOrGhost("player") or (not HasFullControl()) or UnitIsDeadOrGhost(dropdownFrame.unit) ) then
							enable = 0;
						end
					elseif ( value == "LEAVE" ) then
						if ( inParty == 0 ) then
							enable = 0;
						end
					elseif ( value == "INVITE" ) then
						if ( inParty == 1 and (isLeader == 0 and isAssistant == 0)) then
							enable = 0;
						end
					elseif ( value == "UNINVITE" ) then
						if ( inParty == 0 or isLeader == 0 ) then
							enable = 0;
						end
					elseif ( value == "PROMOTE" ) then
						if ( inParty == 0 or isLeader == 0 or ( dropdownFrame.unit and not UnitIsConnected(dropdownFrame.unit) ) ) then
							enable = 0;
						end
					elseif ( value == "WHISPER" ) then
						if ( dropdownFrame.unit and not UnitIsConnected(dropdownFrame.unit) ) then
							enable = 0;
						end
					elseif ( value == "INSPECT" ) then
						if ( UnitIsDeadOrGhost("player") ) then
							enable = 0;
						end
					elseif ( value == "FOLLOW" ) then
						if ( UnitIsDead("player") ) then
							enable = 0;
						end
					elseif ( value == "DUEL" ) then
						if ( UnitIsDeadOrGhost("player") or (not HasFullControl()) or UnitIsDeadOrGhost(dropdownFrame.unit) ) then
							enable = 0;
						end
					elseif ( value == "LOOT_PROMOTE" ) then
						local lootMethod;
						local partyMaster, raidMaster;
						lootMethod, partyMaster, raidMaster = GetLootMethod();
						if ( (inParty == 0) or (isLeader == 0) or (lootMethod ~= "master") ) then
							enable = 0;
						else
							local masterName = 0;
							if ( partyMaster and (partyMaster == 0) ) then
								masterName = "player";
							elseif ( partyMaster ) then
								masterName = "party"..partyMaster;
							elseif ( raidMaster ) then
								masterName = "raid"..raidMaster;
							end
							if ( dropdownFrame.unit and UnitIsUnit(dropdownFrame.unit, masterName) ) then
								enable = 0;
							end
						end
					elseif ( ( strsub(value, 1, 18) == "DUNGEON_DIFFICULTY" ) and ( strlen(value) > 18 ) ) then
						if ( ( inParty == 1 and isLeader == 0 ) or inInstance ) then
							enable = 0;	
							
						end			
					elseif ( value == "RESET_INSTANCES" ) then
						if ( ( inParty == 1 and isLeader == 0 ) or inInstance ) then
							enable = 0;			
						end
					end

					if ( level > 1 ) then
						tempCount = count;
					else
						tempCount = count + 1;
					end

					if ( enable == 1 ) then
						UIDropDownMenu_EnableButton(level, tempCount);
					else
						UIDropDownMenu_DisableButton(level, tempCount);
					end
				end
			end
		end
	end
end

function UnitPopup_OnClick()
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button = this.value;
	local unit = dropdownFrame.unit;
	local name = dropdownFrame.name;
	local server = dropdownFrame.server;
	local fullname = name;

	if(server and not UnitIsSameServer("player", unit)) then
		fullname = name.."-"..server;
	end

	local inParty = 0;
	if ( (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0) ) then
		inParty = 1;
	end

	local isLeader = 0;
	if ( IsPartyLeader() ) then
		isLeader = 1;
	end
	local isAssistant = 0;
	if ( IsRaidOfficer() ) then
		isAssistant = 1;
	end

	if ( button == "TRADE" ) then
		InitiateTrade(unit);
	elseif ( button == "WHISPER" ) then
		ChatFrame_SendTell(fullname);
	elseif ( button == "INSPECT" ) then
		InspectUnit(unit);
	elseif ( button == "TARGET" ) then
		TargetUnit(fullname, 1);
	elseif ( button == "IGNORE" ) then
		AddOrDelIgnore(fullname);
	elseif ( button == "REPORT_SPAM" ) then
		local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", name);
		if ( dialog ) then
			dialog.data = dropdownFrame.lineID;
		end
	elseif ( button == "DUEL" ) then
		StartDuel(unit, 1);
	elseif ( button == "INVITE" ) then
		if ( unit ) then
			InviteUnit(unit);
		else
			InviteUnit(name);
		end
	elseif ( button == "UNINVITE" ) then
		UninviteUnit(unit);
	elseif ( button == "PROMOTE" ) then
		PromoteToLeader(unit, 1);
	elseif ( button == "GUILD_PROMOTE" ) then
		local dialog = StaticPopup_Show("CONFIRM_GUILD_PROMOTE", name);
		dialog.data = name;
	elseif ( button == "GUILD_LEAVE" ) then
		StaticPopup_Show("CONFIRM_GUILD_LEAVE", GetGuildInfo("player"));
	elseif ( button == "TEAM_PROMOTE" ) then
		local dialog = StaticPopup_Show("CONFIRM_TEAM_PROMOTE", name, GetArenaTeam(PVPTeamDetails.team));
		if ( dialog ) then
			dialog.data = PVPTeamDetails.team;
			dialog.data2 = name;
		end
	elseif ( button == "TEAM_KICK" ) then
		local dialog = StaticPopup_Show("CONFIRM_TEAM_KICK", name, GetArenaTeam(PVPTeamDetails.team) );
		if ( dialog ) then
			dialog.data = PVPTeamDetails.team;
			dialog.data2 = name;
		end
	elseif ( button == "TEAM_LEAVE" ) then
		StaticPopup_Show("CONFIRM_TEAM_LEAVE", GetArenaTeam(PVPTeamDetails.team) );
	elseif ( button == "LEAVE" ) then
		LeaveParty();
	elseif ( button == "PET_DISMISS" ) then
		PetDismiss();
	elseif ( button == "PET_ABANDON" ) then
		StaticPopup_Show("ABANDON_PET");
	elseif ( button == "PET_PAPERDOLL" ) then
		ToggleCharacter("PetPaperDollFrame");
	elseif ( button == "PET_RENAME" ) then
		StaticPopup_Show("RENAME_PET");
	elseif ( button == "FREE_FOR_ALL" ) then
		SetLootMethod("freeforall");
		UIDropDownMenu_SetButtonText(1, 3, UnitPopupButtons[button].text);
		UIDropDownMenu_Refresh(dropdownFrame, nil, 1);
	elseif ( button == "ROUND_ROBIN" ) then
		SetLootMethod("roundrobin");
		UIDropDownMenu_SetButtonText(1, 3, UnitPopupButtons[button].text);
		UIDropDownMenu_Refresh(dropdownFrame, nil, 1);
	elseif ( button == "MASTER_LOOTER" ) then
		SetLootMethod("master", name);
		UIDropDownMenu_SetButtonText(1, 3, UnitPopupButtons[button].text);
		UIDropDownMenu_Refresh(dropdownFrame, nil, 1);
	elseif ( button == "GROUP_LOOT" ) then
		SetLootMethod("group");
		UIDropDownMenu_SetButtonText(1, 3, UnitPopupButtons[button].text);
		UIDropDownMenu_Refresh(dropdownFrame, nil, 1);
	elseif ( button == "NEED_BEFORE_GREED" ) then
		SetLootMethod("needbeforegreed");
		UIDropDownMenu_SetButtonText(1, 3, UnitPopupButtons[button].text);
		UIDropDownMenu_Refresh(dropdownFrame, nil, 1);
	elseif ( strsub(button, 1, 18) == "DUNGEON_DIFFICULTY" and (strlen(button) > 18) ) then
		local dungeonDifficulty = tonumber( strsub(button,19,19) );
		if ( inParty == 1 and (isLeader == 1 or isAssistant == 1) ) then
			SetDungeonDifficulty(dungeonDifficulty,1,1);
		else
			SetDungeonDifficulty(dungeonDifficulty,1,0);
		end
	elseif ( button == "LOOT_PROMOTE" ) then
		SetLootMethod("master", name, 1);
	elseif ( button == "PVP_ENABLE" ) then
		SetPVP(1);
	elseif ( button == "PVP_DISABLE" ) then
		SetPVP(nil);
	elseif ( button == "RESET_INSTANCES" ) then
		StaticPopup_Show("CONFIRM_RESET_INSTANCES");
	elseif ( button == "FOLLOW" ) then
		FollowUnit(fullname, 1);
	elseif ( button == "RAID_LEADER" ) then
		PromoteToLeader(fullname, 1)
	elseif ( button == "RAID_PROMOTE" ) then
		PromoteToAssistant(fullname, 1);
	elseif ( button == "RAID_DEMOTE" ) then
		if ( isLeader == 1 and UnitIsRaidOfficer(unit) ) then
			DemoteAssistant(fullname, 1);
		end
		if ( GetPartyAssignment("MAINTANK", fullname, 1) ) then
			ClearPartyAssignment("MAINTANK", fullname, 1);
		elseif ( GetPartyAssignment("MAINASSIST", fullname, 1) ) then	
			ClearPartyAssignment("MAINASSIST", fullname, 1);
		end
	elseif ( button == "RAID_MAINTANK" ) then
		SetPartyAssignment("MAINTANK", fullname, 1);
	elseif ( button == "RAID_MAINASSIST" ) then
		SetPartyAssignment("MAINASSIST", fullname, 1);
	elseif ( button == "RAID_REMOVE" ) then
		UninviteUnit(name);
	elseif ( button == "ITEM_QUALITY2_DESC" or button == "ITEM_QUALITY3_DESC" or button == "ITEM_QUALITY4_DESC" ) then
		SetLootThreshold(this:GetID()+1);
		local color = ITEM_QUALITY_COLORS[this:GetID()+1];
		UIDropDownMenu_SetButtonText(1, 4, UnitPopupButtons[button].text, color.r, color.g, color.b);
	elseif ( strsub(button, 1, 12) == "RAID_TARGET_" and button ~= "RAID_TARGET_ICON" ) then
		local raidTargetIndex = strsub(button, 13);
		if ( raidTargetIndex == "NONE" ) then
			raidTargetIndex = 0;
		end
		SetRaidTargetIcon(unit, tonumber(raidTargetIndex));
	end
	PlaySound("UChatScrollButton");
end
