package game;

public class Card {
    private int value;
    private String suit;
    private String face;
    private String ID;

    public Card(int value, String suit, String face) {
        this.value = value;
        this.suit = suit;
        this.face = face;
        this.ID = this.suit.charAt(0) + this.face;
    }

    public int getValue() {
        return value;
    }

    public String getSuit() {
        return suit;
    }

    public String getFace() {
        return face;
    }

    public String getID() {
        return ID;
    }

    public void setID(String iD) {
        ID = iD;
    }

    @Override
    public String toString() {
        return ID + " "; 
    }


}
