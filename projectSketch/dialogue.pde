 Dialogue dialogue;

public class Dialogue{

    private ArrayList<String> dialogueList;
    private int currentLine;

    Dialogue(ArrayList<String> dialogueList){
        this.dialogueList = dialogueList;
        this.currentLine = 0;
    }

    
    void overwrite(ArrayList<String> newdialogue){
        this.dialogueList = newdialogue;
    }

    void add(String line){
        this.dialogueList.add(line);
    }   

    void clear(){
        dialogueList.clear();
    }

    void popUp(String message){
        currentLine = 0;
        setState(gameState.DIALOGUE);
        dialogueList.clear();
        dialogueList.add(message);
    }

    void display(){
        if (currentLine >= dialogueList.size()) { //resets dialouge when all lines are read
            stateStack.pop();
            currentLine = 0;
            dialogueList.clear();
            return;
        } 

        fill(0);
        fill(255);
        strokeWeight(5);
        rect(15/2, height - boxUIHeight - 10, width - 15, boxUIHeight); //draw border for dialogue
        textAlign(TOP, LEFT);
        textSize(24);
        fill(0);
        text(dialogueList.get(currentLine), 15, height - 100);
        textSize(12);
        text("press z to continue", width-110, height-20);
    }

    void nextLine(){
        currentLine++;
    }   

    void previousLine(){
        currentLine--;
    }

    boolean isEmpty(){
        if (dialogueList.size() == 0)return true;
        return false;
    }

     


}




