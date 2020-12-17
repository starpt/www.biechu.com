
-- This is a symbol available for people who need to know the locale (separate from GetLocale())
LOCALE_zhCN = true;

function Localize()
	-- Put all locale specific string adjustments here
end

function LocalizeFrames()
	-- Put all locale specific UI adjustments here
	
	-- Hide profanity checkbox
	UIOptionsFrameCheckButton5:Hide();
	
	-- Adjust spell text
	for i=1, SPELLS_PER_PAGE do
		getglobal("SpellButton"..i.."SpellName"):SetPoint("LEFT", "SpellButton"..i, "RIGHT", 4, 4);
		getglobal("SpellButton"..i.."SubSpellName"):SetPoint("TOPLEFT", "SpellButton"..i.."SpellName", "BOTTOMLEFT", 0, 1);
	end

	-- Adjust friends frame title
	FriendsFrameTitleText:SetPoint("TOP", "FriendsFrame", "TOP", 0, -15);

	-- Adjust text in character and friends frame tabs
	for i=1, 4 do
		getglobal("CharacterFrameTab"..i.."Text"):SetPoint("CENTER", "CharacterFrameTab"..i, "CENTER", 0, 5);

		getglobal("FriendsFrameTab"..i.."Text"):SetPoint("CENTER", "FriendsFrameTab"..i, "CENTER", 0, 5);
	end

	-- Guild Member Detail Window Custom Sizing
	GUILD_DETAIL_NORM_HEIGHT = 222
	GUILD_DETAIL_OFFICER_HEIGHT = 285

	-- Mailframe tabs
	for i=1, 2 do
		getglobal("MailFrameTab"..i.."Text"):SetPoint("CENTER", "MailFrameTab"..i, "CENTER", 0, 5);
	end

	-- Chat Editbox
	ChatFrameEditBoxLanguage:Show();

	-- Honor stuff
	HonorFrameCurrentSessionTitle:SetPoint("TOPLEFT", "HonorFrame", "TOPLEFT", 36, -111);
	HonorFrameCurrentHK:SetPoint("TOPLEFT", "HonorFrameCurrentSessionTitle", "BOTTOMLEFT", 10, 1);
	HonorFrameYesterdayTitle:SetPoint("TOPLEFT", "HonorFrameCurrentSessionTitle", "BOTTOMLEFT", 0, -36);
	HonorFrameYesterdayHK:SetPoint("TOPLEFT", "HonorFrameYesterdayTitle", "BOTTOMLEFT", 10, -1);
	HonorFrameThisWeekTitle:SetPoint("TOPLEFT", "HonorFrameYesterdayTitle", "BOTTOMLEFT", 0, -43);
	HonorFrameThisWeekHK:SetPoint("TOPLEFT", "HonorFrameThisWeekTitle", "BOTTOMLEFT", 10, 2);
	HonorFrameLastWeekTitle:SetPoint("TOPLEFT", "HonorFrameYesterdayTitle", "BOTTOMLEFT", 0, -97);
	HonorFrameLastWeekHK:SetPoint("TOPLEFT", "HonorFrameLastWeekTitle", "BOTTOMLEFT", 10, 2);
	HonorFrameLifeTimeTitle:SetPoint("TOPLEFT", "HonorFrameLastWeekTitle", "BOTTOMLEFT", 0, -60);
	HonorFrameLifeTimeHK:SetPoint("TOPLEFT", "HonorFrameLifeTimeTitle", "BOTTOMLEFT", 10, 2);

	-- Helpframe spacing
	HelpFrameVerbalHarassmentTipText:SetPoint("TOPLEFT", "HelpFrameVerbalHarassmentDescription", "BOTTOMLEFT", 0, -10);
	VerbalAbuseTip1:SetPoint("TOPLEFT", "HelpFrameVerbalHarassmentTipText", "BOTTOMLEFT", -3, -3);
	VerbalAbuseTip2:SetPoint("TOPLEFT", "VerbalAbuseTip1", "BOTTOMLEFT", 0, -3);
	VerbalAbuseTip3:SetPoint("TOPLEFT", "VerbalAbuseTip2", "BOTTOMLEFT", 0, -3);

	HelpFramePhysicalHarassmentTipText:SetPoint("TOPLEFT", "HelpFramePhysicalHarassmentDescription", "BOTTOMLEFT", 0, -10);
	PhysicalAbuseTip1:SetPoint("TOPLEFT", "HelpFramePhysicalHarassmentTipText", "BOTTOMLEFT", -3, -3);
	PhysicalAbuseTip2:SetPoint("TOPLEFT", "PhysicalAbuseTip1", "BOTTOMLEFT", 0, -3);
	PhysicalAbuseTip3:SetPoint("TOPLEFT", "PhysicalAbuseTip2", "BOTTOMLEFT", 0, -3);
	PhysicalAbuseTip4:SetPoint("TOPLEFT", "PhysicalAbuseTip3", "BOTTOMLEFT", 0, -3);

	-- RaidInfo Frame
	RaidInfoSubheader:SetPoint("TOPLEFT", "RaidInfoHeader", "BOTTOMLEFT", 0, 0);

end
