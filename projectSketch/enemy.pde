public class Enemy{
    //fields
    private String name;
    private int level;
    private PImage sprite;
    private float EXP;
    private float currentHP;
    private float maxHP;
    private float ATK;
    private float SPEED;

    //constructers
    public Enemy(String name, PImage sprite, int level, float EXP, float currentHP,float maxHP, float ATK, float SPEED) {
        this.name = name;
        this.level = level;
        this.currentHP = currentHP;
        this.maxHP = maxHP;
        this.ATK = ATK;
        this.SPEED = SPEED;
        this.EXP = EXP;
        this.sprite = sprite;

    }

    public Enemy(Enemy other, int level) {
        this.name = other.name;
        this.sprite = other.sprite;
        this.level = level;
        this.EXP = other.EXP + level*0.5;
        this.maxHP = other.maxHP + level*0.5;
        this.currentHP = other.currentHP + level*0.5;
        this.ATK = other.ATK + level*0.5;
        this.SPEED = other.SPEED + level*0.5;

    }

    //getter
    public String getName() {return name;}
    public int getLevel() {return level;}
    public float getEXP() {return EXP;}
    public float getMaxHP() {return maxHP;}
    public float getCurrentHP() {return currentHP;}
    public float getATK() {return ATK;}
    public float getSPEED() {return SPEED;}
    public PImage getSprite() {return sprite;}
    public boolean isDead() {return currentHP <= 0;}

    public void takeDamage(float damage){
        if (this.currentHP != 0) this.currentHP -= damage;
    }

}

