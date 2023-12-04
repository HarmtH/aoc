#include <iostream>
#include <string>
#include <utility>
#include <vector>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        size_t maxpos{0}, pos, minpos{std::string::npos};
        int first, last;

        const std::vector<std::pair<std::string, int>> numbers = {
            {"one", 1}, {"two", 2}, {"three", 3}, {"four", 4}, {"five", 5},
            {"six", 6}, {"seven", 7}, {"eight", 8}, {"nine", 9}
        };

        for (const auto& [s, i] : numbers) {
            pos = line.find(s);
            if (pos < minpos) {
                minpos = pos;
                first = i;
            }

            pos = line.rfind(s);
            if (pos != std::string::npos && pos >= maxpos) {
                maxpos = pos;
                last = i;
            }
        }

        pos = line.find_first_of("123456789");
        if (pos < minpos) first = line[pos] - '0';

        pos = line.find_last_of("123456789");
        if (pos != std::string::npos && pos >= maxpos) last = line[pos] - '0';

        sum += 10 * first + last;
    }

    std::cout << sum << std::endl;

    return 0;
}
