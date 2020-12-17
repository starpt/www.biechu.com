GlueDialogTypes = { };

GlueDialogTypes["REALM_IS_FULL"] = {
	text = REALM_IS_FULL_WARNING,
	button1 = YES,
	button2 = NO,
	showAlert = 1,
	OnAccept = function()
		SetGlueScreen("charselect");
		ChangeRealm(RealmList.selectedCategory , RealmList.currentRealm);
	end,
	OnCancel = function()
		CharacterSelect_ChangeRealm();
	end,
}

GlueDialogTypes["SUGGEST_REALM"] = {
	text = format(SUGGESTED_REALM_TEXT,"UNKNOWN REALM"),
	button1 = ACCEPT,
	button2 = VIEW_ALL_REALMS,
	OnShow = function()
		GlueDialogText:SetText(format(SUGGESTED_REALM_TEXT, RealmWizard.suggestedRealmName));
	end,
	OnAccept = function()
		SetGlueScreen("charselect");
		ChangeRealm(RealmWizard.suggestedCategory, RealmWizard.suggestedID);
	end,
	OnCancel = function()
		SetGlueScreen("charselect");
		CharacterSelect_ChangeRealm();
	end,
}

GlueDialogTypes["DISCONNECTED"] = {
	text = DISCONNECTED,
	button1 = OKAY,
	button2 = nil,
	OnShow = function()
		RealmList:Hide();
		VirtualKeypadFrame:Hide();
		SecurityMatrixLoginFrame:Hide();
		StatusDialogClick();
	end,
	OnAccept = function()
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["PARENTAL_CONTROL"] = {
	text = AUTH_PARENTAL_CONTROL,
	button1 = MANAGE_ACCOUNT,
	button2 = OKAY,
	OnShow = function()
		RealmList:Hide();
		VirtualKeypadFrame:Hide();
		SecurityMatrixLoginFrame:Hide();
		StatusDialogClick();
	end,
	OnAccept = function()
		LaunchURL(AUTH_PARENTAL_CONTROL_URL);
	end,
	OnCancel = function()
		StatusDialogClick();
	end,
}

GlueDialogTypes["INVALID_NAME"] = {
	text = CHAR_CREATE_INVALID_NAME,
	button1 = OKAY,
	button2 = nil,
	OnAccept = function()
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["CANCEL"] = {
	text = "",
	button1 = CANCEL,
	button2 = nil,
	OnAccept = function()
		StatusDialogClick();
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["OKAY"] = {
	text = "",
	button1 = OKAY,
	button2 = nil,
	OnShow = function()
		if ( VirtualKeypadFrame:IsShown() ) then
			VirtualKeypadFrame:Hide();
			CancelLogin();
		end
	end,
	OnAccept = function()
		StatusDialogClick();
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["OKAY_WITH_URL"] = {
	text = "",
	button1 = HELP,
	button2 = OKAY,
	OnAccept = function()
		LaunchURL(getglobal(GlueDialog.data));
	end,
	OnCancel = function()
		StatusDialogClick();
	end,
}

GlueDialogTypes["CONNECTION_HELP"] = {
	text = "",
	button1 = HELP,
	button2 = OKAY,
	OnShow = function()
		VirtualKeypadFrame:Hide();
		StatusDialogClick();
	end,
	OnAccept = function()
		AccountLoginUI:Hide();
		ConnectionHelpFrame:Show();
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["CINEMATICS"] = {
	text = CINEMATICS,
	button1 = WORLD_OF_WARCRAFT,
	button2 = BURNING_CRUSADE,
	displayVertical = true,
	escapeHides = true,

	OnAccept = function()
		MovieFrame.version = 1;
--		PlaySound("gsTitleIntroMovie");
		SetGlueScreen("movie");
	end,
	OnCancel = function()
		MovieFrame.version = 2;
--		PlaySound("gsTitleIntroMovie");
		SetGlueScreen("movie");
	end,
}

GlueDialogTypes["CLIENT_ACCOUNT_MISMATCH"] = {
	text = CLIENT_ACCOUNT_MISMATCH,
	button1 = RETURN_TO_LOGIN,
	button2 = EXIT_GAME,
	html = 1,
	OnAccept = function()
		SetGlueScreen("login");
	end,
	OnCancel = function()
		PlaySound("gsTitleQuit");
		QuitGame();
	end,
}


GlueDialogTypes["SCANDLL_DOWNLOAD"] = {
	text = "",
	button1 = QUIT,
	button2 = nil,
	OnAccept = function()
		AccountLogin_Exit();
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["SCANDLL_ERROR"] = {
	text = "",
	button1 = SCANDLL_BUTTON_CONTINUEANYWAY,
	button2 = QUIT,
	OnAccept = function()
		GlueDialog:Hide();
		ScanDLLContinueAnyway();
		AccountLoginUI:Show();
	end,
	OnCancel = function()
		-- Opposite semantics
		AccountLogin_Exit();
	end,
}

GlueDialogTypes["SCANDLL_HACKFOUND"] = {
	text = "",
	button1 = SCANDLL_BUTTON_CONTINUEANYWAY,
	button2 = QUIT,
	html = 1,
	showAlert = 1,
	OnAccept = function()
		local formatString = getglobal("SCANDLL_MESSAGE_"..AccountLogin.hackType.."FOUND_CONFIRM");
		GlueDialog_Show("SCANDLL_HACKFOUND_CONFIRM", format(formatString, AccountLogin.hackName, AccountLogin.hackURL));
	end,
	OnCancel = function()
		AccountLogin_Exit();
	end,
}

GlueDialogTypes["SCANDLL_HACKFOUND_NOCONTINUE"] = {
	text = "",
	button1 = QUIT,
	button2 = nil,
	html = 1,
	showAlert = 1,
	OnAccept = function()
		AccountLogin_Exit();
	end,
	OnCancel = function()
		AccountLogin_Exit();
	end,
}

GlueDialogTypes["SCANDLL_HACKFOUND_CONFIRM"] = {
	text = "",
	button1 = SCANDLL_BUTTON_CONTINUEANYWAY,
	button2 = QUIT,
	html = 1,
	showAlert = 1,
	OnAccept = function()
		GlueDialog:Hide();
		ScanDLLContinueAnyway();
		AccountLoginUI:Show();
	end,
	OnCancel = function()
		AccountLogin_Exit();
	end,
}

GlueDialogTypes["SERVER_SPLIT"] = {
	text = SERVER_SPLIT,
	button1 = SERVER_SPLIT_SERVER_ONE,
	button2 = SERVER_SPLIT_SERVER_TWO,
	button3 = SERVER_SPLIT_NOT_NOW,
	escapeHides = true;

	OnAccept = function()
		SetStateRequestInfo( 1 );
	end,
	OnCancel = function()
		SetStateRequestInfo( 2 );
	end,
	OnAlt = function()
		SetStateRequestInfo( 0 );
	end,
}

GlueDialogTypes["SERVER_SPLIT_WITH_CHOICE"] = {
	text = SERVER_SPLIT,
	button1 = SERVER_SPLIT_SERVER_ONE,
	button2 = SERVER_SPLIT_SERVER_TWO,
	button3 = SERVER_SPLIT_DONT_CHANGE,
	escapeHides = true;

	OnAccept = function()
		SetStateRequestInfo( 1 );
	end,
	OnCancel = function()
		SetStateRequestInfo( 2 );
	end,
	OnAlt = function()
		SetStateRequestInfo( 0 );
	end,
}

GlueDialogTypes["ACCOUNT_MSG"] = {
	text = "",
	button1 = OKAY,
	button2 = nil,
	OnShow = function()
		VirtualKeypadFrame:Hide();
		StatusDialogClick();
	end,
	OnAccept = function()
		if ( ACCOUNT_MSG_NUM_AVAILABLE > 0 ) then
			ACCOUNT_MSG_NUM_AVAILABLE = ACCOUNT_MSG_NUM_AVAILABLE - 1;
			ACCOUNT_MSG_CURRENT_INDEX = AccountMsg_GetIndexHighestPriorityUnreadMsg();
			ACCOUNT_MSG_BODY_LOADED = false;
			AccountMsg_LoadBody( ACCOUNT_MSG_CURRENT_INDEX );
		end
		StatusDialogClick();
	end,
}


function GlueDialog_Show(which, text, data)
	local dialogInfo = GlueDialogTypes[which];
	-- Pick a free dialog to use
	if ( GlueDialog:IsShown() ) then
		if ( GlueDialogTypes[GlueDialog.which].OnHide ) then
			GlueDialogTypes[GlueDialog.which].OnHide();	
		end
	end

	GlueDialog.data = data;
	local glueText;
	if ( dialogInfo.html ) then
		glueText = GlueDialogHTML;
		GlueDialogHTML:Show();
		GlueDialogText:Hide();
	else
		glueText = GlueDialogText;
		GlueDialogHTML:Hide();
		GlueDialogText:Show();
	end
	
	-- Set the text of the dialog
	if ( text ) then
		glueText:SetText(text);
	else
		glueText:SetText(dialogInfo.text);
	end

	-- Set the buttons of the dialog
	if ( dialogInfo.button3 ) then
		GlueDialogButton1:ClearAllPoints();
		GlueDialogButton2:ClearAllPoints();
		GlueDialogButton3:ClearAllPoints();
	
		if ( dialogInfo.displayVertical ) then
			GlueDialogButton3:SetPoint("BOTTOM", "GlueDialogBackground", "BOTTOM", 0, 16);
			GlueDialogButton2:SetPoint("BOTTOM", "GlueDialogButton3", "TOP", 0, 0);
			GlueDialogButton1:SetPoint("BOTTOM", "GlueDialogButton2", "TOP", 0, 0);
		else
			GlueDialogButton1:SetPoint("BOTTOMLEFT", "GlueDialogBackground", "BOTTOMLEFT", 60, 16);
			GlueDialogButton2:SetPoint("LEFT", "GlueDialogButton1", "RIGHT", -8, 0);
			GlueDialogButton3:SetPoint("LEFT", "GlueDialogButton2", "RIGHT", -8, 0);
		end

		GlueDialogButton2:SetText(dialogInfo.button2);
		GlueDialogButton2:Show();
		GlueDialogButton3:SetText(dialogInfo.button3);
		GlueDialogButton3:Show();
	elseif ( dialogInfo.button2 ) then
		GlueDialogButton1:ClearAllPoints();
		GlueDialogButton2:ClearAllPoints();
	
		if ( dialogInfo.displayVertical ) then
			GlueDialogButton2:SetPoint("BOTTOM", "GlueDialogBackground", "BOTTOM", 0, 16);
			GlueDialogButton1:SetPoint("BOTTOM", "GlueDialogButton2", "TOP", 0, 0);
		else
			GlueDialogButton1:SetPoint("BOTTOMRIGHT", "GlueDialogBackground", "BOTTOM", -6, 16);
			GlueDialogButton2:SetPoint("LEFT", "GlueDialogButton1", "RIGHT", 13, 0);
		end

		GlueDialogButton2:SetText(dialogInfo.button2);
		GlueDialogButton2:Show();
		GlueDialogButton3:Hide();
	else
		GlueDialogButton1:ClearAllPoints();
		GlueDialogButton1:SetPoint("BOTTOM", "GlueDialogBackground", "BOTTOM", 0, 16);
		GlueDialogButton2:Hide();
		GlueDialogButton3:Hide();
	end

	GlueDialogButton1:SetText(dialogInfo.button1);

	-- Set the miscellaneous variables for the dialog
	GlueDialog.which = which;
	GlueDialog.data = data;

	-- Show or hide the alert icon
	if ( dialogInfo.showAlert ) then
		GlueDialogBackground:SetWidth(GlueDialogBackground.alertWidth);
		GlueDialogAlertIcon:Show();
	else
		GlueDialogBackground:SetWidth(GlueDialogBackground.origWidth);
		GlueDialogAlertIcon:Hide();
	end
	GlueDialogText:SetWidth(GlueDialogText.origWidth);

	-- Editbox setup
	if ( dialogInfo.hasEditBox ) then
		GlueDialogEditBox:Show();
		if ( dialogInfo.maxLetters ) then
			GlueDialogEditBox:SetMaxLetters(dialogInfo.maxLetters);
		end
		if ( dialogInfo.maxBytes ) then
			GlueDialogEditBox:SetMaxBytes(dialogInfo.maxBytes);
		end
	else
		GlueDialogEditBox:Hide();
	end

	-- size the width first
	if( dialogInfo.displayVertical ) then
		GlueDialogBackground:SetWidth(16 + GlueDialogButton1:GetWidth() + 16);
	elseif ( dialogInfo.button3 ) then
		local displayWidth = 45 + GlueDialogButton1:GetWidth() + 8 + GlueDialogButton2:GetWidth() + 8 + GlueDialogButton3:GetWidth() + 45;
		GlueDialogBackground:SetWidth(displayWidth);
		GlueDialogText:SetWidth(displayWidth - 40);
	end

	-- Get the height of the string
	local textHeight, _;
	if ( dialogInfo.html ) then
		_,_,_,textHeight = GlueDialogHTML:GetBoundsRect();
	else
		textHeight = GlueDialogText:GetHeight();
	end

	-- now size the dialog box height
	if ( dialogInfo.hasEditBox ) then
		GlueDialogBackground:SetHeight(16 + textHeight + 8 + GlueDialogEditBox:GetHeight() + 8 + GlueDialogButton1:GetHeight() + 16);
	elseif( dialogInfo.displayVertical ) then
		local displayHeight = 16 + textHeight + 8 + GlueDialogButton1:GetHeight() + 16;
		if ( dialogInfo.button2 ) then
			displayHeight = displayHeight + 8 + GlueDialogButton2:GetHeight();
		end
		if ( dialogInfo.button3 ) then
			displayHeight = displayHeight + 8 + GlueDialogButton3:GetHeight();
		end
		GlueDialogBackground:SetHeight(displayHeight);
	else
		GlueDialogBackground:SetHeight(16 + textHeight + 8 + GlueDialogButton1:GetHeight() + 16);
	end

	GlueDialog:Show();
end

function GlueDialog_OnLoad()
	this:RegisterEvent("OPEN_STATUS_DIALOG");
	this:RegisterEvent("UPDATE_STATUS_DIALOG");
	this:RegisterEvent("CLOSE_STATUS_DIALOG");
	GlueDialogText.origWidth = GlueDialogText:GetWidth();
	GlueDialogBackground.origWidth = GlueDialogBackground:GetWidth();
	GlueDialogBackground.alertWidth = 600;
end

function GlueDialog_OnShow()
	local OnShow = GlueDialogTypes[this.which].OnShow;
	if ( OnShow ) then
		OnShow();
	end
end

function GlueDialog_OnEvent()
	if ( event == "OPEN_STATUS_DIALOG" ) then
		GlueDialog_Show(arg1, arg2, arg3);
	elseif ( event == "UPDATE_STATUS_DIALOG" and arg1 and (strlen(arg1) > 0) ) then
		GlueDialogText:SetText(arg1);
		local buttonText = nil;
		if ( arg2 ) then
			buttonText = arg2;
		elseif ( GlueDialogTypes[GlueDialog.which] ) then
			buttonText = GlueDialogTypes[GlueDialog.which].button1;
		end
		if ( buttonText ) then
			GlueDialogButton1:SetText(buttonText);
		end
		GlueDialogBackground:SetHeight(32 + GlueDialogText:GetHeight() + 8 + GlueDialogButton1:GetHeight() + 16);
	elseif ( event == "CLOSE_STATUS_DIALOG" ) then
		GlueDialog:Hide();
	end
end

function GlueDialog_OnHide()
--	PlaySound("igMainMenuClose");
end

function GlueDialog_OnClick(index)
	GlueDialog:Hide();
	if ( index == 1 ) then
		local OnAccept = GlueDialogTypes[GlueDialog.which].OnAccept;
		if ( OnAccept ) then
			OnAccept();
		end
	elseif ( index == 2 ) then
		local OnCancel = GlueDialogTypes[GlueDialog.which].OnCancel;
		if ( OnCancel ) then
			OnCancel();
		end
	elseif ( index == 3 ) then
		local OnAlt = GlueDialogTypes[GlueDialog.which].OnAlt;
		if ( OnAlt ) then
			OnAlt();
		end
	end
	PlaySound("gsTitleOptionOK");
end

function GlueDialog_OnKeyDown()
	if ( arg1 == "PRINTSCREEN" ) then
		Screenshot();
		return;
	end

	local info = GlueDialogTypes[GlueDialog.which];
	if ( not info or info.ignoreKeys ) then
		return;
	end

	if ( info and info.escapeHides ) then
		GlueDialog:Hide();
	elseif ( arg1 == "ESCAPE" ) then
		if ( GlueDialogButton2:IsShown() ) then
			GlueDialogButton2:Click();
		else
			GlueDialogButton1:Click();
		end
	elseif (arg1 == "ENTER" ) then
		GlueDialogButton1:Click();
	end
end
