-- This file is executed at the end of addon load

-- Inspect Honor stuff
InspectHonorFrameCurrentSessionTitle:SetPoint("TOPLEFT", "HonorFrame", "TOPLEFT", 36, -111);
InspectHonorFrameCurrentHK:SetPoint("TOPLEFT", "InspectHonorFrameCurrentSessionTitle", "BOTTOMLEFT", 10, 1);
InspectHonorFrameYesterdayTitle:SetPoint("TOPLEFT", "InspectHonorFrameCurrentSessionTitle", "BOTTOMLEFT", 0, -36);
InspectHonorFrameYesterdayHK:SetPoint("TOPLEFT", "InspectHonorFrameYesterdayTitle", "BOTTOMLEFT", 10, -1);
InspectHonorFrameThisWeekTitle:SetPoint("TOPLEFT", "InspectHonorFrameYesterdayTitle", "BOTTOMLEFT", 0, -43);
InspectHonorFrameThisWeekHK:SetPoint("TOPLEFT", "InspectHonorFrameThisWeekTitle", "BOTTOMLEFT", 10, 2);
InspectHonorFrameLastWeekTitle:SetPoint("TOPLEFT", "InspectHonorFrameYesterdayTitle", "BOTTOMLEFT", 0, -97);
InspectHonorFrameLastWeekHK:SetPoint("TOPLEFT", "InspectHonorFrameLastWeekTitle", "BOTTOMLEFT", 10, 2);
InspectHonorFrameLifeTimeTitle:SetPoint("TOPLEFT", "InspectHonorFrameLastWeekTitle", "BOTTOMLEFT", 0, -60);
InspectHonorFrameLifeTimeHK:SetPoint("TOPLEFT", "InspectHonorFrameLifeTimeTitle", "BOTTOMLEFT", 10, 2);