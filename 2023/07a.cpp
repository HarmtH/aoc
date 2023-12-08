#include <algorithm>
#include <compare>
#include <iostream>
#include <string>
#include <vector>

struct hand_t {
    static constexpr std::string_view order{"23456789TJQKA"};
    std::vector<int> freqs, cards;
    int bid;

    auto operator<=>(const hand_t&) const = default;
};

std::istream& operator>>(std::istream& in, hand_t& hand) {
    // we use std::move, so the hand on the stack will always be empty
    hand.freqs.resize(hand_t::order.size());

    for (int i = 0; i < 5; i++) {
        char c; in >> c;
        if (!in) return in;
        const int card_val = hand.order.find(c);
        hand.cards.push_back(card_val);
        hand.freqs[card_val]++;
    }

    // the standard vector sort order is exactly what we need:
    // [1,1,1,1,1] [2,1,1,1] [2,2,1] [3,1,1] [3,2] [4,1] [5] 
    std::sort(hand.freqs.begin(), hand.freqs.end(), std::greater<>());

    in >> hand.bid;
    return in;
}

int main (int argc, char *argv[]) {
    std::vector<hand_t> hands;

    hand_t hand;
    while (std::cin >> hand) hands.push_back(std::move(hand));
    std::sort(hands.begin(), hands.end());

    long sum = 0;
    for (int i = 0; i < hands.size(); i++)
        sum += hands[i].bid * (i + 1);

    std::cout << sum << std::endl;

    return 0;
}
