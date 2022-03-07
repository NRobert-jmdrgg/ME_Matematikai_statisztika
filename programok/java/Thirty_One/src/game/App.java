package game;

import java.util.Stack;



import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;


public class App {

    private static Card[] cards = {
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

    public static ArrayList<Card> swapped_cards = new ArrayList<>();
    public static ArrayList<Player> losers = new ArrayList<>();
    


    private static int roundCounter;    
    private static int cycleCounter;
    private static int number_of_games = 0;
    

    

    public static void main(String[] args) {
        

        if (args.length > 0)
            try {number_of_games = Integer.parseInt(args[0]); } catch (NumberFormatException e) {e.printStackTrace(); return; }
        else
            return ;

        getFileReady("hand.csv", "Jatekos, Kartya1, Kartya2, Kartya3, osszeg");
        getFileReady("gyoztes.csv", "Jatekos, Kartya1, Kartya2, Kartya3, osszeg");
        getFileReady("cserelt.csv", "Kartya");

        int game_counter = 0;
        int number_of_players_still_in_game;

        Player[] players;

        while (game_counter < number_of_games) {
            roundCounter = 0;
            players = initPlayers();          
            game_counter++;
            number_of_players_still_in_game = players.length;

            System.out.println("------------------ GAME " + game_counter + " ------------------");

            while (number_of_players_still_in_game > 1) {
                stock_cards.addAll(Arrays.asList(cards));
                Collections.shuffle(stock_cards);
                
                // első felfordított lap
                if (discarded_cards.size() == 0) {
                    discarded_cards.push(stock_cards.pop());
                }
                // kapnak 3 kártyát
                for (int i = 0; i < players.length; i++) {
                    players[i].setCards(getThreeCardsFromStock());
                } 
                
                roundCounter++;
                System.out.println("===== ROUND : " + roundCounter + " =====");
    
                int knocker = -1;
                boolean already_knocked = false;
                cycleCounter = 0;
                while (!already_knocked && number_of_players_still_in_game > 1) {
                    cycleCounter++;
                    
                    System.out.println("Cycle : " + cycleCounter);
                    for (int i = 0; i < players.length; i++) {
                        if (players[i].still_in_game()) {
                            players[i].writeHandToFile();
                            System.out.println(players[i]);
                            System.out.println(players[i].getLives());
                            if (!already_knocked) {
                                if (players[i].decideToKnock()) {
                                    already_knocked = true;
                                    System.out.println("!!!!!!!!!!!!!!!!! PLAYER : " + players[i].getName() + " Knocked with: " + Arrays.toString(players[i].getCards()) + " Value: " + players[i].getHandValue());
                                    knocker = i;
                                    for (int j = 0; j < players.length; j++) {
                                        if (j != knocker) {
                                            System.out.println(players[j]);
                                            System.out.println(players[j].getLives());
                                            if (players[j].getLives() > 0) {
                                                System.out.println(players[j].getSummary());
                                                players[j].swap();
                                                System.out.println(players[j].getSummary());
                                            }
                                        }
                                    }
                                } else {
                                    if (players[i].getLives() > 0) {
                                        System.out.println(players[i].getSummary());
                                        players[i].swap();
                                        // System.out.println(players.get(i).getSummary());
                                    }
                                }
                            }
                        }
                        
                               
                    }
                }
    
                if (number_of_players_still_in_game > 1) {
                    App.punishLosers(players);    
                }
                
                for (int j = 0; j < players.length; j++) {
                    if (players[j].getLives() <= 0) {
                        // players.get(i).discardAllCards();
                        System.out.println("Player: " + players[j].getName() + " got eliminated with " + players[j].getHandValue());
                        // losers[li++] = players.get(j);
                        // players.remove(j);
                        players[j].setStill_in_game(false);
                    }    
                }

                for (Player player : players) {
                    if (player.still_in_game())
                        number_of_players_still_in_game++;
                }
    
                App.resetKnocks(players);
    
                System.out.println("==== Round " + roundCounter + " end ====");
            
                System.out.println("====Rount " + roundCounter +" Summary====");
                for (Player player : players) {
                    player.setHandValuePerRound();
                    System.out.println(player.getSummary());
                }
    
                System.out.println("Maradék játékosok: " + number_of_players_still_in_game);
    
                System.out.println("Eldobott kártyák: " + discarded_cards);
                
                discarded_cards.clear();
                stock_cards.clear();
            }

            System.out.println("The winner is : ");
            for (int j = 0; j < players.length; j++) 
                if (players[j].still_in_game())
                    System.out.println(players[j].getSummary());
            

            // players.clear();
        }

        System.out.println("Cserélt kártyák:");
        for (Card c : swapped_cards) {
            System.out.println(c);
        }
        
        writeSwappedToCsv();

        // losers[6] = players.get(0);

        // Player.writePlayerToFile(players.get(0));
        
        // System.out.println(Arrays.toString(losers));
    }

    private static Card[] getThreeCardsFromStock() {
        Card[] new_cards = {
            stock_cards.pop(),
            stock_cards.pop(),
            stock_cards.pop()
        }; 

        return new_cards;
    }

    private static int getMinHand(Player[] players) {
        int min = players[0].getHandValue();
        for (int i = 1; i < players.length; i++) {
            if (players[i].getHandValue() < min) {
                min = players[i].getHandValue();
            }
        }

        return min;
    }

    private static void punishLosers(Player[] players) {
        int min = getMinHand(players);

        for (int i = 0; i < players.length; i++) {
            if (players[i].getHandValue() == min) {
                if (players[i].isKnocked()) {
                    players[i].decreaseLives(2);
                    // System.out.println("<><><><><><>><> " + players.get(i).getName() + " Lost 2 lives"); 
                } else {
                    players[i].decreaseLives(1);
                }
            }
        }
    }

    public static int getRoundCounter() {
        return roundCounter;
    }

    private static void resetKnocks(Player[] players) {
        for (int i = 0; i < players.length; i++) {
            players[i].setKnock(false);
        }
    }

    public static int getCycleCounter() {
        return cycleCounter;
    }

    private static void getFileReady(String filename, String cvs_fieldnames) {
        File file = new File(filename);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            bw.write(cvs_fieldnames + "\n");
        } catch (Exception e) {
            e.getMessage();
        }
    }

    private static Player[] initPlayers() {
        Player[] players = { new Player("A", 5),
        new Player("B", 5),
        new Player("C", 5),
        new Player("D", 5),
        new Player("E", 5),
        new Player("F", 5),
        new Player("G", 5) };
        return players;
    }
    
    private static void writeSwappedToCsv() {
        File file = new File("cserelt.csv");
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            for (Card c : swapped_cards)
                bw.write(c.toString() + "\n");
        } catch (Exception e) {
            e.getMessage();
        }
    }

    // private static void writePerRoundHandValuesToCsv() {
    //     File file = new File("handValuePerRound.csv");
    //     try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
    //         for (Player player : players)
    //             bw.write(c.toString() + "\n");
    //     } catch (Exception e) {
    //         e.getMessage();
    //     }
    // }

    // private static int getNumberOfPlayersStillInGame() {

    // }
}