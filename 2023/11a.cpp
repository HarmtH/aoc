#include "lib/prelude.hpp"
#include "lib/point.hpp"

int main(void) {
    vector<string> grid;
    vector<point_t> galaxies;

    for (string line; getline(cin, line);) grid.eb(line);

    const long ys = grid.size(), xs = grid[0].size();
    long dy = 0;
    for (int y = 0; y < ys; y++) {
        long dx = 0;
        if (grid[y].find('#') == -1) dy++;
        for (int x = 0; x < xs; x++) {
            auto no_galaxies_at_x = [x](const auto& l){ return l[x] == '.'; };
            if (r::all_of(grid, no_galaxies_at_x)) dx++;
            if (grid[y][x] == '#') galaxies.pb({y + dy, x + dx});
        }
    }

    long ans = 0;
    for (long i = 0; i < galaxies.size(); i++) {
        for (long j = i; j < galaxies.size(); j++) {
            ans += galaxies[i].dist(galaxies[j]);
        }
    }

    cout << ans << endl;
}
