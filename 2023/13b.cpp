#include "lib/prelude.hpp"

int get_vert_mirror_line(const vector<string>& grid, int ignore_line = -1) {
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
        if (mirror && x != ignore_line) return x;
    }
    return -1;
}

int get_horz_mirror_line(const vector<string>& grid, int ignore_line = -1) {
    for (int y = 0; y < grid.size() - 1; y++) {
        bool mirror = true;
        for (int d = 0; d < min(y + 1, (int)grid.size() - y - 1); d++) {
            if (grid[y + d + 1] != grid[y - d]) {
                mirror = false;
                break;
            };
        }
        if (mirror && y != ignore_line) return y;
    }
    return -1;
} 

void toggle_grid(vector<string>& grid, int y, int x) {
    if (grid[y][x] == '#')
        grid[y][x] = '.';
    else
        grid[y][x] = '#';
}

int get_score(const vector<string>& grid, int vert_ignore_line = -1, int horz_ignore_line = -1) {
    return (get_vert_mirror_line(grid, vert_ignore_line) + 1) +
    100 * (get_horz_mirror_line(grid, horz_ignore_line) + 1);
}

int get_score_with_smudge(vector<string>& grid) {
    int vert_ignore_line = get_vert_mirror_line(grid);
    int horz_ignore_line = get_horz_mirror_line(grid);
    for (int y = 0; y < grid.size(); y++) {
        for (int x = 0; x < grid[0].size(); x++) {
            toggle_grid(grid, y, x);
            int score = get_score(grid, vert_ignore_line, horz_ignore_line);
            if (score) return score;
            toggle_grid(grid, y, x);
        }
    }
    return 0;
}

int main(void) {
    vector<vector<string>> grids{1};
    for (string line; getline(cin, line);)
        if (line == "") grids.eb();
        else grids.back().eb(line);

    int ans = 0;
    for (auto& grid : grids) {
        ans += get_score_with_smudge(grid);
    }
    cout << ans << endl;
}
