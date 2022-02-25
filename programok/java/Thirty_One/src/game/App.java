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

        // első felfordított lap
        discarded_cards.add(stock_cards.pop());

        for (int i = 0; i < players.length; i++) {
            System.out.println(discarded_cards);
        
            System.out.println(players[i]);
            
            players[i].swap();
            
            System.out.println(players[i]);

            System.out.println(discarded_cards);

            System.out.println("-------------------------");
   
        }

        int[] losers = decideLosers(players);

        punishLosers(players, losers);

        for (Player player : players) {
            System.out.println(player.getName() + " " + player.getHandValue() +" " + player.getLives());
        }

        // System.out.println(players[1]);
        
        // players[1].swap();
        
        // System.out.println(players[1]);

        // System.out.println(discarded_cards);

        // System.out.println(players[2]);
        
        // players[2].swap();
        
        // System.out.println(players[2]);

        // System.out.println(players[3]);
        
        // players[3].swap();
        
        // System.out.println(players[3]);
        //ameddig van legalább 2 játékosnak élete
        // while (checkLives(players)) {
        //     for (int i = 0; i < players.length; i++) {
        //         players[i].swap();
        //     }

        //     int[] losers = decideLosers(players);
        //     punishLosers(players, losers);

        //     if (stock_cards.size() == 0) {
        //         System.out.println("Elfogytak a lapok");
        //         break;
        //     }
        // }

        // for (int i = 0; i < players.length; i++) {
        //     if (players[i].getLives() > 0) {
        //         System.out.println("The winner is : " + players[i]);
        //         break;
        //     }
        // }
        
    }

    private static Card[] getThreeCardsFromStock() {
        Card[] new_cards = {
            stock_cards.pop(),
            stock_cards.pop(),
            stock_cards.pop()
        }; 

        return new_cards;
    }

    private static int[] decideLosers(Player[] players) {
        int[] hands = new int[4];
        for (int i = 0; i < hands.length; i++) {
            hands[i] = players[i].getHandValue();
        }

        int min = hands[0];

        for (int i = 1; i < hands.length; i++) {
            if (hands[i] < min) {
                min = hands[i];
            }
        }

        int c = 0;
        for (int i = 0; i < hands.length; i++) {
            if (hands[i] == min) {
                c++;
            }
        }

        int[] losers = new int[c];
        int j = 0;
        for (int i = 0; i < losers.length; i++) {
            if (hands[i] == min) {
                losers[j++] = i;
            }   
        }

        return losers;
    }

    private static void punishLosers(Player[] players, int[] losers) {
        for (int i : losers) {
            players[i].decreaseLives(1);
        }
    }

    private static boolean checkLives(Player[] p) {
        if (p[0].getLives() > 0 && (p[1].getLives() > 0 || p[2].getLives() > 0 || p[3].getLives() > 0)) {
            return true;
        } else if (p[1].getLives() > 0 && (p[0].getLives() > 0 || p[2].getLives() > 0 || p[3].getLives() > 0)) {
            return true;
        } else if (p[2].getLives() > 0 && (p[0].getLives() > 0 || p[1].getLives() > 0 || p[3].getLives() > 0)) {
            return true;
        } else if (p[3].getLives() > 0 && (p[0].getLives() > 0 || p[1].getLives() > 0 || p[2].getLives() > 0)) {
            return true;
        }

        return false;
    }    

}
