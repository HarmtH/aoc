#include <iostream>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        int minred{1}, mingreen{1}, minblue{1};
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
                if (color == "red") minred = std::max(minred, num);
                if (color == "green") mingreen = std::max(mingreen, num);
                if (color == "blue") minblue = std::max(minblue, num);
            }
        }
        sum += (minred * mingreen * minblue);
    }
    std::cout << sum << std::endl;
    return 0;
}
