//Q4 Focusing on memory leak issue, I am ensuring we are deleting the allocated memory for player when we are done using it

void Game::addItemToPlayer(const std::string& playerName, uint16_t itemId) //changed from recipient to playerName for readability since the function already states the recipient is the player
{
    Player* player = g_game.getPlayerByName(playerName);
    bool playerCreated = false; // We will track whether a new player was created to help know if we need to deallocate the memory

    if (!player){
        player = new Player(nullptr);
        playerCreated = true; // player has been created since one didnt exist

        if (!IOLoginData::loadPlayerByName(player, playerName)){
            delete player; //cleaned up allocated memory as to prevent memory leak
            return;
        }

    }

    Item* item = Item::CreateItem(itemId);

    if (!item) {
        if(playerCreated){
            delete player; //no item was created and we are exiting the function so we should clean up the player
        }
        return;

    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()){
        IOLoginData::savePlayer(player);

        if(playerCreated){
            delete player; //if player is offline and a new player obj was created, delete now that we finished using
        }
    }

}