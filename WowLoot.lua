WowLoot = {}

local function writeToFrame(msg)
   if( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage(msg);
   end
end

local debug = writeToFrame

local function showHelp() 
	writeToFrame("Usage:")
	writeToFrame("/wowloot [type] [itemlink]")
	writeToFrame("where [type] is one of \"primary\", \"secondary\", or \"tertiary\"")
end

SLASH_WOWLOOT1 = "/wowloot"
SlashCmdList["WOWLOOT"] = function(msg)
	local cmd, itemLink = msg:match("^(%a+) (.+)$")

	if cmd == "primary" then
		writeToFrame(WowLoot:getPrimaryFor(itemLink))
	elseif cmd == "secondary" then
		writeToFrame(WowLoot:getSecondaryFor(itemLink))
	elseif cmd == "tertiary" then
		writeToFrame(WowLoot:getTertiaryFor(itemLink))
	else
		showHelp()
	end
end

local function getItemId(itemLink)
	return itemLink:match("item:(%d+):")
end

local function getSpecsFor(itemLink, list)
	itemId = getItemId(itemLink)
	item = WowLootItems[tonumber(itemId)]
	if item then
		return item[list]
	else
		return "Unknown Item"
	end
end

--[[
  Get the list of Primary specs for this item
]]--
function WowLoot:getPrimaryFor(itemLink)
	return getSpecsFor(itemLink, "Primary")
end


--[[
  Get the list of Secondary specs for this item
]]--
function WowLoot:getSecondaryFor(itemLink)
	return getSpecsFor(itemLink, "Secondary")
end

--[[
  Get the list of Tertiary specs for this item
]]--
function WowLoot:getTertiaryFor(itemLink)
	return getSpecsFor(itemLink, "Tertiary")
end

--[[
  Get all three of the lists at once
]]--
function WowLoot:getAllFor(itemLink)
	return WowLoot:getPrimaryFor(itemLink), 
		WowLoot:getSecondaryFor(itemLink),
		WowLoot:getTertiaryFor(itemLink)
end
