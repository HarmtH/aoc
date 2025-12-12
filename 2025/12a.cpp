#include "lib/prelude.hpp"
#include "lib/point3d.hpp"

int main (void) {
    long ans{0};
    vector<vector<string>> shapes;
    vector<pair<vector<int>, vector<int>>> problems;
    map<int, int> shape2hashes;
    const int shape_length = 3;
    for (string line; getline(cin, line);) {
        if (line[1] == ':') {
            shapes.eb();
        } else if (line[0] == '#' || line[0] == '.') {
            shapes.back().eb(line);
            shape2hashes[shapes.size() - 1] += r::count(line, '#');
        } else if (line.find('x') != string::npos) {
            int d; char _;
            stringstream ss{line};
            auto&& ref = problems.eb();
            ss >> d >> _; ref.fi.eb(d); 
            ss >> d >> _; ref.fi.eb(d);
            while(ss >> d) ref.se.eb(d);
        }
    }
    for (const auto& problem: problems) {
        auto grid_size = problem.fi[0] * problem.fi[1];
        auto easy_place_boxes = (problem.fi[0] / shape_length) * (problem.fi[1] / shape_length);
        auto min_size_needed =
            r::fold_left(v::enumerate(problem.se) |
                         v::transform([&shape2hashes](const auto&& p) {
                             const auto& [i, n] = p; return n * shape2hashes.at(i);
                         }), 0, plus{});
        auto boxes = r::fold_left(problem.se, 0, plus{});
        if (easy_place_boxes >= boxes) {
            ans++;
        } else if (min_size_needed <= grid_size) {
            cout << "not even going to try..." << endl;
            ans = -1;
            break;
        }
    }
    cout << ans << endl;
    return 0;
}
