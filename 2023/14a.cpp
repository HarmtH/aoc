#include "lib/prelude.hpp"

int main(void) {
    vector<string> grid;
    for (string line; getline(cin, line);) grid.eb(line);
    vector<int> cubes_in_columns(grid[0].size());
    int ans = 0;

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
                ans += (grid.size() - best_spot);
            }
        }
    }

    for (auto line : grid) cout << line << endl;
    cout << ans << endl;
}
