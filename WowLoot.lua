--[[
  Getting the pure itemId from an item:

  local _,link=GetItemInfo(msg)
  if link then
    itemId = link:match("item:(%d+):"))
  end

]]--

