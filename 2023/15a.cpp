#include "lib/prelude.hpp"

int main(void) {
    char c;
    int ans = 0, hash = 0;
    while (cin >> c) {
        if (c == ',') {
            ans += hash;
            hash = 0;
        } else {
            hash += c;
            hash *= 17;
            hash %= 256;
        }
    }
    ans += hash;
    cout << ans << endl;
}
