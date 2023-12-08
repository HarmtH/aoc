#include <array>
#include <iostream>
#include <map>
#include <string>
#include <vector>

int main (int argc, char *argv[]) {
    std::string instrucs;
    std::cin >> instrucs;

    std::string pos = "AAA";
    std::map<std::string, std::array<std::string, 2>> network;
    while (true) {
        std::string key; std::cin >> key;
        if (!std::cin) break;
        std::cin.ignore(4);
        std::cin >> network[key][0];
        network[key][0].pop_back();
        std::cin >> network[key][1];
        network[key][1].pop_back();
    }

    int steps{0};
    while (pos != "ZZZ") {
        char instruc = instrucs[steps++ % instrucs.size()];
        pos = network[pos][instruc == 'R'];
    }

    std::cout << steps << std::endl;

    return 0;
}
