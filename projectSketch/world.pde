World world;

PImage tileSheet, forest; //map textures

int[][] area1TileMap = { //tile map

    {9,9,9,9,9,9,9,9,9,9,9,9},
    {9,0,0,0,0,0,0,0,0,0,0,9},
    {9,0,2,2,2,2,0,0,0,0,0,9},
    {9,0,2,2,2,2,0,0,0,0,0,3},
    {9,0,2,2,0,0,0,0,0,0,0,3},
    {9,0,2,2,0,0,0,0,0,0,0,9},
    {9,0,0,0,0,0,0,0,0,0,0,9},
    {9,9,9,9,9,9,9,9,9,9,9,9},

};


int[][] area2TileMap = { //tile map

    {7,7,7,7,7,7,7,7,7,7,7,7},
    {7,7,7,7,7,7,6,7,7,7,7,7},
    {9,0,0,0,0,8,8,8,0,0,0,9},
    {9,0,2,2,2,8,8,8,2,2,2,9},
    {4,8,8,8,8,8,8,8,2,2,2,9},
    {4,8,8,8,8,8,8,8,2,2,2,9},
    {9,0,2,2,2,2,2,2,2,2,2,9},
    {9,0,2,2,2,2,2,2,2,2,2,9},
    {9,9,9,9,9,9,9,9,9,9,9,9},
};


int[][] area3TileMap = { //tile map

    {1,1,1,1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1,1,1},
    {7,7,7,7,7,10,7,7,7,7,7,7},

};

int rows; // number of rows in the tile map
int cols; // number of columns in the tile map

ArrayList<Enemy> area1Enemies = new ArrayList<Enemy>();
ArrayList<Enemy> area2Enemies = new ArrayList<Enemy>();
ArrayList<Enemy> area3Enemies = new ArrayList<Enemy>();

int prevTileX = -1; // initialize previous tile coordinates to -1
int prevTileY = -1;


public class World{
    private String currentArea;
    private int[][] currentTileMap;

    public World(String currentArea){
        this.currentArea = currentArea;

        switch(currentArea){
            case "area1": this.currentTileMap = area1TileMap;
            break;
            case "area2": this.currentTileMap = area2TileMap;
            break;
        }
    }

    String getArea() {return currentArea;}
    int[][] getTileMap() {return currentTileMap;}

    void setMap(String map){
        this.currentArea = map;
    }

    void encounter(){
        double encounterRate = 0.3; // 10% chance of encounter
        if(random(0, 1.00) < 1 - encounterRate) return; 

        setState(gameState.BATTLE);
        switch(currentArea){
            case "area1":
                currentEnemy = new Enemy(area1Enemies.get((int) random(area1Enemies.size())), (int) random(1,7)); // get a random enemy from the list
            break;

            case "area2":
                currentEnemy = new Enemy(area2Enemies.get((int) random(area2Enemies.size())), (int) random(10,17)); // get a random enemy from the list
            break;

            case "area3":
                currentEnemy = new Enemy(area3Enemies.get((int) random(area3Enemies.size())), (int) random(20,50)); // get a random enemy from the list
            break;
        }
        outgoingDMG = 0;
        incomingDMG = 0;
        dialogue.popUp("a wild " + currentEnemy.getName() + " appeared!");
    }

    void teleportTo(String from, String to){
        //requirement to access new area
        switch(to){
            case "area1": 
                currentArea = to;
                currentTileMap = area1TileMap;
                playerX = tileSize;
                prevTileX = -1; // Reset the previous tile X-coordinate
                prevTileY = -1; // Reset the previous tile Y-coordinate
                rows = currentTileMap.length;  
                cols = currentTileMap[0].length; 
                playerX = (cols * tileSize) - tileSize*2;
                playerY -= tileSize*1;

                audio.update();
            break;

            case "area2":
                if(from == "area1"){
                    if (player.getLevel() < 10 && debuggingModeOn == false) {
                        dialogue.popUp("You need to be level 10 to leave.");
                        dialogue.add("Try running around in the tall grass.");
                        player.moveLeft();
                        return;
                    }

                    else{
                        currentArea = to;
                        currentTileMap = area2TileMap;
                        playerX = tileSize;
                        playerY += tileSize*1;
                        audio.update();
                    }
                }
                
                else if(from == "area3"){
                    currentArea = to;
                    currentTileMap = area2TileMap;
                    playerX = tileSize*6;
                    playerY = tileSize*2;
                    audio.update();
                }

            break;

            case "area3": 
                if (player.getLevel() < 20 && debuggingModeOn == false) {
                    dialogue.popUp("*you hear a loud roar in the cave*");
                    dialogue.add("It might be a good idea to be level 20");
                    player.moveDown();
                    return;
                }

                else{
                    currentArea = to;
                    currentTileMap = area3TileMap;
                    playerX = tileSize;
                    prevTileX = -1; // Reset the previous tile X-coordinate
                    prevTileY = -1; // Reset the previous tile Y-coordinate
                    rows = currentTileMap.length;  
                    cols = currentTileMap[0].length; 
                    playerX = tileSize*5;
                    playerY = tileSize*6;

                    audio.update();
                }
            break;
        }

    }

    boolean isWalkable(String direction){
        if (direction == "up") return world.getTileMap()[playerY/tileSize-1][playerX/tileSize] != 7 && world.getTileMap()[playerY/tileSize-1][playerX/tileSize] != 9;
        if (direction == "down") return world.getTileMap()[playerY/tileSize+1][playerX/tileSize] != 7 && world.getTileMap()[playerY/tileSize+1][playerX/tileSize] != 9;
        if (direction == "left") return world.getTileMap()[playerY/tileSize][playerX/tileSize-1] != 7 && world.getTileMap()[playerY/tileSize][playerX/tileSize-1] != 9;
        if (direction == "right") return world.getTileMap()[playerY/tileSize][playerX/tileSize+1] != 7 && world.getTileMap()[playerY/tileSize][playerX/tileSize+1] != 9;
        return true;
    }

    


    void drawMap(){
        rows = currentTileMap.length;  
        cols = currentTileMap[0].length; 
        
        background(0, 0, 0);
        translate(width / 2 - playerX - tileSize / 2, height / 2 - playerY - tileSize / 2); // set player at center of camera

        int currentTileX = floor((playerX + tileSize / 2) / tileSize); // calculate current tile coordinates
        int currentTileY = floor((playerY + tileSize / 2) / tileSize);

        if (playerX % tileSize == 0 && playerY % tileSize == 0 && (currentTileX != prevTileX || currentTileY != prevTileY)) { // check if player has fully landed on a new tile
            int tile = currentTileMap[currentTileY][currentTileX];
            if (tile == 2) encounter(); 
            if (tile == 3) {
                world.teleportTo("area1", "area2");
                //return;
            }
            if (tile == 4) {
                world.teleportTo("area2", "area1");
                return;
            }
            if (tile == 6) {
                world.teleportTo("area2", "area3");
                //return;
            }

            if (tile == 10) {
                world.teleportTo("area3", "area2");
                return;
            }
            if (tile == 1) encounter(); 

            prevTileX = currentTileX; 
            prevTileY = currentTileY;
        }

        
        for (int row = 0; row < rows; row++) { // draw the map
            for (int col = 0; col < cols; col++) {
                int tile = currentTileMap[row][col];

                switch (tile) {
                    case 0: //normal grass
                        copy(tileSheet, 0, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                    case 1: //dirt
                        copy(tileSheet, 30, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                    case 2: //tall grass
                        copy(tileSheet, 30*2, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                     case 3: //area 2 teleporter
                        fill(0);
                        copy(tileSheet, 30*3, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                    case 4: //area 1 teleporter
                        copy(tileSheet, 30*3, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                    case 5: //back
                        copy(tileSheet, 30*4, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                    case 6: //area 2 teleporter
                        copy(tileSheet, 30*5, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;

                    case 7: //cave rocks
                        copy(tileSheet, 30*6, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;
                    case 8: //footpath
                        copy(tileSheet, 30*3, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;
                    case 9: //trees
                        copy(tileSheet, 30*4, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;
                    case 10: //area 3 exit
                        copy(tileSheet, 30*7, 0, 30-2, 30, tileSize * col, tileSize * row, tileSize, tileSize);
                        break;
                }
            }
        }
  
    }







}