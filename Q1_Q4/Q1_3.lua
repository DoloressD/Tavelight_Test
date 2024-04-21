--[[ Q1 Improving readability and Added Error Handling
Adding constants instead of magic numbers ]]
local lastStorageValue = 1000
local releaseDelay = 1000

local function releaseStorage(player)
    player:setStorageValue(lastStorageValue, -1) 
end   

function onLogout(player)
    local currentValue = player:getStorageValue(lastStorageValue)

    -- Handle other values so we know an error had occurred
    if currentValue == 1 then
        addEvent(releaseStorage, releaseDelay, player)
    elseif currentValue == -1 then
        print("Warning: Attempt to release an already released storage value")
    end
    return true
end

--[[ Q2 The method would only go through once, so we will need to add a loop. We also never used resultId, so I am using it to
loop through the query. We also do not free up the query, so I added a line for that. Also logged if resultId is empty]]
function printSmallGuildNames(memberCount)

    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"  
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    if resultId then
        -- Iteration through the rows returned by the query
        repeat
            local guildName = result.getString(resultId, "name") -- Adjusted to correctly use the resultId as first argument to follow
                                                                -- typical database patterns where the identifier must be passed with the column name
            if guildName then
                print(guildName) -- Here we print the guild name returned by the query
            end
        until not result.next(resultId) -- Assumed a method (should add if not implemented) to move to the next row until returns a nil
        
        -- need a method to free up resources associated with the query to prevent memory leaks
        result.free(resultId)
    else
        print ("No results found.") -- Error handling is always nice to add
    end 
end

--[[ Q3 Since this function is calling party:removeMember, the "sth" is "remove", so will rename a clearer intent. Im also
    removing the underscores to keep it consistent with the other functions. Also I will do two approaches though I prefer the Id
    approach but Im writing both incase we somehow still want to search members by name]]
function removeMemberFromPartyByName(playerId, memberName) -- I specify "ByName" also Capitalize membername to memberName, consistency

    local player = Player(playerId) -- variable should be declared as local, global unintentionally or uneeded could lead to bugs
    local party = player:getParty()

    if not party then -- doing thing incase there is no party, so we shouldnt continue the rest of the function
        print("Player is not in a party.") 
        return false -- indicate there is no operation performed
    end

    local members = party:getMembers(); -- would have made a count check but I think as long as a party is established,
                                        -- there should be atleast 1 member, the player

    --v will be renamed to member as that is more readable, also party:getMembers would be better off as a variable
    --so I moved it up
    for k, member in pairs(members) do
        -- Assuming Player obj have a getName method (otherwise there should be something similar),
        -- also replacing Player(membername) with just memberName, we try to avoid inefficiently creating new Player objs
        if string.lower(member.getName()) == string.lower(memberName) then -- I'm also lowercasing them to handle case sensitivity
            party:removeMember(member)
            print("Member " + memberName + " was removed from the Party.")
            return true -- indicate member successfully removed
        end 
    end
    print("Member not found in party.") -- if the code reached here that means no members were found
    return false
end

-- I personally do not like searching players by name due to many issues we could come across like case sensitivity, sharing same name (some games), perhaps weird characters
-- so here is an Id version that can coexist

function removeMemberFromPartyById(playerId, memberId) -- I specify "ById"

    local player = Player(playerId) 
    local party = player:getParty()

    if not party then
        print("Player is not in a party.") 
        return false 
    end

    local members = party:getMembers();

    for k, member in pairs(members) do
        -- Assuming Player obj have a getId method (otherwise there should be something similar)
        if member.getId() == memberId then -- no need to handle case sensitivity
            party:removeMember(member)
            print("Member " + memberId + " was removed from the Party.")
            return true 
        end 
    end
    print("Member not found in party.")
    return false
end