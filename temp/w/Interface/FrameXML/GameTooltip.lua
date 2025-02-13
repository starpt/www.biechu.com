-- The default tooltip border color
--TOOLTIP_DEFAULT_COLOR = { r = 0.5, g = 0.5, b = 0.5 };
TOOLTIP_DEFAULT_COLOR = { r = 1, g = 1, b = 1 };
TOOLTIP_DEFAULT_BACKGROUND_COLOR = { r = 0.09, g = 0.09, b = 0.19 };

DEFAULT_TOOLTIP_POSITION = -13;

function GameTooltip_UnitColor(unit)
	local r, g, b;
	if ( UnitPlayerControlled(unit) ) then
		if ( UnitCanAttack(unit, "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", unit) ) then
				--[[
				r = 1.0;
				g = 0.5;
				b = 0.5;
				]]
				--[[
				r = 0.0;
				g = 0.0;
				b = 1.0;
				]]
				r = 1.0;
				g = 1.0;
				b = 1.0;
			else
				r = FACTION_BAR_COLORS[2].r;
				g = FACTION_BAR_COLORS[2].g;
				b = FACTION_BAR_COLORS[2].b;
			end
		elseif ( UnitCanAttack("player", unit) ) then
			-- Players we can attack but which are not hostile are yellow
			r = FACTION_BAR_COLORS[4].r;
			g = FACTION_BAR_COLORS[4].g;
			b = FACTION_BAR_COLORS[4].b;
		elseif ( UnitIsPVP(unit) ) then
			-- Players we can assist but are PvP flagged are green
			r = FACTION_BAR_COLORS[6].r;
			g = FACTION_BAR_COLORS[6].g;
			b = FACTION_BAR_COLORS[6].b;
		else
			-- All other players are blue (the usual state on the "blue" server)
			--[[
			r = 0.0;
			g = 0.0;
			b = 1.0;
			]]
			r = 1.0;
			g = 1.0;
			b = 1.0;
		end
	else
		local reaction = UnitReaction(unit, "player");
		if ( reaction ) then
			r = FACTION_BAR_COLORS[reaction].r;
			g = FACTION_BAR_COLORS[reaction].g;
			b = FACTION_BAR_COLORS[reaction].b;
		else
			--[[
			r = 0.0;
			g = 0.0;
			b = 1.0;
			]]
			r = 1.0;
			g = 1.0;
			b = 1.0;
		end
	end
	return r, g, b;
end

function GameTooltip_SetDefaultAnchor(tooltip, parent)		
	tooltip:SetOwner(parent, "ANCHOR_NONE");
	tooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y);
	tooltip.default = 1;
end

function GameTooltip_OnLoad()
	this:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	this:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
end

function SetTooltipMoney(frame, money)
	frame:AddLine(" ", 1.0, 1.0, 1.0);
	local numLines = frame:NumLines();
	local moneyFrame = getglobal(frame:GetName().."MoneyFrame");
	moneyFrame:SetPoint("LEFT", frame:GetName().."TextLeft"..numLines, "LEFT", 4, 0);
	moneyFrame:Show();
	MoneyFrame_Update(moneyFrame:GetName(), money);
	frame:SetMinimumWidth(moneyFrame:GetWidth());
end

function GameTooltip_ClearMoney()
	local moneyFrame = getglobal(this:GetName().."MoneyFrame");
	if(moneyFrame) then
		moneyFrame:Hide();
	end
end

function GameTooltip_OnHide()
	this:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	this:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
	this.default = nil;
end

function GameTooltip_AddNewbieTip(normalText, r, g, b, newbieText, noNormalText)
	if ( SHOW_NEWBIE_TIPS == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
		if ( normalText ) then
			GameTooltip:SetText(normalText, r, g, b);
			GameTooltip:AddLine(newbieText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
		else
			GameTooltip:SetText(newbieText, r, g, b, 1, 1);
		end
		GameTooltip:Show();
	else
		if ( not noNormalText ) then
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
			GameTooltip:SetText(normalText, r, g, b);
		end
	end
end

function GameTooltip_ShowCompareItem()
	local item, link = GameTooltip:GetItem();
	if ( not link ) then
		return;
	end

	local item1 = nil;
	local item2 = nil;
	local side = "left";
	if ( ShoppingTooltip1:SetHyperlinkCompareItem(link, 1) ) then
		item1 = true;
	end
	if ( ShoppingTooltip2:SetHyperlinkCompareItem(link, 2) ) then
		item2 = true;
	end

	-- find correct side
	local rightDist = GetScreenWidth() - GameTooltip:GetRight();
	if (rightDist < GameTooltip:GetLeft()) then
		side = "left";
	else
		side = "right";
	end

	-- see if we should slide the tooltip
	if ( GameTooltip:GetAnchorType() ) then
		local totalWidth = 0;
		if ( item1  ) then
			totalWidth = totalWidth + ShoppingTooltip1:GetWidth();
		end
		if ( item2  ) then
			totalWidth = totalWidth + ShoppingTooltip2:GetWidth();
		end

		if ( (side == "left") and (totalWidth > GameTooltip:GetLeft()) ) then
			GameTooltip:SetAnchorType(GameTooltip:GetAnchorType(), (totalWidth - GameTooltip:GetLeft()), 0);
		elseif ( (side == "right") and (GameTooltip:GetRight() + totalWidth) >  GetScreenWidth() ) then
			GameTooltip:SetAnchorType(GameTooltip:GetAnchorType(), -((GameTooltip:GetRight() + totalWidth) - GetScreenWidth()), 0);
		end
	end

	-- anchor the compare tooltips
	if ( item1 ) then
		ShoppingTooltip1:SetOwner(GameTooltip, "ANCHOR_NONE");
		ShoppingTooltip1:ClearAllPoints();
		if ( side and side == "left" ) then
			ShoppingTooltip1:SetPoint("TOPRIGHT", "GameTooltip", "TOPLEFT", 0, -10);
		else
			ShoppingTooltip1:SetPoint("TOPLEFT", "GameTooltip", "TOPRIGHT", 0, -10);
		end
		ShoppingTooltip1:SetHyperlinkCompareItem(link, 1);
		ShoppingTooltip1:Show();

		if ( item2 ) then
			ShoppingTooltip2:SetOwner(ShoppingTooltip1, "ANCHOR_NONE");
			ShoppingTooltip2:ClearAllPoints();
			if ( side and side == "left" ) then
				ShoppingTooltip2:SetPoint("TOPRIGHT", "ShoppingTooltip1", "TOPLEFT", 0, 0);
			else
				ShoppingTooltip2:SetPoint("TOPLEFT", "ShoppingTooltip1", "TOPRIGHT", 0, 0);
			end
			ShoppingTooltip2:SetHyperlinkCompareItem(link, 2);
			ShoppingTooltip2:Show();
		end
	end
end
