#include "lib/prelude.hpp"
#include "lib/point.hpp"

int main (void) {
    long ans{0};
    vector<Point> coords;
    for (string line; getline(cin, line);) {
        stringstream ss{line}; char _;
        auto&& ref{coords.eb()};
        ss >> ref.x >> _ >> ref.y;
    }
    for (auto it{coords.begin()}; it != coords.end() - 1; it++) {
        for (auto it2{it + 1}; it2 != coords.end(); it2++) {
            ans = max(ans, Box::from(*it, *it2).area());
        }
    }
    cout << ans << endl;
    return 0;
}
