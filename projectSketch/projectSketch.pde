import java.util.Stack; 
import processing.sound.*; //import sound processing library

boolean debuggingModeOn = true;

int height = 450;
int width = 450;
int time = 0;
int tileSize = 40;


//finite state machine
enum gameState {STARTMENU, OVERWORLD, BATTLE, DIALOGUE, GAMEOVER, PAUSE}
Stack<gameState> stateStack = new Stack<gameState>();
gameState currentState() {return stateStack.peek();}
gameState currentState;
gameState previousState;

void updateState() {
    currentState = currentState();
    if (currentState != previousState && currentState != gameState.DIALOGUE) {   
        audio.change(currentState);
        previousState = currentState;
    }
}

void setState(gameState state) {
    stateStack.push(state);
}


void setup(){
    size(450,450);
    frameRate(30);

    //load Pimages
    forest = loadImage("images/backgrounds/forest.png");
    characterSheet = loadImage("images/spritesheets/characterSheet.png");
    tileSheet = loadImage("images/spritesheets/tileSheet.png");
    playerBattle = loadImage("images/spritesheets/playerBattle.png");
    birdBattleSprite = loadImage("images/spritesheets/birdBattleSprite.png");

    //load states
    stateStack.add(gameState.BATTLE);
    stateStack.add(gameState.OVERWORLD);
    stateStack.add(gameState.STARTMENU);
    currentState = currentState();
    previousState = currentState();

    //load world
    world = new World("area1");

    //load battle
    battle = new Battle();

    player = new Player(1, 0); //construct player object
    dialogue = new Dialogue(new ArrayList<String>()); //construct dialogue object


    //load audio
    audio = new Audio();
    area1Music = new SoundFile(this, "audio/music/area1.mp3");
    area1Music.amp(0.1);
    battleMusic = new SoundFile(this, "audio/music/battle.mp3");
    battleMusic.amp(0.1);
    gameoverMusic = new SoundFile(this, "audio/music/gameover.mp3");
    gameoverMusic.amp(0.1);
    
    atkSound = new SoundFile(this, "audio/sound/attack.mp3");
    atkSound.amp(0.05);
    damageSound = new SoundFile(this, "audio/sound/damage.mp3");
    damageSound.amp(0.05);
    //stepSound = new SoundFile(this, "audio/sound/.mp3");
    runSound = new SoundFile(this, "audio/sound/run.mp3");
    runSound.amp(0.1);
    healSound = new SoundFile(this, "audio/sound/heal.mp3");
    healSound.amp(0.1);
    selectSound = new SoundFile(this, "audio/sound/select.mp3");
    selectSound.amp(0.1);
    levelUpSound = new SoundFile(this, "audio/sound/levelUp.mp3");
    levelUpSound.amp(0.1);
    //birdCry = new SoundFile(this, "audio/.mp3");
    //slimeCry = new SoundFile(this, "audio/.mp3");
    area2Music = new SoundFile(this, "audio/music/area2.mp3");
    area2Music.amp(0.1);
    pointerSound = new SoundFile(this, "audio/sound/pointer.mp3");
    pointerSound.amp(0.1);
    area3Music = new SoundFile(this, "audio/music/area3.mp3");
    area3Music.amp(0.1);

    
    //load encounter data
    JSONObject encounterData = loadJSONObject("data/encounters.json");
    JSONArray area1EnemyData = encounterData.getJSONArray("area1");
    JSONArray area2EnemyData = encounterData.getJSONArray("area2");
    JSONArray area3EnemyData = encounterData.getJSONArray("area3");

    

    for(int i = 0 ; i < area1EnemyData.size(); i++){
        JSONObject enemyData = area1EnemyData.getJSONObject(i);
        PImage sprite = loadImage("images/spritesheets/" + enemyData.getString("sprite") + ".png");
        area1Enemies.add(new Enemy(enemyData.getString("name"), sprite, enemyData.getInt("level"), enemyData.getInt("EXP"), enemyData.getInt("maxHP"), enemyData.getInt("maxHP"), enemyData.getInt("ATK"), enemyData.getInt("SPEED")));
    }


    for(int i = 0 ; i < area2EnemyData.size(); i++){
        JSONObject enemyData = area2EnemyData.getJSONObject(i);
        PImage sprite = loadImage("images/spritesheets/" + enemyData.getString("sprite") + ".png");
        area2Enemies.add(new Enemy(enemyData.getString("name"), sprite, enemyData.getInt("level"), enemyData.getInt("EXP"), enemyData.getInt("maxHP"), enemyData.getInt("maxHP"), enemyData.getInt("ATK"), enemyData.getInt("SPEED")));
    }

    for(int i = 0 ; i < area3EnemyData.size(); i++){
        JSONObject enemyData = area3EnemyData.getJSONObject(i);
        PImage sprite = loadImage("images/spritesheets/" + enemyData.getString("sprite") + ".png");
        area3Enemies.add(new Enemy(enemyData.getString("name"), sprite, enemyData.getInt("level"), enemyData.getInt("EXP"), enemyData.getInt("maxHP"), enemyData.getInt("maxHP"), enemyData.getInt("ATK"), enemyData.getInt("SPEED")));
    }

    surface.setTitle("RPGengine");
    surface.setIcon(characterSheet.get(0, 0, 30, 30));
}


void draw(){
    switch (currentState()) {
        case STARTMENU:
            background(0);
            textAlign(CENTER, CENTER);
            textSize(32);
            fill(255);
            text("RPG engine", width/2, height/2 - 11);
            textSize(12);
            text("press z to start", width/2, height/2 + 24);
        break;	


        case BATTLE:
            battle.draw();
            battle.updateHealth();
            if (currentEnemy.isDead()) battle.win();

        break;

        case OVERWORLD:
            world.drawMap();
            player.drawSprite();
            player.updatePosition();
        break;

        case DIALOGUE:
            dialogue.display();
        break;

        case GAMEOVER:
            background(255, 0, 0);
            textAlign(CENTER, CENTER);
            textSize(32);
            fill(0);
            text("Game Over", width/2, height/2 - 11);
            textSize(12);
            text("you have lost exp", width/2, height/2 + 24);
            text("press z to revive", width/2, height/2 + 24*2);
            player.dropEXP();
            player.heal(player.getMaxHP());
            battle.resetHealsCount();
        break;	
    }

    updateState(); //state change listener (except dialogue)

    if (player.getCurrentHP() <= 0 && dialogue.isEmpty()) setState(gameState.GAMEOVER); //fail state listener
    time++;
}
