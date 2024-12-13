ModsOnly = {}
ModsOnly.debug = false
ModsOnly.protectedCagtegories = {
    ['PLACEABLEMISC'] = true,
    ['DECORATION'] = true,
    ['TREES'] = true,
}

--- removeEverythingFromTheStore
function ModsOnly:removeEverythingFromTheStore()
    if ModsOnly.debug then print("!! ModsOnly :: removeEverythingFromTheStore") end

    for _, storeItem in pairs(g_storeManager:getItems()) do
        if storeItem.rawXMLFilename:sub(0,5) == "$data" and not ModsOnly:isProtectedCategory(storeItem) then
            if ModsOnly.debug then printf("!! ModsOnly :: hiding from store - %s | %s | %s", storeItem.categoryName, storeItem.name, storeItem.xmlFilename) end

            -- mark the item as not shown in store
            storeItem.showInStore = false

            -- by removing the brush we can also remove item from the construction menu.
            if storeItem.brush then
                storeItem.brush = nil
            end
        else
            if ModsOnly.debug then printf("!! ModsOnly :: skipping - %s | %s | %s", storeItem.categoryName, storeItem.name, storeItem.xmlFilename) end
        end
    end
end

function ModsOnly:isProtectedCategory(storeItem)
    local catName = storeItem.categoryName

    if ModsOnly.protectedCagtegories[catName] then
        if storeItem.brush and storeItem.brush.tab then
            if storeItem.brush.tab.name == 'TOOLS' then return false end
            if storeItem.brush.tab.name == 'GREENHOUSES' then return false end
            if storeItem.brush.tab.name == 'UNCATEGORIZED' then return false end
            if storeItem.brush.tab.name == 'DECORATION' then return false end
        end

        return true
    end

    return false
end

BaseMission.loadMapFinished = Utils.appendedFunction(BaseMission.loadMapFinished, ModsOnly.removeEverythingFromTheStore)
