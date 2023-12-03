#include <algorithm>
#include <cctype>
#include <iostream>
#include <string>
#include <vector>

#include "lib/point.hpp"

int main (int argc, char *argv[]) {
    int sum{0};

    std::vector<std::string> grid;
    std::string line;
    while (std::getline(std::cin, line)) grid.push_back(line);

    const int ys = grid.size();
    const int xs = grid[0].length();

    for (int y{0}; y < ys; y++) {
        int num{0};
        bool is_part{false};

        for (int x{0}; x < xs; x++) {
            char c = grid[y][x];
            if (std::isdigit(c)) {
                num = num * 10 + (c - '0');
                point_t p{y, x};
                for (const auto& nb : p.get_valid_neighbours(ys, xs)) {
                    char nbc = grid[nb.y][nb.x];
                    if (nbc != '.' && !std::isdigit(nbc)) is_part = true;
                }
            } else {
                if (is_part) sum += num;
                num = 0;
                is_part = false;
            }
        }
        if (is_part) sum += num;
    }

    std::cout << sum << std::endl;

    return 0;
}
