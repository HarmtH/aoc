#include "lib/prelude.hpp"

int main(void) {
    long ans{0};
    while (true) {
        if (!cin) break;
        long begin{0}, end{0}; char _;
        cin >> begin >> _ >> end >> _;
        for (long i : v::iota(begin, end + 1)) {
            auto str = to_string(i);
            auto len = str.length();
            if (str == (v::repeat(str.substr(0, len / 2)) | v::take(2) | v::join | r::to<string>())) {
                ans += i;
            }
        }
    }
    cout << ans << endl;
    return 0;
}
