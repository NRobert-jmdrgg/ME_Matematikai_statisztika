package game;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Arrays;
import java.util.Random;

public class Player {
    private String name;
    private Card[] cards;
    private int lives;
    private boolean knocked;
    private boolean still_in_game;
    private String Dominant;
    private int numberOfDominantCards;
    private int handValuePerRound;
    
    public Player(String name, int lives) {
        this.name = name;        
        this.lives = lives;
        this.knocked = false;
        this.still_in_game = true;
        this.handValuePerRound = 0;
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
        this.lives -= lives;
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

    private Card decideWhichCardToSwap(Card new_card) {
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

    private int getIndexByCard(Card card) {
        for (int i = 0; i < cards.length; i++) {
            if (cards[i].equals(card)) {
                return i;
            }
        }

        return -1;
    }

    public void swap() {
        // this.Dominant = getDominantCardType();

        // Card card_to_swap;
        boolean swapped = false;
        if (App.discarded_cards.size() > 0) {
            int index = getIndexByCard(decideWhichCardToSwap(App.discarded_cards.peek()));
            if (index != -1) {
                swapped = true;
                System.out.println("Eldobottból:" + App.discarded_cards.peek() + " -> " + cards[index]);
                Card temp = this.cards[index];
                App.swapped_cards.add(temp);
                this.cards[index] = App.discarded_cards.pop();
                App.discarded_cards.push(temp);
            }
            
        }

        if (!swapped) {
            if (App.stock_cards.size() > 0) {
                int index = getIndexByCard(decideWhichCardToSwap(App.stock_cards.peek()));
                if (index != -1) {
                    System.out.println("stockból:" + App.stock_cards.peek() + " -> " + cards[index]);
                    Card temp = this.cards[index];
                    App.swapped_cards.add(temp);
                    this.cards[index] = App.stock_cards.pop();
                    App.discarded_cards.push(temp);
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

        if (App.getCycleCounter() < 3 && App.getCycleCounter() >= 1) {
            div = App.getCycleCounter() + 1;
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

    private String cardsToString() {
        return cards[0].toString() + ", " + cards[1].toString() + ", " + cards[2].toString();
    }

    public static void writePlayerToFile(Player player) {
        File file = new File("test.csv");
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            bw.write(player.getName() + ", " + player.getLives());
        } catch (Exception e) {
            e.getMessage();
        }
    }

    public void writeHandToFile() {
        File file = new File("hand.csv");
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(this.getName() + ", " + this.cardsToString() + ", " + this.getHandValue() + "\n");
        } catch (Exception e) {
            e.getMessage();
        }
    }

    public void setHandValuePerRound() {
        this.handValuePerRound += this.getHandValue();
    }

    public void setStill_in_game(boolean still_in_game) {
        this.still_in_game = still_in_game;
    }

    public boolean still_in_game() {
        return this.still_in_game;
    }
}
