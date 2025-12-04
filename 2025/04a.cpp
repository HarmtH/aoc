#include "lib/prelude.hpp"
#include "lib/point.hpp"

int main(void) {
    int ans{0};
    vector<string> grid;
    for (string line; getline(cin, line);) grid.eb(line);
    for (auto y{0}; y < grid.size(); y++) {
        for (auto x{0}; x < grid[y].size(); x++) {
            if (grid[y][x] != '@') continue;
            auto forklift_nbs = Point{y, x}.neighbours_on(grid) | v::filter([&grid](auto& p){ return p.value_on(grid) == '@'; });
            ans += r::distance(forklift_nbs) < 4;
        }
    }
    cout << ans << endl;
    return 0;
}
