#include <iostream>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        bool possible{true};
        std::stringstream line_ss{line};
        std::string word; int id;
        line_ss >> word >> id >> word;
        std::string rounds;
        while (std::getline(line_ss, rounds, ';')) {
            std::stringstream rounds_ss{rounds};
            std::string round;
            while (std::getline(rounds_ss, round, ',')) {
                std::stringstream round_ss{round};
                std::string color; int num;
                round_ss >> num >> color;
                if (color == "red" && num > 12) possible = false;
                if (color == "green" && num > 13) possible = false;
                if (color == "blue" && num > 14) possible = false;
            }
        }
        if (possible) sum += id;
    }
    std::cout << sum << std::endl;
    return 0;
}
