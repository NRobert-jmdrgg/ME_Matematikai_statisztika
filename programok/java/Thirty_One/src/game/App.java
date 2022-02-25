package game;

import java.util.Stack;


import java.util.ArrayList;
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

    private static int roundCounter = 0;
    private static int cycleCounter;
    public static void main(String[] args) {
        
        
        ArrayList<Player> players = new ArrayList<>();

        players.add(new Player("A", 5));
        players.add(new Player("B", 5));
        players.add(new Player("C", 5));
        players.add(new Player("D", 5));
        // players.add(new Player("E", 5));
        // players.add(new Player("F", 5));
        // players.add(new Player("G", 5));
        
        

        while (players.size() > 1) {
            stock_cards.addAll(Arrays.asList(cards));
            Collections.shuffle(stock_cards);
            
            // első felfordított lap
            if (discarded_cards.size() == 0) {
                discarded_cards.push(stock_cards.pop());
            }
            // kapnak 3 kártyát
            for (int index = 0; index < players.size(); index++) {
                players.get(index).setCards(getThreeCardsFromStock());
            } 
            
            roundCounter++;
            System.out.println("===== ROUND : " + roundCounter + " =====");

            int knocker = -1;
            boolean already_knocked = false;
            cycleCounter = 0;
            while (!already_knocked) {
                cycleCounter++;
                System.out.println("Cycle : " + cycleCounter);
                for (int i = 0; i < players.size(); i++) {
                    
                    // System.out.println(players.get(i));
                    // System.out.println(players.get(i).getLives());
                    if (!already_knocked) {
                        if (players.get(i).decideToKnock()) {
                            already_knocked = true;
                            System.out.println("!!!!!!!!!!!!!!!!! PLAYER : " + players.get(i).getName() + " Knocked with: " + Arrays.toString(players.get(i).getCards()) + " Value: " + players.get(i).getHandValue());
                            knocker = i;
                            for (int j = 0; j < players.size(); j++) {
                                if (j != knocker) {
                                    // System.out.println(players.get(j));
                                    // System.out.println(players.get(j).getLives());
                                    if (players.get(j).getLives() > 0) {
                                        System.out.println(players.get(j).getSummary());
                                        players.get(j).swap();
                                        System.out.println(players.get(j).getSummary());
                                    }
                                }
                            }
                        } else {
                            if (players.get(i).getLives() > 0) {
                                System.out.println(players.get(i).getSummary());
                                players.get(i).swap();
                                System.out.println(players.get(i).getSummary());
                            }
                        }
                    }
                           
                }
            }
            
            if (players.size() > 1) {
                App.punishLosers(players);    
            }
            
            for (int j = 0; j < players.size(); j++) {
                if (players.get(j).getLives() <= 0) {
                    // players.get(i).discardAllCards();
                    System.out.println("Player: " + players.get(j).getName() + " got eliminated with " + players.get(j).getHandValue());
                    players.remove(j);
                }    
            }

            App.resetKnocks(players);

            System.out.println("==== Round " + roundCounter + " end ====");
        
            System.out.println("====Rount " + roundCounter +" Summary====");
            for (Player player : players) {
                System.out.println(player.getSummary());
            }

            System.out.println("Maradék játékosok: " + players.size());

            System.out.println("Eldobott kártyák: " + discarded_cards);
            
            discarded_cards.clear();
            stock_cards.clear();
        }
        
        System.out.println("The winner is : ");
        System.out.println(players.get(0).getSummary());         
    }

    private static Card[] getThreeCardsFromStock() {
        Card[] new_cards = {
            stock_cards.pop(),
            stock_cards.pop(),
            stock_cards.pop()
        }; 

        return new_cards;
    }

    private static int getMinHand(ArrayList<Player> players) {
        int min = players.get(0).getHandValue();
        for (int i = 1; i < players.size(); i++) {
            if (players.get(i).getHandValue() < min) {
                min = players.get(i).getHandValue();
            }
        }

        return min;
    }

    private static void punishLosers(ArrayList<Player> players) {
        int min = getMinHand(players);

        for (int i = 0; i < players.size(); i++) {
            if (players.get(i).getHandValue() == min) {
                players.get(i).decreaseLives(1);
            }
        }

    }

    public static int getRoundCounter() {
        return roundCounter;
    }

    private static void resetKnocks(ArrayList<Player> players) {
        for (int i = 0; i < players.size(); i++) {
            players.get(i).setKnock(false);
        }
    }

    public static int getCycleCounter() {
        return cycleCounter;
    }

}