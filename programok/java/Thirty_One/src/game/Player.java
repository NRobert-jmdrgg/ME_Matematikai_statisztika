package game;

import java.util.Arrays;
// import game.App;

public class Player {
    private String name;
    private Card[] cards = new Card[3];
    private int lives;
    private boolean knocked;
    private boolean draw_card;
    private String Dominant;
    private int numberOfDominantCards;
    
    public Player(String name, Card[] cards, int lives) {
        this.name = name;
        this.cards = cards;
        this.lives = lives;
        this.Dominant = this.getDominantCardType();
        this.numberOfDominantCards = this.countDominantCards();
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

    public boolean drawn_card() {
        return draw_card;
    }

    public void Draw_card() {
        this.draw_card = true;
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

    private boolean hasThisTypeOfCard(Card new_card) {
        for (Card card : cards) {
            if (card.getSuit().equals(new_card.getSuit())) {
                return true;
            }
        }

        return false;
    }

    private int countNondominantCardValues() {
        int val = 0;
        for (Card card : cards) {
            if (card.getSuit() != this.getDominant()) {
                val += card.getValue();
            }
        }

        return val;
    }

    private Card[] getCardsByType(String suit) {
        int c = 0;
        for (Card card : cards) {
            if (card.getSuit().equals(suit)) {
                c++;
            }
        }

        Card[] tcards = null;

        if (c != 0) {
            tcards = new Card[c];
            int j = 0;
            for (int i = 0; i < cards.length; i++) {
                if (cards[i].getSuit().equals(suit)) {
                    tcards[j] = cards[i];
                    j++;
                }
            }
        }
    
        return tcards;
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
        
        switch (this.getNumberOfDominantCards()) {
            case 0:
                // megnézzük, hogy van-e ilyen típusú kártya, ha van elmentjuk az indexet
                int tindex = -1;
                System.out.println(new_card.getSuit());
                for (int i = 0; i < cards.length; i++) {
                    if (cards[i].getSuit().equals(new_card.getSuit())) {
                        System.out.println(cards[i].getSuit());
                        tindex = i;
                        break; //csak 1 ilyen kártya van
                    }
                }
                
                // ha nem találtunk ilyen típusút, akkor vesszük a legkissebbet cserére
                if (tindex == -1) {
                    System.out.println("Tindex. "+tindex);
                    card_to_swap = this.getMinCard();
                } else { // ha találtunk ilyen kártyát
                    int sum_of_tcards = cards[tindex].getValue() + new_card.getValue();
                    System.out.println("Tvalue:" + tindex);
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
                            System.out.println(cards[0]);
                            System.out.println(cards[1]);
                            min_card = cardMin(cards[0], cards[1]);
                            if (min_card.getValue() < sum_of_tcards) {
                                card_to_swap = min_card;
                            }
                            break;
                        default:
                            break;
                    }
                    System.out.println("Min card: " + min_card);
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
                if (!new_card.getSuit().equals(this.getDominant())) {
                    if (new_card.getValue() > this.getHandValue()) {
                        card_to_swap = this.getMinCard();
                    } 
                } else {
                    card_to_swap = this.getMinCard();
                }
                break;
        }

        return card_to_swap;
    }

    public void swap() {
        this.Dominant = getDominantCardType();
        Card swap_card = this.decideToSwap(App.discarded_cards.peek());
        boolean swap_from_stock = false;
        if (swap_card == null) {
            System.out.println("Stock card: " + App.stock_cards.peek());
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
                        cards[i] = App.discarded_cards.pop();
                    } else {
                        cards[i] = App.stock_cards.pop();
                    }
                    
                    App.discarded_cards.push(swap_card);
                    break;
                }
            }            
        }
    }

    
    
}
