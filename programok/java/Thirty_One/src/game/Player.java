package game;

import java.util.Arrays;
import java.util.Random;

// import game.App;

public class Player {
    private String name;
    private Card[] cards;
    private int lives;
    private boolean knocked;
    private String Dominant;
    private int numberOfDominantCards;
    
    public Player(String name, int lives) {
        this.name = name;
        // this.cards = cards;
        this.lives = lives;
        //this.Dominant = this.getDominantCardType();
        // this.numberOfDominantCards = this.countDominantCards();
        this.knocked = false;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Card[] getCards() {
        return cards;
    }

    public void setCards(Card[] cards) {
        this.cards = cards;
        this.Dominant = this.getDominantCardType();
    }

    public int getLives() {
        return lives;
    }

    public void decreaseLives(int lives) {
        this.lives--;
    }

    public boolean isKnocked() {
        return knocked;
    }

    public void knock() {
        this.knocked = true;
    }

    public String getDominant() {
        return this.Dominant;
    }

    public int getNumberOfDominantCards() {
        return numberOfDominantCards;
    }

    @Override
    public String toString() {
        return "Player " + this.name + " cards " + Arrays.toString(cards);    
    }

    public int getHandValue() {

        if (this.getDominant() != null) {
            if (this.getNonDominantTypeCard() != null && 
                this.countDominantCardValues() < this.getNonDominantTypeCard().getValue()) {
                return this.getNonDominantTypeCard().getValue();
            } 
            return this.countDominantCardValues();
        }

        return this.getMaxValueCard().getValue();
    }

    private String getDominantCardType() {
        String t = null;

        // igaz ha az első lappal megegyező típusú lap van.
        if (this.cards[0].getSuit().equals(cards[1].getSuit()) || 
            this.cards[0].getSuit().equals(cards[2].getSuit())) {
            t = this.cards[0].getSuit();
        } else if (this.cards[1].getSuit().equals(cards[2].getSuit())) {
            t = this.cards[1].getSuit();
        }

        return t;
    }

    private int countDominantCardValues() {
        int val = 0;
        for (Card card : cards) {
            if (card.getSuit() == this.getDominant()) {
                val += card.getValue();
            }
        }

        return val;
    }

    private Card getMaxValueCard() {
        Card c = this.cards[0];
        for (int i = 1; i < cards.length; i++) {
            if (this.cards[i].getValue() > c.getValue()) {
                c = this.cards[i];
            }
        }

        return c;
    }

    private Card getNonDominantTypeCard() {
        for (int i = 0; i < cards.length; i++) {
            if (this.cards[i].getSuit() != this.getDominant()) {
                return this.cards[i];
            }
        }
        return null;
    }

    private Card getMinCard() {
        Card min = this.getCards()[0];
        for (int i = 1; i < cards.length; i++) {
            if (cards[i].getValue() < min.getValue()) {
                min = cards[i];
            }
        }

        return min;
    }

    private int countDominantCards() {
        int count = 0;
        for (Card card : cards) {
            if (card.getSuit().equals(this.getDominant())) {
                count++;
            }
        }

        return count;
    }

    public Card cardMin(Card a, Card b) {
        if (a.getValue() <= b.getValue()) {
            return a;
        } else {
            return b;
        }
    }

    private Card decideToSwap(Card new_card) {
        Card card_to_swap = null;
        Card min_card = null;
        
        this.numberOfDominantCards = this.countDominantCards();

        // System.out.println("Number of dominant cards: " + this.getNumberOfDominantCards());

        switch (this.getNumberOfDominantCards()) {
            case 0:
                // megnézzük, hogy van-e ilyen típusú kártya, ha van elmentjuk az indexet
                int tindex = -1;
                // System.out.println(new_card.getSuit());
                for (int i = 0; i < cards.length; i++) {
                    if (cards[i].getSuit().equals(new_card.getSuit())) {
                        // System.out.println(cards[i].getSuit());
                        tindex = i;
                        break; //csak 1 ilyen kártya van
                    }
                }
                
                // ha nem találtunk ilyen típusút, akkor vesszük a legkissebbet cserére
                if (tindex == -1) {
                    // System.out.println("Tindex. "+tindex);
                    if (this.getMinCard().getValue() < new_card.getValue()) {
                        card_to_swap = min_card;
                    }
                } else { // ha találtunk ilyen kártyát
                    int sum_of_tcards = cards[tindex].getValue() + new_card.getValue();
                    // System.out.println("Tvalue:" + tindex);
                    switch (tindex) {
                        case 0:
                            min_card = cardMin(cards[1], cards[2]);
                            if (min_card.getValue() < sum_of_tcards) {
                                card_to_swap = min_card;
                            }
                            break;
                        case 1:
                            min_card = cardMin(cards[0], cards[2]);
                            if (min_card.getValue() < sum_of_tcards) {
                                card_to_swap = min_card;
                            }
                            break;
                        case 2:
                            // System.out.println(cards[0]);
                            // System.out.println(cards[1]);
                            min_card = cardMin(cards[0], cards[1]);
                            if (min_card.getValue() < sum_of_tcards) {
                                card_to_swap = min_card;
                            }
                            break;
                        default:
                            break;
                    }
                    // System.out.println("Min card: " + min_card);
                }
                break;
            case 2:
                if (new_card.getSuit().equals(this.getDominant())) { 
                    int nd_index = -1;
                    for (int i = 0; i < cards.length; i++) {
                        if (!cards[i].getSuit().equals(new_card.getSuit())) { // Nem dominans kartya
                            nd_index = i;
                            break;
                        }
                    }

                    if (cards[nd_index].getValue() < this.countDominantCardValues() + new_card.getValue()) {
                        card_to_swap = cards[nd_index];
                    } /*else { Nem cserélünk

                    }*/
                } else { // Nem domináns szín
                    // két lehetőség van Ha az új kártya típusa megegyezik a nem domináns kártya típusával vagy nem
                    for (int i = 0; i < cards.length; i++) {
                        if (!cards[i].getSuit().equals(this.getDominant())) {
                            if (cards[i].getSuit().equals(new_card.getSuit())) { // ha a nem domináns és az uj kartya tipusa megegyezik
                                // meg kell nézni, hogy a domináns kártyák összege kissebb, mint az új kombináció
                                switch (i) {
                                    case 0:
                                        if (cards[i].getValue() + new_card.getValue() > cards[1].getValue() + cards[2].getValue()) {
                                            card_to_swap = cardMin(cards[1], cards[2]);
                                        }
                                        break;
                                    case 1:
                                        if (cards[i].getValue() + new_card.getValue() > cards[0].getValue() + cards[2].getValue()) {
                                            card_to_swap = cardMin(cards[0], cards[2]);
                                        }
                                        break;
                                    case 2:
                                        if (cards[i].getValue() + new_card.getValue() > cards[0].getValue() + cards[1].getValue()) {
                                            card_to_swap = cardMin(cards[0], cards[1]);
                                        }
                                    default:
                                        break;
                                }
                            } else { // megnezzuk, hogy az új kártya nagyobb-e
                                if (cards[i].getValue() < new_card.getValue()) {
                                    card_to_swap = cards[i];
                                }
                            }
                            break;
                        }
                        
                    }
                }
                break;
            case 3:
                // System.out.println("Dominant type: " + this.getDominant());
                if (!new_card.getSuit().equals(this.getDominant())) {
                    if (new_card.getValue() > this.getHandValue()) {
                        card_to_swap = this.getMinCard();
                    } 
                } else {
                    if (this.getMinCard().getValue() < new_card.getValue()) {
                        card_to_swap = min_card;
                    }
                }
                break;
        }

        return card_to_swap;
    }

    public void swap() {
        this.Dominant = getDominantCardType();

        Card swap_card = this.decideToSwap(App.discarded_cards.peek());
        boolean swap_from_stock = false;
        if (swap_card == null && App.stock_cards.size() > 0) {
            // System.out.println("Stock card: " + App.stock_cards.peek());
            swap_card = this.decideToSwap(App.stock_cards.peek());
            if (swap_card == null) {
                App.discarded_cards.push(App.stock_cards.pop());
            }
            swap_from_stock = true;
        }
        if (swap_card != null) {
            for (int i = 0; i < cards.length; i++) {
                if (cards[i] == swap_card) {
                    if (!swap_from_stock) {
                        System.out.println("Eldobottból:" + App.discarded_cards.peek() + " -> " + cards[i]);
                        cards[i] = App.discarded_cards.pop();
                    } else {
                        System.out.println("stockból:" + App.stock_cards.peek() + " -> " + cards[i]);
                        cards[i] = App.stock_cards.pop();
                    }
                    
                    App.discarded_cards.push(swap_card);
                    break;
                }
            }            
        }

        this.Dominant = getDominantCardType();
    }

    public boolean decideToKnock() {
        // formula ami alapján random knockolnak a játékosok. (csak 1 knockolhat)
        
        if (this.getHandValue() == 31) {
            this.setKnock(true);
            return true;    
        }

        double knock_chance;
        int div;

        if (App.getRoundCounter() < 3 && App.getRoundCounter() >= 1) {
            div = App.getRoundCounter() + 1;
        } else {
            div = 4;
        }

        if (this.getHandValue() <= 15) {
            knock_chance = ( this.getHandValue() / 31.0 ) / div;
        } else {
            knock_chance = ( this.getHandValue() / 31.0 );
        }

        // System.out.println("knock chance:" + knock_chance);

        Random rand = new Random();
        float f = rand.nextFloat();

        // System.out.println("Random: " + f);

        if (f < knock_chance) {
            this.setKnock(true);
            return true;
        }

        return false;
    }
    
    public void setKnock(boolean b) {
        this.knocked = b;
    }

    public String getSummary() {
        return "Name: " + this.name + " Cards: " + Arrays.toString(this.cards) + " hand value: " + this.getHandValue() + " Lives: " + this.lives;
    }

    
}
