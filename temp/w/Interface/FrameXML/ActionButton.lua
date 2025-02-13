CURRENT_ACTIONBAR_PAGE = 1;
NUM_ACTIONBAR_PAGES = 6;
NUM_ACTIONBAR_BUTTONS = 12;
ATTACK_BUTTON_FLASH_TIME = 0.4;

BOTTOMLEFT_ACTIONBAR_PAGE = 6;
BOTTOMRIGHT_ACTIONBAR_PAGE = 5;
LEFT_ACTIONBAR_PAGE = 4;
RIGHT_ACTIONBAR_PAGE = 3;
RANGE_INDICATOR = "●";

-- Table of actionbar pages and whether they're viewable or not
VIEWABLE_ACTION_BAR_PAGES = {1, 1, 1, 1, 1, 1};

function ActionButtonDown(id)
	local button;
	if ( BonusActionBarFrame:IsShown() ) then
		button = getglobal("BonusActionButton"..id);
	else
		button = getglobal("ActionButton"..id);
	end
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function ActionButtonUp(id)
	local button;
	if ( BonusActionBarFrame:IsShown() ) then
		button = getglobal("BonusActionButton"..id);
	else
		button = getglobal("ActionButton"..id);
	end
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		SecureActionButton_OnClick(button, "LeftButton");
		ActionButton_UpdateState(button);
	end
end

function ActionBar_PageUp()
	local nextPage;
	for i=GetActionBarPage() + 1, NUM_ACTIONBAR_PAGES do
		if ( VIEWABLE_ACTION_BAR_PAGES[i] ) then
			nextPage = i;
			break;
		end
	end

	if ( not nextPage ) then
		nextPage = 1;
	end
	ChangeActionBarPage(nextPage);
end

function ActionBar_PageDown()
	local prevPage;
	for i=GetActionBarPage() - 1, 1, -1 do
		if ( VIEWABLE_ACTION_BAR_PAGES[i] ) then
			prevPage = i;
			break;
		end
	end
	
	if ( not prevPage ) then
		for i=NUM_ACTIONBAR_PAGES, 1, -1 do
			if ( VIEWABLE_ACTION_BAR_PAGES[i] ) then
				prevPage = i;
				break;
			end
		end
	end
	ChangeActionBarPage(prevPage);
end

function ActionButton_OnLoad()
	this.showgrid = 0;
	this.flashing = 0;
	this.flashtime = 0;
	ActionButton_Update();
	this:SetAttribute("type", "action");
	this:SetAttribute("checkselfcast", true);
	this:SetAttribute("useparent-unit", true);
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("AnyUp");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	this:RegisterEvent("ACTIONBAR_SHOWGRID");
	this:RegisterEvent("ACTIONBAR_HIDEGRID");
	this:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("UPDATE_BINDINGS");

	ActionButton_UpdateHotkeys(this.buttonType);
end

function ActionButton_UpdateHotkeys(actionButtonType)
    if ( not actionButtonType ) then
        actionButtonType = "ACTIONBUTTON";
    end

    local hotkey = getglobal(this:GetName().."HotKey");
    local action = ActionButton_GetPagedID(this);
    local key = GetBindingKey(actionButtonType..this:GetID()) or
                GetBindingKey("CLICK "..this:GetName()..":LeftButton");

    if ( GetBindingText(key, "KEY_", 1) == "" ) then
        if ( not HasAction(action) ) then
            hotkey:SetText("");
        elseif ( ActionHasRange(action) ) then
            if ( IsActionInRange(action) ) then
                hotkey:SetText(RANGE_INDICATOR);
                hotkey:SetTextHeight(8);
                hotkey:SetPoint("TOPRIGHT", this:GetName(), "TOPRIGHT", -3, 5);
            else
                hotkey:SetText("");
            end
        end
    else
        hotkey:SetText(GetBindingText(key, "KEY_", 1));
    end
end

function ActionButton_Update()
	-- Special case code for bonus bar buttons
	-- Prevents the button from updating if the bonusbar is still in an animation transition
	if ( this.isBonus and this.inTransition ) then
		ActionButton_UpdateUsable();
		ActionButton_UpdateCooldown();
		return;
	end

	local action = ActionButton_GetPagedID(this);
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(action);
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		this.rangeTimer = -1;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
		-- Save texture if the button is a bonus button, will be needed later
		if ( this.isBonus ) then
			this.texture = texture;
		end
	else
		icon:Hide();
		buttonCooldown:Hide();
		this.rangeTimer = nil;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
		getglobal(this:GetName().."HotKey"):SetVertexColor(0.6, 0.6, 0.6);
	end
	ActionButton_UpdateCount();
	if ( HasAction(action) ) then
		this:RegisterEvent("ACTIONBAR_UPDATE_STATE");
		this:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
		this:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
		this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
		this:RegisterEvent("PLAYER_AURAS_CHANGED");
		this:RegisterEvent("PLAYER_TARGET_CHANGED");
		this:RegisterEvent("UNIT_INVENTORY_CHANGED");
		this:RegisterEvent("CRAFT_SHOW");
		this:RegisterEvent("CRAFT_CLOSE");
		this:RegisterEvent("TRADE_SKILL_SHOW");
		this:RegisterEvent("TRADE_SKILL_CLOSE");
		this:RegisterEvent("PLAYER_ENTER_COMBAT");
		this:RegisterEvent("PLAYER_LEAVE_COMBAT");
		this:RegisterEvent("START_AUTOREPEAT_SPELL");
		this:RegisterEvent("STOP_AUTOREPEAT_SPELL");

		if ( not this:GetAttribute("statehidden") ) then
			this:Show();
		end
		ActionButton_UpdateState();
		ActionButton_UpdateUsable();
		ActionButton_UpdateCooldown();
		ActionButton_UpdateFlash();
	else
		this:UnregisterEvent("ACTIONBAR_UPDATE_STATE");
		this:UnregisterEvent("ACTIONBAR_UPDATE_USABLE");
		this:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
		this:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
		this:UnregisterEvent("PLAYER_AURAS_CHANGED");
		this:UnregisterEvent("PLAYER_TARGET_CHANGED");
		this:UnregisterEvent("UNIT_INVENTORY_CHANGED");
		this:UnregisterEvent("CRAFT_SHOW");
		this:UnregisterEvent("CRAFT_CLOSE");
		this:UnregisterEvent("TRADE_SKILL_SHOW");
		this:UnregisterEvent("TRADE_SKILL_CLOSE");
		this:UnregisterEvent("PLAYER_ENTER_COMBAT");
		this:UnregisterEvent("PLAYER_LEAVE_COMBAT");
		this:UnregisterEvent("START_AUTOREPEAT_SPELL");
		this:UnregisterEvent("STOP_AUTOREPEAT_SPELL");

		if ( this.showgrid == 0 ) then
			this:Hide();
		else
			buttonCooldown:Hide();
		end
	end

	-- Add a green border if button is an equipped item
	local border = getglobal(this:GetName().."Border");
	if ( IsEquippedAction(action) ) then
		border:SetVertexColor(0, 1.0, 0, 0.35);
		border:Show();
	else
		border:Hide();
	end

	if ( GameTooltip:IsOwned(this) ) then
		ActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	if ( not IsConsumableAction(action) and not IsStackableAction(action) ) then
		macroName:SetText(GetActionText(action));
	else
		macroName:SetText("");
	end

	-- Save the action so we don't update in OnUpdate()
	this.action = action;
end

function ActionButton_ShowGrid(button)
	if ( not button ) then
		button = this;
	end
	button.showgrid = button.showgrid+1;
	getglobal(button:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0, 0.5);

	if ( not button:GetAttribute("statehidden") ) then
		button:Show();
	end
end

function ActionButton_HideGrid(button)	
	if ( not button ) then
		button = this;
	end
	button.showgrid = button.showgrid-1;
	if ( button.showgrid == 0 and not HasAction(ActionButton_GetPagedID(button)) ) then
		button:Hide();
	end
end

function ActionButton_UpdateState(button)
	if ( not button ) then
		button = this;
	end
	local actionID = ActionButton_GetPagedID(button);
	if ( IsCurrentAction(actionID) or IsAutoRepeatAction(actionID) ) then
		button:SetChecked(1);
	else
		button:SetChecked(0);
	end
end

function ActionButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));
	if ( isUsable ) then
		icon:SetVertexColor(1.0, 1.0, 1.0);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
	elseif ( notEnoughMana ) then
		icon:SetVertexColor(0.5, 0.5, 1.0);
		normalTexture:SetVertexColor(0.5, 0.5, 1.0);
	else
		icon:SetVertexColor(0.4, 0.4, 0.4);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function ActionButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local action = ActionButton_GetPagedID(this);
	if ( IsConsumableAction(action) or IsStackableAction(action) ) then
		text:SetText(GetActionCount(action));
	else
		text:SetText("");
	end
end

function ActionButton_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(ActionButton_GetPagedID(this));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function ActionButton_OnEvent(event)
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == 0 or arg1 == ActionButton_GetPagedID(this) ) then
			ActionButton_Update();
		end
		return;
	end
	if ( event == "PLAYER_ENTERING_WORLD" or event == "ACTIONBAR_PAGE_CHANGED" ) then
		ActionButton_Update();
		return;
	end
	if ( event == "UPDATE_BONUS_ACTIONBAR" ) then
		if ( this.isBonus ) then
			ActionButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		ActionButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		ActionButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		ActionButton_UpdateHotkeys(this.buttonType);
		return;
	end

	-- All event handlers below this line are only set when the button has an action

	if ( event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_AURAS_CHANGED" ) then
		ActionButton_UpdateUsable();
		ActionButton_UpdateHotkeys(this.buttonType);
	elseif ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			ActionButton_Update();
		end
	elseif ( event == "ACTIONBAR_UPDATE_STATE" ) then
		ActionButton_UpdateState();
	elseif ( event == "ACTIONBAR_UPDATE_USABLE" or event == "UPDATE_INVENTORY_ALERTS" or event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		ActionButton_UpdateUsable();
		ActionButton_UpdateCooldown();
	elseif ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		ActionButton_UpdateState();
	elseif ( event == "PLAYER_ENTER_COMBAT" ) then
		if ( IsAttackAction(ActionButton_GetPagedID(this)) ) then
			ActionButton_StartFlash();
		end
	elseif ( event == "PLAYER_LEAVE_COMBAT" ) then
		if ( IsAttackAction(ActionButton_GetPagedID(this)) ) then
			ActionButton_StopFlash();
		end
	elseif ( event == "START_AUTOREPEAT_SPELL" ) then
		if ( IsAutoRepeatAction(ActionButton_GetPagedID(this)) ) then
			ActionButton_StartFlash();
		end
	elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then
		if ( ActionButton_IsFlashing() and not IsAttackAction(ActionButton_GetPagedID(this)) ) then
			ActionButton_StopFlash();
		end
	end
end

function ActionButton_SetTooltip()
	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		if ( this:GetParent() == MultiBarBottomRight or this:GetParent() == MultiBarRight or this:GetParent() == MultiBarLeft ) then
			GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		else
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		end
		
	end
	
	if ( GameTooltip:SetAction(ActionButton_GetPagedID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function ActionButton_OnUpdate(elapsed)

	local hotkey = getglobal(this:GetName().."HotKey");
	local action = ActionButton_GetPagedID(this);

	if ( this.action ~= action ) then
		ActionButton_Update();
	end

	if ( hotkey:GetText() == RANGE_INDICATOR ) then
		if ( IsActionInRange(action) == 1 ) then
			hotkey:Hide();
		else
			hotkey:Show();
		end
	end

	if ( ActionButton_IsFlashing() ) then
		this.flashtime = this.flashtime - elapsed;
		if ( this.flashtime <= 0 ) then
			local overtime = -this.flashtime;
			if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
				overtime = 0;
			end
			this.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;

			local flashTexture = getglobal(this:GetName().."Flash");
			if ( flashTexture:IsShown() ) then
				flashTexture:Hide();
			else
				flashTexture:Show();
			end
		end
	end
	
	-- Handle range indicator
	if ( this.rangeTimer ) then
		this.rangeTimer = this.rangeTimer - elapsed;

		if ( this.rangeTimer <= 0 ) then
			local count = getglobal(this:GetName().."HotKey");
			if ( IsActionInRange(action) == 0 ) then
				count:SetVertexColor(1.0, 0.1, 0.1);
			else
				count:SetVertexColor(0.6, 0.6, 0.6);
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		end
	end

	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		ActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function ActionButton_GetPagedID(button)
    if ( button:GetID() > 0 ) then
        if ( button.isBonus and GetActionBarPage() == 1 ) then
            local offset = GetBonusBarOffset();
            if ( offset == 0 and BonusActionBarFrame and BonusActionBarFrame.lastBonusBar ) then
                offset = BonusActionBarFrame.lastBonusBar;
            end
            return (button:GetID() + ((NUM_ACTIONBAR_PAGES + offset - 1) * NUM_ACTIONBAR_BUTTONS));
        end
        
        local parentName = button:GetParent():GetName();
        if ( parentName == "MultiBarBottomLeft" ) then
            return (button:GetID() + ((BOTTOMLEFT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
        elseif ( parentName == "MultiBarBottomRight" ) then
            return (button:GetID() + ((BOTTOMRIGHT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
        elseif ( parentName == "MultiBarLeft" ) then
            return (button:GetID() + ((LEFT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
        elseif ( parentName == "MultiBarRight" ) then
            return (button:GetID() + ((RIGHT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
        else
            return (button:GetID() + ((GetActionBarPage() - 1) * NUM_ACTIONBAR_BUTTONS))
        end
    else
        return SecureButton_GetModifiedAttribute(button, "action", SecureStateChild_GetEffectiveButton(button)) or 1;
    end
end

function ActionButton_UpdateFlash()
	local action = ActionButton_GetPagedID(this);
	if ( (IsAttackAction(action) and IsCurrentAction(action)) or IsAutoRepeatAction(action) ) then
		ActionButton_StartFlash();
	else
		ActionButton_StopFlash();
	end
end

function ActionButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	ActionButton_UpdateState();
end

function ActionButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	ActionButton_UpdateState();
end

function ActionButton_IsFlashing()
	if ( this.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end
