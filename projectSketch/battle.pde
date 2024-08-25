PImage playerBattle, birdBattleSprite;

Battle battle;

// ui fields
float boxUIHeight = height / 3.5;
float battleUIWidth = width / 3;
int battleUIHeight = 50;
float barWidth = width / 3;

// enemy fields
public int enemyBattleSpriteX = width - width / 3;
public int enemyBattleSpriteY = 0;

// player fields
public int characterBattleSpriteX = 0;
public int characterBattleSpriteY = height - height / 2 - height / 3;

enum Choice {
  ATTACK, RUN, HEAL, INSPECT
};

Choice pointerHover = Choice.ATTACK;

int maxHeals = 2;
int healsLeft = maxHeals;

double incomingDMG = 0;
double outgoingDMG = 0;


public class Battle {

    void draw(){
        background(255,255,255);
        battle.drawEnemy();
        battle.drawPlayer();
        battle.drawBorder();
        battle.drawChoiceUI();
    }

    void updateHealth(){
        if (incomingDMG > 0 && !player.isDead()) {
            player.takeDamage(1);
            incomingDMG--;
        }

        if (outgoingDMG > 0 && currentEnemy != null && !currentEnemy.isDead()){
            currentEnemy.takeDamage(1);
            outgoingDMG--;
        }
    }



    void drawChoiceUI(){ //display ui to select choice 

        fill(255);
        strokeWeight(5);
        rect(15/2, height - boxUIHeight - 10, width/2 - 20, boxUIHeight); //draw border for dialogue
        textAlign(TOP, LEFT);
        textSize(24);
        fill(0);

        text("what will you do?", 20, height - 100 + 10);

        text("Attack!", 50 + width/3 - 15 + 60, height - 100 + 10);
        text("Run", 50 + width/3 - 15 + 60, height - 100 + 60);
        text("Inspect", 50 + width/3 - 15 + 100 + 60, height - 100 + 10);

        if (healsLeft <= 0) fill(100);
        text("Heal (" + healsLeft + ")", 50 + width/3 - 15 + 100 + 60, height - 100 + 60);
        fill(0);

        int pointerLength = 5;
        float pointerX = 0;
        float pointerY = 0;

        switch(pointerHover){
            case ATTACK:
                pointerX = width/2 - 50 + 60;
                pointerY = height - 100;
                break;
            case RUN:
                pointerX = width/2 - 50 + 60;
                pointerY = height - 50 ;
                break;
            case INSPECT:
                pointerX = width/2 + 50 + 60;
                pointerY = height - 100;
                break;
            case HEAL:
                pointerX = width/2 + 50 + 60;
                pointerY = height - 50;
                break;
        }

        triangle(pointerX, pointerY, pointerX - pointerLength, pointerY + pointerLength, pointerX - pointerLength, pointerY - pointerLength); //pointer
    }


    void drawEnemy(){
        //draw enemy
        image(currentEnemy.getSprite(), enemyBattleSpriteX, enemyBattleSpriteY, width/4, height/3); //draw enemy
        fill(0);
        rect(10, 50, barWidth, 10); //enemy hp bar
        fill(255,0,0);
        
        float enemyHPBarLength = ((barWidth * (currentEnemy.getCurrentHP() / currentEnemy.getMaxHP())) >= 0) ? (barWidth * (currentEnemy.getCurrentHP() / currentEnemy.getMaxHP())) : 0;
        rect(10, 50, enemyHPBarLength, 10); //enemy hp bar
        fill(0);
        text(currentEnemy.getName() + " Lv:" + currentEnemy.getLevel(), 10, 40);
    }

    void drawPlayer(){
        //draw player
        textSize(24);
        copy(playerBattle, 0, 0, 197, 302, characterBattleSpriteX, characterBattleSpriteY, width/3, height/2); //draw player

        rect(width - barWidth - 10, height - boxUIHeight - 70, barWidth, 10);  //player hp bar backdrop
        fill(0);
        fill(255,0,0);
        rect(width - barWidth - 10, height - boxUIHeight - 70, barWidth * (player.getCurrentHP() / player.getMaxHP()), 10); //player hp bar
        fill(0);
        rect(width - barWidth - 10, height - boxUIHeight - 50, barWidth, 10); //player exp bar backdrop
        fill(0,0,255);
        rect(width - barWidth - 10, height - boxUIHeight - 50, barWidth * (player.getCurrentEXP() / player.getMaxEXP()), 10); //player exp bar
        fill(0);
        text("You Lv:" + player.getLevel(), width - barWidth - 30, height - boxUIHeight - 80);
        textSize(15);
        text("HP", width - barWidth - 35, height - boxUIHeight - 60);
        text("XP", width - barWidth - 35, height - boxUIHeight -40);
        textSize(24);
    }

    void drawBorder(){
        //draw UI
        fill(0);
        fill(255);
        strokeWeight(5);
        rect(15/2, height - boxUIHeight - 10, width - 15, boxUIHeight); //draw border for dialogue
        textAlign(TOP, LEFT);
        textSize(24);
        fill(0);
    }

    void turn(String move){
        if (player.isDead()) return;

        boolean playerFaster = false;

        if(player.getSPEED() > currentEnemy.getSPEED()){ playerFaster = true;}
        if(player.getSPEED() <= currentEnemy.getSPEED()){ playerFaster = false;}

        dialogue.clear();
        setState(gameState.DIALOGUE);

        if(playerFaster){
            playerTurn(move); if(move == "Run") return;
            enemyTurn();
        }
        else{
            enemyTurn();
            playerTurn(move);
        }
    }

    void playerTurn(String move){
        //player turn
        if (player.getCurrentHP() > 0){
            if (move == "Attack") {
                audio.play(atkSound);
                audio.play(damageSound);
                //currentEnemy.takeDamage(player.getATK());
                outgoingDMG = player.getATK();
                dialogue.add("you used attack!");
            }

            if (move == "Heal"){ 
                player.heal(player.getMaxHP());
                dialogue.add("you used heal!");
                healsLeft--;
                audio.play(healSound);
            }
            if (move == "Run") {
                setState(gameState.OVERWORLD);
                dialogue.popUp("you ran away");
                resetHealsCount();
                audio.play(runSound);
            }

            if (move == "Inspect"){
                dialogue.add("you inspected this " + currentEnemy.getName() + ". its stats are:"); 
                inspect(currentEnemy);
            }
        }
    }

    void enemyTurn(){
        if (currentEnemy.getCurrentHP() > 0){ 
            incomingDMG = currentEnemy.getATK();
            //player.takeDamage(currentEnemy.getATK());
            dialogue.add(currentEnemy.getName() + " used attack!");
            audio.play(atkSound);
            audio.play(damageSound);
        }
    }

    //move around battle menu pinter
    void pointerUp(){
        if (pointerHover == Choice.RUN) pointerHover = Choice.ATTACK;
        if (pointerHover == Choice.HEAL) pointerHover = Choice.INSPECT;
    }
    void pointerDown(){
        if (pointerHover == Choice.ATTACK) pointerHover = Choice.RUN;
        if (pointerHover == Choice.INSPECT) pointerHover = Choice.HEAL;

    }
    void pointerLeft(){
        if (pointerHover == Choice.INSPECT) pointerHover = Choice.ATTACK;
        if (pointerHover == Choice.HEAL) pointerHover = Choice.RUN;

    }
    void pointerRight(){
        if (pointerHover == Choice.ATTACK) pointerHover = Choice.INSPECT;
        if (pointerHover == Choice.RUN) pointerHover = Choice.HEAL;
    }

    void selectChoice(){ //player's selected choice this turn
        switch(pointerHover){
            case ATTACK:
                turn("Attack");
                break;
            case RUN:
                turn("Run");
                break;
            case INSPECT:
                turn("Inspect");
                break;
            case HEAL:
                if (healsLeft <= 0){
                    dialogue.popUp("you have no heals left :(");
                    return; 
                }
                turn("Heal");
                break;
        }
    }

    void inspect(Enemy subject){
        dialogue.add(currentEnemy.getMaxHP() + "HP,  "  + currentEnemy.getATK() + " ATK,  " + currentEnemy.getSPEED() + "  SPEED and  " +  currentEnemy.getEXP() + "  EXP."); 
        dialogue.add("your stats are" + player.getMaxHP() + "HP,  "  + player.getATK() + " ATK,  " + player.getSPEED() + "  SPEED.");
    }   

    void resetHealsCount(){
        healsLeft = maxHeals;
    }

    void win(){
        if(player.levelUp(currentEnemy.getEXP())) dialogue.popUp("you leveled up to LV: " + player.getLevel());
        else stateStack.push(gameState.OVERWORLD);
        resetHealsCount();   
    }

}