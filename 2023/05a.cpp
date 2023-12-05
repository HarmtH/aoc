#include <climits>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct rule_t {
    long src, dst, length;
};

int main (int argc, char *argv[]) {
    std::string line;
    std::vector<std::vector<rule_t>> maps;
    std::vector<long> seeds;

    while (std::getline(std::cin, line)) {
        std::stringstream ss(line);
        std::string word;

        if (!seeds.size()) {
            ss >> word;
            while (ss) {
                long num; ss >> num;
                seeds.push_back(num);
            }
        }

        else if (line == "");

        else if (!std::isdigit(ss.peek())) {
            maps.push_back(std::vector<rule_t>());
        }

        else {
            rule_t rule;
            ss >> rule.dst >> rule.src >> rule.length;
            maps.back().push_back(rule);
        }
    }

    long lowest{LONG_MAX};
    for (long seed : seeds) {
        long res{seed};
        for (const auto& map : maps) {
            for (const auto& rule : map) {
                if (res >= rule.src && res < rule.src + rule.length) {
                    res += rule.dst - rule.src;
                    break;
                }
            }
        }
        lowest = std::min(lowest, res);
    }

    std::cout << lowest << std::endl;

    return 0;
}
