#include "lib/prelude.hpp"
#include "lib/point.hpp"

struct vect_t {
    point_t pos;
    point_t dir;
};

int calc(const vector<string>& grid, const vect_t& start) {
    map<point_t, set<point_t>> seen;
    vector<vect_t> q = {{start}};

    while (!q.empty()) {
        const auto [pos, dir] = q.back();
        q.pop_back();

        if (!pos.is_valid(grid.size(), grid[0].size())) continue;

        const auto& c = grid[pos.y][pos.x];

        const auto& [_, inserted] = seen[pos].insert(dir);
        if (!inserted) continue;

        if (c == '|' && (dir == 'E' || dir == 'W')) {
            q.push_back({pos + 'N', 'N'});
            q.push_back({pos + 'S', 'S'});
        } else if (c == '-' && (dir == 'N' || dir == 'S')) {
            q.push_back({pos + 'E', 'E'});
            q.push_back({pos + 'W', 'W'});
        } else if (c == '\\') {
            auto newdir = dir * ((dir == 'N' || dir == 'S') ? 'L' : 'R');
            q.push_back({pos + newdir, newdir});
        } else if (c == '/') {
            auto newdir = dir * ((dir == 'N' || dir == 'S') ? 'R' : 'L');
            q.push_back({pos + newdir, newdir});
        } else {
            q.push_back({pos + dir, dir});
        }
    }
    
    return seen.size();
}

int main(void) {
    vector<string> grid;
    for (string line; getline(cin, line);) grid.eb(line);
    cout << calc(grid, {{0, 0}, 'E'}) << endl;
}
