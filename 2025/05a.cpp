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
    for (long id; cin >> id;) {
        ans += r::any_of(ranges, [id](auto range){
            return range.fi <= id && id <= range.se;
        });
    }
    cout << ans << endl;
    return 0;
}
