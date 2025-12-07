#include "lib/prelude.hpp"
#include "lib/point.hpp"

int main(void) {
    long ans{0};
    vector<string> grid;
    for (string line; getline(cin, line);) grid.eb(line);
    set<Point> beams = {{0, (long)grid[0].find('S')}};
    while ((*(beams.begin()) + "S").is_valid_on(grid)) {
        set<Point> new_beams;
        for (const auto& beam : beams) {
            if ((beam + "S").value_on(grid) == '^') {
                new_beams.insert({beam + "SW", beam + "SE"});
                ans++;
            } else {
                new_beams.insert(beam + "S");
            }
        }
        beams = std::move(new_beams);
    }
    cout << ans << endl;
    return 0;
}
