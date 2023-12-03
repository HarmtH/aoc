#include <algorithm>
#include <cctype>
#include <iostream>
#include <map>
#include <optional>
#include <string>
#include <vector>

#include "lib/point.hpp"

int main (int argc, char *argv[]) {
    int sum{0};
    std::map<point_t, std::vector<int>> gears;

    std::vector<std::string> grid;
    std::string line;
    while (std::getline(std::cin, line)) grid.push_back(line);

    const int ys = grid.size();
    const int xs = grid[0].length();

    for (int y{0}; y < ys; y++) {
        std::optional<point_t> gear;
        int num{0};

        for (int x{0}; x < xs; x++) {
            char c = grid[y][x];
            if (std::isdigit(c)) {
                num = num * 10 + (c - '0');
                point_t p{y, x};
                for (const auto& nb : p.get_valid_neighbours(ys, xs)) {
                    char nbc = grid[nb.y][nb.x];
                    if (nbc == '*') gear = nb;
                }
            } else {
                if (gear) gears[*gear].push_back(num);
                num = 0;
                gear = std::nullopt;
            }
        }
        if (gear) gears[*gear].push_back(num);
    }

    for (const auto& [gear, numbers] : gears) {
        if (numbers.size() == 2) sum += numbers[0] * numbers[1];
    }

    std::cout << sum << std::endl;

    return 0;
}
