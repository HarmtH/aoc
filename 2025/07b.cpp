#include "lib/prelude.hpp"
#include "lib/point.hpp"

int main(void) {
    long ans{0};
    vector<string> grid;
    for (string line; getline(cin, line);) grid.eb(line);
    Point s{0, (long)grid[0].find('S')};
    set<Point> beams{s};
    map<Point, long> p2tl{{s, 1}};
    while ((*(beams.begin()) + "S").is_valid_on(grid)) {
        set<Point> new_beams;
        for (const auto& beam : beams) {
            auto dirs = ((beam + "S").value_on(grid) == '^') ? vector<string>{"SW", "SE"} : vector<string>{"S"};
            for (const auto& dir: dirs) p2tl[*new_beams.insert(beam + dir).fi] += p2tl[beam];
        }
        beams = std::move(new_beams);
    }
    for (const auto& beam : beams) ans += p2tl[beam];
    cout << ans << endl;
    return 0;
}
