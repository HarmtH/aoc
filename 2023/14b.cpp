#include "lib/prelude.hpp"

int main(void) {

    vector<string> grid;
    for (string line; getline(cin, line);) grid.eb(line);

    map<vector<string>, int> seen;
    bool looped = false;

    for (int i = 0; i < 1'000'000'000; i++) {

        // loop detection
        if (!looped) {
            const auto& [it, inserted] = seen.insert({grid, i});
            if (!inserted) {
                const auto& [_, prev_i] = *it;
                int loop_size = (i - prev_i);
                i += (1'000'000'000 - i) / loop_size * loop_size;
                looped = true;
            }
        }

        // north
        for (int x = 0; x < grid[0].size(); x++) {
            for (int y = 0; y < grid.size(); y++) {
                if (grid[y][x] == 'O') {
                    int best_spot = 0;
                    for (int y1 = 0; y1 < y; y1++) {
                        if (grid[y1][x] != '.') best_spot = y1 + 1;
                    }
                    if (best_spot != y) {
                        grid[best_spot][x] = 'O';
                        grid[y][x] = '.';
                    }
                }
            }
        }

        // west
        for (int y = 0; y < grid.size(); y++) {
            for (int x = 0; x < grid[0].size(); x++) {
                if (grid[y][x] == 'O') {
                    int best_spot = 0;
                    for (int x1 = 0; x1 < x; x1++) {
                        if (grid[y][x1] != '.') best_spot = x1 + 1;
                    }
                    if (best_spot != x) {
                        grid[y][best_spot] = 'O';
                        grid[y][x] = '.';
                    }
                }
            }
        }

        // south
        for (int x = 0; x < grid[0].size(); x++) {
            for (int y = grid.size() - 1; y >= 0; y--) {
                if (grid[y][x] == 'O') {
                    int best_spot = grid.size() - 1;
                    for (int y1 = grid.size() - 1; y1 > y; y1--) {
                        if (grid[y1][x] != '.') best_spot = y1 - 1;
                    }
                    if (best_spot != y) {
                        grid[best_spot][x] = 'O';
                        grid[y][x] = '.';
                    }
                }
            }
        }

        // east
        for (int y = 0; y < grid.size(); y++) {
            for (int x = grid[0].size() - 1; x >= 0; x--) {
                if (grid[y][x] == 'O') {
                    int best_spot = grid[0].size() - 1;
                    for (int x1 = grid[0].size() - 1; x1 > x; x1--) {
                        if (grid[y][x1] != '.') best_spot = x1 - 1;
                    }
                    if (best_spot != x) {
                        grid[y][best_spot] = 'O';
                        grid[y][x] = '.';
                    }
                }
            }
        }

    }

    int ans = 0;
    for (int y = 0; y < grid.size(); y++)
        for (int x = 0; x < grid[0].size(); x++)
            if (grid[y][x] == 'O') ans += grid.size() - y;
    cout << ans << endl;

}
