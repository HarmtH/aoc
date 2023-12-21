#include "lib/prelude.hpp"
#include "lib/point.hpp"

void print(const vector<string>& grid, const set<gridpoint_t> seen) {
    for (int y = 0; y < grid.size(); y++) {
        for (int x = 0; x < grid[0].size(); x++) {
            if (seen.contains({y, x, grid})) cout << 'X';
            else cout << grid[y][x];
        }
        cout << endl;
    }
}

/* int main (int argc, char *argv[]) { */
int main() {
    vector<string> grid;
    gridpoint_t start;
    for (string line; getline(cin, line);) {
        if (int pos = line.find('S'); pos != -1) {
            start = {(long)grid.size(), pos};
            line[pos] = '.';
        }
        grid.eb(line);
    }
    start.grid = &grid;
    set<gridpoint_t> seen_even;
    set<gridpoint_t> seen_uneven;
    vector<gridpoint_t> q{{start}};
    for (int steps=0; !q.empty() && steps <= 64; steps++) {
        vector<gridpoint_t> stepq;
        stepq.swap(q);
        for (const auto& p : stepq) {
            /* cout << "at " << steps << " steps, we have: " << p << endl; */

            if (p.val() == '#') continue;

            set<gridpoint_t>& seen = (steps % 2 == 0) ? seen_even : seen_uneven;

            const auto& [_, inserted] = seen.insert(p);
            if (!inserted) continue;

            for (const auto& nb : p.get_valid_neighbours(point_t::STRAIGHT))
                q.eb(nb);
        }
    }

    /* print(grid, seen_even); */

    cout << seen_even.size() << endl;
    /* cout << seen_uneven.size() << endl; */
}
