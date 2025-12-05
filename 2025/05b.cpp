#include "lib/prelude.hpp"

int main(void) {
    long ans{0};
    vector<pll> ranges;
    string line;
    while (getline(cin, line)) {
        if (line == "") break;
        stringstream ss{line};
        long b, e; char _; ss >> b >> _ >> e;
        ranges.pb({b, e});
    }
    vector<pll> new_ranges;
    for (auto it = ranges.begin(); it != ranges.end(); it++) {
        bool consumed = false;
        for (auto it2 = it + 1; it2 != ranges.end(); it2++) {
            if (it->fi <= it2->fi && it->se >= it2->fi) {
                it2->fi = it->fi;
                consumed = true;
            }
            if (it->se >= it2->se && it->fi <= it2->se) {
                it2->se = it->se;
                consumed = true;
            }
            if (it->fi >= it2->fi && it->se <= it2->se) {
                consumed = true;
            }
        }
        if (!consumed) new_ranges.eb(*it);
    }
    for (auto range : new_ranges) ans += range.se - range.fi + 1;
    cout << ans << endl;
    return 0;
}
