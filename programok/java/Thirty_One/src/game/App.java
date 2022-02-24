package game;

import java.util.Stack;
import java.util.Arrays;
import java.util.Collections;

public class App {

    public static Card[] cards = {
        new Card(2, "Heart", "2"),
        new Card(3, "Heart", "3"),
        new Card(4, "Heart", "4"),
        new Card(5, "Heart", "5"),
        new Card(6, "Heart", "6"),
        new Card(7, "Heart", "7"),
        new Card(8, "Heart", "8"),
        new Card(9, "Heart", "9"),
        new Card(10, "Heart", "10"),
        new Card(10, "Heart", "J"),
        new Card(10, "Heart", "Q"),
        new Card(10, "Heart", "K"),
        new Card(11, "Heart", "A"),
        new Card(2, "Diamond", "2"),
        new Card(3, "Diamond", "3"),
        new Card(4, "Diamond", "4"),
        new Card(5, "Diamond", "5"),
        new Card(6, "Diamond", "6"),
        new Card(7, "Diamond", "7"),
        new Card(8, "Diamond", "8"),
        new Card(9, "Diamond", "9"),
        new Card(10, "Diamond", "10"),
        new Card(10, "Diamond", "J"),
        new Card(10, "Diamond", "Q"),
        new Card(10, "Diamond", "K"),
        new Card(11, "Diamond", "A"),
        new Card(2, "Club", "2"),
        new Card(3, "Club", "3"),
        new Card(4, "Club", "4"),
        new Card(5, "Club", "5"),
        new Card(6, "Club", "6"),
        new Card(7, "Club", "7"),
        new Card(8, "Club", "8"),
        new Card(9, "Club", "9"),
        new Card(10, "Club", "10"),
        new Card(10, "Club", "J"),
        new Card(10, "Club", "Q"),
        new Card(10, "Club", "K"),
        new Card(11, "Club", "A"),
        new Card(2, "Spade", "2"),
        new Card(3, "Spade", "3"),
        new Card(4, "Spade", "4"),
        new Card(5, "Spade", "5"),
        new Card(6, "Spade", "6"),
        new Card(7, "Spade", "7"),
        new Card(8, "Spade", "8"),
        new Card(9, "Spade", "9"),
        new Card(10, "Spade", "10"),
        new Card(10, "Spade", "J"),
        new Card(10, "Spade", "Q"),
        new Card(10, "Spade", "K"),
        new Card(11, "Spade", "A")
    }; 

    public static Stack<Card> stock_cards = new Stack<>();
    public static Stack<Card> discarded_cards = new Stack<>();
    
    public static void main(String[] args) {
        stock_cards.addAll(Arrays.asList(cards));
        Collections.shuffle(stock_cards);
        
        
        Player[] players = {
            new Player("A", getThreeCardsFromStock(), 5),
            new Player("B", getThreeCardsFromStock(), 5),
            new Player("C", getThreeCardsFromStock(), 5),
            new Player("D", getThreeCardsFromStock(), 5)
        };

        // for (int i = 0; i < players.length; i++) {
        //     System.out.println(players[i]);
        //     System.out.println(players[i].getHandValue());
        //     System.out.println(players[i].getDominant());
        //     System.out.println(players[i].getNumberOfDominantCards());
        // }
        
        // első felfordított lap
        discarded_cards.add(stock_cards.pop());
        // System.out.println("Discarded stack top" + discarded_cards.peek());

        // Card[] ca = {
        //     new Card(3, "Diamond", "3"),
        //     new Card(2, "Heart", "2"),
        //     new Card(4, "Club", "4")
        // };
        // Player asd = new Player(
        //     "asd", ca, 5
        // );

        // // System.out.println(asd.getNumberOfDominantCards());

        // //check if player A wants to swap
        // System.out.println(asd);
        // System.out.println(asd.getHandValue());
        // System.out.println(asd.getDominant());
        // System.out.println(asd.getNumberOfDominantCards());

        // asd.swap();

        // System.out.println(asd);

        // // System.out.println(discarded_cards);
        // // System.out.println("brain cancer: " + asd.cardMin(ca[1], ca[2]));

    }

    private static Card[] getThreeCardsFromStock() {
        Card[] new_cards = {
            stock_cards.pop(),
            stock_cards.pop(),
            stock_cards.pop()
        }; 

        return new_cards;
    }

}
