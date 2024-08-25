//fields
PImage characterSheet;
Player player;

int playerSize = tileSize;

int playerX = tileSize; //x positon of player
int playerY = tileSize; //y positon of player

int playerXV = 0; //x velocity of player
int playerYV = 0;  //y velocity of player

int playerSheetX = 0; //x position on sprite sheet
int playerSheetY = 0; //y position on sprite sheet

int playerWalkingAnimationFrame = 0;

int playerSpeed = 4;

Enemy currentEnemy;

public class Player{
    //fields
    private int level;
    private float currentEXP;
    private float maxEXP;
    private float currentHP;
    private float maxHP;
    private float ATK;
    private float SPEED;

    private float baseEXP;
    private float baseHP;
    private float baseATK;
    private float baseSPEED;

    //constructer
    public Player(int level, int exp) {
        this.level = level;
        this.currentEXP = currentEXP;

        this.baseEXP = 10;
        this.baseHP = 10;
        this.baseATK = 10;
        this.baseSPEED = 10;


        this.maxEXP = 10;
        this.maxHP = baseHP;
        this.currentHP = maxHP;
        this.ATK = baseATK;
        this.SPEED = baseSPEED;

    }

    public float getCurrentHP(){
        return currentHP;
    }

    public void takeDamage(float damage){
        if (this.currentHP != 0) this.currentHP -= damage;
    }

    public float getMaxHP(){
        return maxHP;
    }

    public int getLevel(){
        return level;
    }

    public float getATK(){
        return ATK;
    }

    public float getSPEED(){
        return SPEED;
    }

    public float getCurrentEXP(){
        return currentEXP;
    }

    public float getMaxEXP(){
        return maxEXP;
    }


    public boolean levelUp(double expGain){
        currentEXP += expGain;
        if (currentEXP >= maxEXP){
            level++;
            currentEXP = 0;
            player.heal(maxHP);
            maxEXP = baseEXP + (level*2.5);
            maxHP = baseHP + (level*1.5);
            ATK = baseATK + (level*1.5);
            SPEED = baseSPEED + (level*1.5);
            audio.play(levelUpSound);
            return true;
        }
        return false;
    }

    public void dropEXP(){
        currentEXP = 0;
    }

    public boolean isDead(){
        return currentHP <= 0;
    }


    public void heal(float HP){
        if (currentHP + HP >= maxHP) currentHP = maxHP;
        else currentHP += HP;
    }

    public void drawSprite(){ //draw player sprite
        copy(characterSheet, 
        playerSheetX, playerWalkingAnimationFrame * 30, 30, 30,
        playerX, playerY, tileSize, tileSize); 
    }

    public void moveUp(){
        if(playerYV == 0 && playerXV == 0){
            playerSheetX = 60;
        }
        if(playerY - tileSize >= 0 && playerYV == 0 && playerXV == 0 && world.isWalkable("up")){
            playerYV -= tileSize;
        }
        
    }

    
    public void moveDown(){
        if(playerYV == 0 && playerXV == 0){
            playerSheetX = 0;
        }
        if( playerY + tileSize < rows * tileSize && playerYV == 0 && playerXV == 0 && world.isWalkable("down")) {
            playerYV += tileSize;
        }
    }

    
    public void moveLeft(){
        if(playerYV == 0 && playerXV == 0){
            playerSheetX = 30;
        }
        if( playerX - tileSize >= 0 && playerYV == 0 && playerXV == 0 && world.isWalkable("left")){
            playerXV -= tileSize;
        }  
    }

    
    public void moveRight(){
        if(playerYV == 0 && playerXV == 0){
            playerSheetX = 90;
        }
        if( playerX + tileSize < cols * tileSize && playerYV == 0 && playerXV == 0 && world.isWalkable("right")){
            playerXV += tileSize;
        }
    }

    public void updatePosition(){ //move's player position based on velocity and displays walking animation
        if(playerXV > 0){
            playerXV -= playerSpeed;
            playerX += playerSpeed;
        }
        if(playerXV < 0){
            playerXV += playerSpeed;
            playerX -= playerSpeed;        
        }
        if(playerYV > 0){
            playerYV -= playerSpeed;
            playerY += playerSpeed;
        }
        if(playerYV < 0){
            playerYV += playerSpeed;
            playerY -= playerSpeed;
        }

        if(playerXV != 0 || playerYV != 0){
            if(playerWalkingAnimationFrame >= 1) playerWalkingAnimationFrame = 0;
            else if(time % 2 == 0) playerWalkingAnimationFrame++;
        }

        else playerWalkingAnimationFrame = 0;



    }

}
