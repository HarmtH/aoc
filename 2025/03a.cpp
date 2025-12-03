#include "lib/prelude.hpp"

int main(void) {
    int ans{0};
    string line;
    while (getline(cin, line)) {
        int h{0}, l{0};
        for (auto const [i, c] : v::enumerate(line)) {
            int v = c - '0';
            if (v > h && i < line.length() - 1)
                h = v, l = 0;
            else if (v > l)
                l = v;
        }
        ans += 10 * h + l;
    }
    cout << ans << endl;
    return 0;
}
