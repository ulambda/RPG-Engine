Audio audio;

SoundFile area1Music; 
SoundFile area2Music; 
SoundFile area3Music; 
SoundFile battleMusic; 
SoundFile gameoverMusic;

SoundFile atkSound;
SoundFile damageSound; 
SoundFile stepSound;
SoundFile runSound;  
SoundFile healSound; 
SoundFile selectSound; 
SoundFile pointerSound;
SoundFile levelUpSound; 
SoundFile birdCry;
SoundFile slimeCry;


public class Audio {

    void play(SoundFile sound){
        sound.play();
    }

    void update(){
        audio.change(currentState);
    }

    void change(gameState state){
        switch(state){
            case OVERWORLD:
                battleMusic.stop();
                gameoverMusic.stop();
                atkSound.stop(); 
                damageSound.stop(); 
                if(world.getArea() == "area1") area1Music.loop();
                else {area1Music.stop();}

                if(world.getArea() == "area2") area2Music.loop();
                else {area2Music.stop();}

                if(world.getArea() == "area3") area3Music.loop();
                else {area3Music.stop();}
                break;

            case BATTLE:
                area1Music.stop();
                area2Music.stop();
                area3Music.stop();
                gameoverMusic.stop();
                battleMusic.loop();
                break;

            case GAMEOVER:
                battleMusic.stop();
                area1Music.stop();
                gameoverMusic.loop();
                area2Music.stop();
                area3Music.stop();
                break;
        }
    }
}