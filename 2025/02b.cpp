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
            for (auto div : v::iota(2u, len + 1) | v::filter([len](auto div) { return len % div == 0; })) {
                if (str == (v::repeat(str.substr(0, len / div)) | v::take(div) | v::join | r::to<string>())) {
                    ans += i;
                    break;
                }
            }
        }
    }
    cout << ans << endl;
    return 0;
}
