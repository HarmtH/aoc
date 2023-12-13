#include "lib/prelude.hpp"

int get_vert_mirror_line(const vector<string>& grid) {
    for (int x = 0; x < grid[0].size() - 1; x++) {
        bool mirror = true;
        for (int d = 0; d < min(x + 1, (int)grid[0].size() - x - 1); d++) {
            for (int y = 0; y < grid.size(); y++) {
                if (grid[y][x + d + 1] != grid[y][x - d]) {
                    mirror = false;
                    break;
                }
            }
        }
        if (mirror) return x;
    }
    return -1;
}

int get_horz_mirror_line(const vector<string>& grid) {
    for (int y = 0; y < grid.size() - 1; y++) {
        bool mirror = true;
        for (int d = 0; d < min(y + 1, (int)grid.size() - y - 1); d++) {
            if (grid[y + d + 1] != grid[y - d]) {
                mirror = false;
                break;
            };
        }
        if (mirror) return y;
    }
    return -1;
} 

int get_score(const vector<string>& grid) {
    return (get_vert_mirror_line(grid) + 1) +
    100 * (get_horz_mirror_line(grid) + 1);
}

int main(void) {
    vector<vector<string>> grids{1};
    for (string line; getline(cin, line);)
        if (line == "") grids.eb();
        else grids.back().eb(line);

    int ans = 0;
    for (auto& grid : grids) {
        ans += get_score(grid);
    }
    cout << ans << endl;
}
