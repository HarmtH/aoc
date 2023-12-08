#include <array>
#include <iostream>
#include <map>
#include <numeric>
#include <string>
#include <vector>

int main (int argc, char *argv[]) {
    std::string instrucs;
    std::cin >> instrucs;

    std::vector<std::string> posses;
    std::map<std::string, std::array<std::string, 2>> network;
    while (true) {
        std::string key; std::cin >> key;
        if (!std::cin) break;
        if (key.ends_with('A')) posses.push_back(key);
        std::cin.ignore(4);
        std::cin >> network[key][0];
        network[key][0].pop_back();
        std::cin >> network[key][1];
        network[key][1].pop_back();
    }

    long steps{0}, ans{1};
    while (!posses.empty()) {
        auto done = [](const auto& pos) { return pos.ends_with('Z'); };
        char instruc = instrucs[steps++ % instrucs.size()];
        for (auto& pos : posses) {
            pos = network[pos][instruc == 'R'];
            if (done(pos)) ans = std::lcm(ans, steps);
        }
        std::erase_if(posses, done);
    }

    std::cout << ans << std::endl;

    return 0;
}
