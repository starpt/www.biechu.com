-- This file is executed at the end of addon load

-- Talent tabs
for i=1, 5 do
	getglobal("TalentFrameTab"..i.."Text"):SetPoint("CENTER", "TalentFrameTab"..i, "CENTER", 0, 5);
end

-- Move talent stuff
TalentFrameTalentPoints:SetPoint("RIGHT", "TalentFrameTalentPointsText", "LEFT", -3, 0);
TalentFrameTalentPointsText:SetPoint("BOTTOMRIGHT", "TalentFrame", "BOTTOMLEFT", 252, 85);
TalentFrameSpentPoints:SetPoint("TOP", "TalentFramePointsMiddle", "TOP", 0, -2);
