
GlueWoWLogo = {}
GlueWoWLogo[1] = "Interface\\Glues\\Common\\Glues-WoW-Logo";
GlueWoWLogo[2] = "Interface\\Glues\\Common\\Glues-WOW-BClogo";

GlueBackgroundMusic = { };
GlueBackgroundMusic[1] = "GS_Retail";
GlueBackgroundMusic[2] = "GS_BurningCrusade";
CurrentGlueMusic = GlueBackgroundMusic[1];

GlueCreditsSoundKits = { };
GlueCreditsSoundKits[1] = "Menu-Credits01";
GlueCreditsSoundKits[2] = "Menu-Credits02";


GlueScreenInfo = { };
GlueScreenInfo["login"]			= "AccountLogin";
GlueScreenInfo["charselect"]	= "CharacterSelect";
GlueScreenInfo["realmwizard"]	= "RealmWizard";
GlueScreenInfo["charcreate"]	= "CharacterCreate";
GlueScreenInfo["patchdownload"]	= "PatchDownload";
GlueScreenInfo["movie"]			= "MovieFrame";
GlueScreenInfo["credits"]		= "CreditsFrame";

CharModelFogInfo = { };
CharModelFogInfo["HUMAN"] = { r=0.8, g=0.65, b=0.73, far=222 };
CharModelFogInfo["ORC"] = { r=0.5, g=0.5, b=0.5, far=270 };
CharModelFogInfo["DWARF"] = { r=0.85, g=0.88, b=1.0, far=500 };
CharModelFogInfo["NIGHTELF"] = { r=0.25, g=0.22, b=0.55, far=611 };
CharModelFogInfo["TAUREN"] = { r=1.0, g=0.61, b=0.42, far=153 };
CharModelFogInfo["SCOURGE"] = { r=0, g=0.22, b=0.22, far=26 };

GlueAmbienceTracks = { };
GlueAmbienceTracks["HUMAN"] = "GlueScreenHuman";
GlueAmbienceTracks["ORC"] = "GlueScreenOrcTroll";
GlueAmbienceTracks["DWARF"] = "GlueScreenDwarfGnome";
GlueAmbienceTracks["TAUREN"] = "GlueScreenTauren";
GlueAmbienceTracks["SCOURGE"] = "GlueScreenUndead";
GlueAmbienceTracks["NIGHTELF"] = "GlueScreenNightElf";
GlueAmbienceTracks["DRAENEI"] = "GlueScreenDraenei";
GlueAmbienceTracks["BLOODELF"] = "GlueScreenBloodElf";
GlueAmbienceTracks["DARKPORTAL"] = "GlueScreenIntro";

-- Alpha animation stuff
FADEFRAMES = {};
CURRENT_GLUE_SCREEN = nil;
PENDING_GLUE_SCREEN = nil;
-- Time in seconds to fade
LOGIN_FADE_IN = 1.5;
LOGIN_FADE_OUT = 0.5;
CHARACTER_SELECT_FADE_IN = 0.75;
RACE_SELECT_INFO_FADE_IN = .5;
RACE_SELECT_INFO_FADE_OUT = .5;

-- Realm Split info
SERVER_SPLIT_SHOW_DIALOG = false;
SERVER_SPLIT_CLIENT_STATE = -1;	--	-1 uninitialized; 0 - no choice; 1 - realm 1; 2 - realm 2
SERVER_SPLIT_STATE_PENDING = -1;	--	-1 uninitialized; 0 - no server split; 1 - server split (choice mode); 2 - server split (no choice mode)
SERVER_SPLIT_DATE = nil;

-- Account Messaging info
ACCOUNT_MSG_NUM_AVAILABLE = 0;
ACCOUNT_MSG_PRIORITY = 0;
ACCOUNT_MSG_HEADERS_LOADED = false;
ACCOUNT_MSG_BODY_LOADED = false;
ACCOUNT_MSG_CURRENT_INDEX = nil;


function SetGlueScreen(name)
	local newFrame;
	for index, value in pairs(GlueScreenInfo) do
		local frame = getglobal(value);
		if ( frame ) then
			frame:Hide();
			if ( index == name ) then
				newFrame = frame;
			end
		end
	end
	
	if ( newFrame ) then
		newFrame:Show();
		SetCurrentScreen(name);
		SetCurrentGlueScreenName(name);
		if ( name == "credits" ) then
			PlayCreditsMusic( GlueCreditsSoundKits[CreditsFrame.creditsType] );
			StopGlueAmbience();
		elseif ( name == "movie" ) then
			StopGlueMusic();
			StopGlueAmbience();
		else
			PlayGlueMusic(CurrentGlueMusic);
			if (name == "login") then
				PlayGlueAmbience(GlueAmbienceTracks["DARKPORTAL"], 4.0);
			end
		end
	end
end

function SetCurrentGlueScreenName(name)
	CURRENT_GLUE_SCREEN = name;
end

function GetCurrentGlueScreenName()
	return CURRENT_GLUE_SCREEN;
end

function SetPendingGlueScreenName(name)
	PENDING_GLUE_SCREEN = name;
end

function GetPendingGlueScreenName()
	return PENDING_GLUE_SCREEN;
end

function GlueParent_OnLoad()
	local width = GetScreenWidth();
	local height = GetScreenHeight();
	
	if ( width / height > 16 / 9) then
		local maxWidth = height * 16 / 9;
		local barWidth = ( width - maxWidth ) / 2;
		this:ClearAllPoints();
		this:SetPoint("TOPLEFT", barWidth, 0); 
		this:SetPoint("BOTTOMRIGHT", -barWidth, 0);
	end
	
	this:RegisterEvent("FRAMES_LOADED");
	this:RegisterEvent("SET_GLUE_SCREEN");
	this:RegisterEvent("START_GLUE_MUSIC");
	this:RegisterEvent("DISCONNECTED_FROM_SERVER");
	this:RegisterEvent("GET_PREFERRED_REALM_INFO");
	this:RegisterEvent("SERVER_SPLIT_NOTICE");
	this:RegisterEvent("ACCOUNT_MESSAGES_AVAILABLE");
	this:RegisterEvent("ACCOUNT_MESSAGES_HEADERS_LOADED");
	this:RegisterEvent("ACCOUNT_MESSAGES_BODY_LOADED");
end

function GlueParent_OnEvent(event)
	if ( event == "FRAMES_LOADED" ) then
		LocalizeFrames();
	elseif ( event == "SET_GLUE_SCREEN" ) then
		GlueScreenExit(GetCurrentGlueScreenName(), arg1);
	elseif ( event == "START_GLUE_MUSIC" ) then
		PlayGlueMusic(CurrentGlueMusic);
		PlayGlueAmbience(GlueAmbienceTracks["DARKPORTAL"], 4.0);
	elseif ( event == "DISCONNECTED_FROM_SERVER" ) then
		SetGlueScreen("login");
		if ( arg1 == 4 ) then
			GlueDialog_Show("PARENTAL_CONTROL");
		else
			GlueDialog_Show("DISCONNECTED");
		end
	elseif ( event == "GET_PREFERRED_REALM_INFO" ) then
		SetGlueScreen("realmwizard");
		PlayGlueAmbience(GlueAmbienceTracks["DARKPORTAL"], 4.0);
	elseif ( event == "SERVER_SPLIT_NOTICE" ) then
		CharacterSelectRealmSplitButton:Show();
		if ( SERVER_SPLIT_STATE_PENDING == -1 and arg1 == 0 and arg2 == 1 ) then
			SERVER_SPLIT_SHOW_DIALOG = true;
		end
		SERVER_SPLIT_CLIENT_STATE = arg1;
		SERVER_SPLIT_STATE_PENDING = arg2;
		SERVER_SPLIT_DATE = arg3;
	elseif ( event == "ACCOUNT_MESSAGES_AVAILABLE" ) then
--		ACCOUNT_MSG_NUM_AVAILABLE = arg1;
		ACCOUNT_MSG_HEADERS_LOADED = false;
		ACCOUNT_MSG_BODY_LOADED = false;
		ACCOUNT_MSG_CURRENT_INDEX = nil;
		AccountMsg_LoadHeaders();
	elseif ( event == "ACCOUNT_MESSAGES_HEADERS_LOADED" ) then
		ACCOUNT_MSG_HEADERS_LOADED = true;
		ACCOUNT_MSG_NUM_AVAILABLE = AccountMsg_GetNumUnreadUrgentMsgs();
		ACCOUNT_MSG_CURRENT_INDEX = AccountMsg_GetIndexHighestPriorityUnreadMsg();
		AccountMsg_LoadBody( ACCOUNT_MSG_CURRENT_INDEX );
	elseif ( event == "ACCOUNT_MESSAGES_BODY_LOADED" ) then
		AccountMsg_SetMsgRead(ACCOUNT_MSG_CURRENT_INDEX);
		ACCOUNT_MSG_BODY_LOADED = true;
	end
end

-- Glue screen animation handling
function GlueScreenExit(currentFrame, pendingFrame)
	if ( currentFrame == "login" and pendingFrame == "charselect" ) then
		GlueFrameFadeOut(AccountLoginUI, LOGIN_FADE_OUT, GoToPendingGlueScreen);
		SetPendingGlueScreenName(pendingFrame);
	else
		SetGlueScreen(pendingFrame);
	end
end

function GoToPendingGlueScreen()
	SetGlueScreen(GetPendingGlueScreenName());
end

-- Generic fade function
function GlueFrameFade(frame, timeToFade, mode, finishedFunction)
	if ( frame ) then
		frame.fadeTimer = 0;
		frame.timeToFade = timeToFade;
		frame.mode = mode;
		-- finishedFunction is an optional function that is called when the animation is complete
		if ( finishedFunction ) then
			frame.finishedFunction = finishedFunction;
		end
		tinsert(FADEFRAMES, frame);
	end
end

-- Fade in function
function GlueFrameFadeIn(frame, timeToFade, finishedFunction)
	GlueFrameFade(frame, timeToFade, "IN", finishedFunction);
end

-- Fade out function
function GlueFrameFadeOut(frame, timeToFade, finishedFunction)
	GlueFrameFade(frame, timeToFade, "OUT", finishedFunction);
end

-- Function that actually performs the alpha change
function GlueFrameFadeUpdate(elapsed)
	local index = 1;
	while FADEFRAMES[index] do
		local frame = FADEFRAMES[index];
		frame.fadeTimer = frame.fadeTimer + elapsed;
		if ( frame.fadeTimer < frame.timeToFade ) then
			if ( frame.mode == "IN" ) then
				frame:SetAlpha(frame.fadeTimer / frame.timeToFade);
			elseif ( frame.mode == "OUT" ) then
				frame:SetAlpha((frame.timeToFade - frame.fadeTimer) / frame.timeToFade);
			end
		else
			if ( frame.mode == "IN" ) then
				frame:SetAlpha(1.0);
			elseif ( frame.mode == "OUT" ) then
				frame:SetAlpha(0);
			end
			GlueFrameFadeRemoveFrame(frame);
			if ( frame.finishedFunction ) then
				frame.finishedFunction();
				frame.finishedFunction = nil;
			end
		end
		index = index + 1;
	end
end

function GlueFrameRemoveFrame(frame, list)
	local index = 1;
	while list[index] do
		if ( frame == list[index] ) then
			tremove(list, index);
		end
		index = index + 1;
	end
end

function GlueFrameFadeRemoveFrame(frame)
	GlueFrameRemoveFrame(frame, FADEFRAMES);
end

-- Function to set the background model for character select and create screens
function SetBackgroundModel(model, race)
-- HACK!!!
	if ( race == "Gnome" or race == "GNOME" ) then
		race = "Dwarf";
	elseif ( race == "Troll" or race == "TROLL" ) then
		race = "Orc";
	end
	if ( not race ) then
		race = "Orc";
	end
-- END HACK

	if ( CharacterCreate:IsShown() ) then
		SetCharCustomizeBackground("Interface\\Glues\\Models\\UI_"..race.."\\UI_"..race..".mdx");
	else
		SetCharSelectBackground("Interface\\Glues\\Models\\UI_"..race.."\\UI_"..race..".mdx");
	end
	model:SetSequence(0);
	model:SetCamera(0);

	PlayGlueAmbience(GlueAmbienceTracks[strupper(race)]);

	local fogInfo = CharModelFogInfo[strupper(race)];
	if ( fogInfo ) then
		model:SetFogColor(fogInfo.r, fogInfo.g, fogInfo.b);
		model:SetFogNear(0);
		model:SetFogFar(fogInfo.far);
	else
		model:ClearFog();
	end
end

function SecondsToTime(seconds, noSeconds)
	local time = "";
	local count = 0;
	local tempTime;
	seconds = floor(seconds);
	if ( seconds >= 86400  ) then
		tempTime = floor(seconds / 86400);
		time = tempTime.." "..GetText("DAYS_ABBR", nil, tempTime).." ";
		seconds = mod(seconds, 86400);
		count = count + 1;
	end
	if ( seconds >= 3600  ) then
		tempTime = floor(seconds / 3600);
		time = time..tempTime.." "..GetText("HOURS_ABBR", nil, tempTime).." ";
		seconds = mod(seconds, 3600);
		count = count + 1;
	end
	if ( count < 2 and seconds >= 60  ) then
		tempTime = floor(seconds / 60);
		time = time..tempTime.." "..GetText("MINUTES_ABBR", nil, tempTime).." ";
		seconds = mod(seconds, 60);
		count = count + 1;
	end
	if ( count < 2 and seconds > 0 and not noSeconds ) then
		seconds = format("%d", seconds);
		time = time..seconds.." "..GetText("SECONDS_ABBR", nil, seconds).." ";
	end
	return time;
end

function MinutesToTime(mins, hideDays)
	local time = "";
	local count = 0;
	local tempTime;
	-- only show days if hideDays is false
	if ( mins > 1440 and not hideDays ) then
		tempTime = floor(mins / 1440);
		time = tempTime.." "..GetText("DAYS_ABBR", nil, tempTime).." ";
		mins = mod(mins, 1440);
		count = count + 1;
	end
	if ( mins > 60  ) then
		tempTime = floor(mins / 60);
		time = time..tempTime.." "..GetText("HOURS_ABBR", nil, tempTime).." ";
		mins = mod(mins, 60);
		count = count + 1;
	end
	if ( count < 2 ) then
		tempTime = mins;
		time = time..tempTime.." "..GetText("MINUTES_ABBR", nil, tempTime).." ";
		count = count + 1;
	end
	return time;
end

-- Locale property stuff, copied from LocaleProperties.lua

-- This function takes a token, gender, and/or ordinality and looks up the correct string token
-- The gender is a number with the following values:
-- nil - GENDER_NOT_APPLICABLE
-- 1 - GENDER_NONE
-- 2 - GENDER_MALE
-- 3 - GENDER_FEMALE
-- 4 - GENDER_MALE_PLURAL
-- 5 - GENDER_FEMALE_PLURAL
-- 6 - GENDER_MIXED_PLURAL

-- Tags applied to variable names are:
-- 1 - "_NONE"
-- 2 - ""	*Male is default!*
-- 3 - "_FEMALE"
-- 4 - "_MPLURAL"
-- 5 - "_FPLURAL"
-- 6 - "_MIXED"

-- MALE is default
GenderTagInfo = { "_NONE", nil, "_FEMALE", "_MPLURAL", "_FPLURAL", "_MIXED" };

MAX_GENDER_INDICES = 6;
MAX_PLURAL_INDICES = 4;

function GetText(token, gender, ordinal)
	local variable = token;
	local genderTag = GetGenderTag(gender);
	local pluralTag = GetPluralTag(ordinal);

	if ( pluralTag ) then
		variable = variable..pluralTag;
	end
	if ( genderTag ) then
		variable = variable..genderTag;
	end

	local string = getglobal(variable);
	if ( not string ) then
		if ( pluralTag and genderTag ) then
			string = getglobal(token..pluralTag);
			if ( not string ) then
				string = getglobal(token..genderTag);	
				if ( not string ) then
					string = getglobal(token);
				end
			end
		else
			string = getglobal(token);
		end
	end

	return string;
end

function GetPluralIndex(ordinal)
	if ( not ordinal or (ordinal == 1) ) then
		return 1;
	else
		return 2;
	end
end

function GetPluralTag(ordinal)
	local index = GetPluralIndex(ordinal);
	if ( (index <= 1) or (index > MAX_PLURAL_INDICES) ) then
		return nil;
	end
	return "_P"..(index - 1);
end

function GetGenderTag(gender)
	if ( not gender or (gender < 1) or (gender > MAX_GENDER_INDICES) ) then
		return nil;
	end
	return GenderTagInfo[gender];
end

function TriStateCheckbox_SetState(checked, checkButton)
	if ( not checkButton ) then
		checkButton = this;
	end
	local checkedTexture = getglobal(checkButton:GetName().."CheckedTexture");
	if ( not checkedTexture ) then
		message("Can't find checked texture");
	end
	if ( not checked or checked == 0 ) then
		-- nil or 0 means not checked
		checkButton:SetChecked(nil);
		checkButton.state = 0;
	elseif ( checked == 2 ) then
		-- 2 is a normal
		checkButton:SetChecked(1);
		checkedTexture:SetVertexColor(1, 1, 1);
		checkedTexture:SetDesaturated(0);
		checkButton.state = 2;
	else
		-- 1 is a gray check
		checkButton:SetChecked(1);
		local shaderSupported = checkedTexture:SetDesaturated(1);
		if ( not shaderSupported ) then
			checkedTexture:SetVertexColor(0.5, 0.5, 0.5);
		end
		checkButton.state = 1;
	end
end

function SetLogo(expansion)
	AccountLoginLogo:SetTexture(GlueWoWLogo[expansion]);
	CharacterSelectLogo:SetTexture(GlueWoWLogo[expansion]);
	CharacterCreateLogo:SetTexture(GlueWoWLogo[expansion]);
	CreditsLogo:SetTexture(GlueWoWLogo[expansion]);
	RealmWizardLogo:SetTexture(GlueWoWLogo[expansion]);
	PatchDownloadLogo:SetTexture(GlueWoWLogo[expansion]);

	if ( expansion == 2 ) then
		CharacterCreateConfigurationFrame:SetPoint("TOPLEFT", CharacterCreateFrame, "TOPLEFT", 28, -60);
		CharacterCreateAllianceLabel:SetPoint("BOTTOM", CharacterCreateBanners, "TOP", -50, 0);
		CharacterCreateHordeLabel:SetPoint("BOTTOM", CharacterCreateBanners, "TOP", 50, 0);
	end
end

function SetStateRequestInfo( choice )
	if ( SERVER_SPLIT_CLIENT_STATE ~= choice ) then
		SERVER_SPLIT_CLIENT_STATE = choice;
		SetRealmSplitState(choice);
		RealmSplit_SetChoiceText();
--		RequestRealmSplitInfo();
	end
end

