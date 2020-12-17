function Localize()
	-- Put all locale specific string adjustments here
end

function LocalizeFrames()
	-- Put all locale specific UI adjustments here
	AccountLoginLogo:SetTexture("Interface\\Glues\\Common\\Glues-WoW-ChineseLogo");
	CharacterCreateLogo:SetTexture("Interface\\Glues\\Common\\Glues-WoW-ChineseLogo");
	CharacterSelectLogo:SetTexture("Interface\\Glues\\Common\\Glues-WoW-ChineseLogo");
	CreditsLogo:SetTexture("Interface\\Glues\\Common\\Glues-WoW-ChineseLogo");
	PatchDownloadLogo:SetTexture("Interface\\Glues\\Common\\Glues-WoW-ChineseLogo");
	RealmWizardLogo:SetTexture("Interface\\Glues\\Common\\Glues-WoW-ChineseLogo");
	CharacterSelectCharacterFrame:SetHeight(650);
	CharacterCreateNameEdit:SetMaxLetters(12);

	GlueWoWLogo[1] = "Interface\\Glues\\Common\\Glues-WoW-ChineseLogo";
	GlueWoWLogo[2] = "Interface\\Glues\\Common\\Glues-WOW-ChineseLogo";

	-- Hide the Roleplaying an rppvp buttons in the Chinese build
	RealmWizardStyle:SetHeight(160);
	RealmWizardGameTypeButton3:Hide();
	RealmWizardGameTypeButton4:Hide();

	-- Defined variable to show gameroom billing messages
	SHOW_GAMEROOM_BILLING_FRAME = 1;

	-- Hide save username button
	AccountLoginSaveAccountName:Hide();

	-- Fix a spacing issue in the Matrix Security Frame
	SecurityMatrixKeypadDirections:SetPoint("TOPLEFT", SecurityMatrixFrame, "TOPRIGHT", 4, 0);
end
