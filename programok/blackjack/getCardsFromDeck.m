function cards = getCardsFromDeck(n, number_of_decks)
    global deck;
    % minimum kartya a pakliban
    min_number_of_cards_in_deck = 2;

    if number_of_decks > 2
        min_number_of_cards_in_deck = 104;
    end

    if length(deck) < min_number_of_cards_in_deck
        fprintf('Elfogytak a kartyak uj pakli\n');
        deck = getCards(number_of_decks);
        deck = deck(randperm(length(deck)));
    end

    cards = struct('value', 0, 'name', '', 'suit', '');

    for j = 1:n
        cards(j) = deck(end);
        % a tombot stack-kent kezeljuk
        deck(end) = [];
    end
end