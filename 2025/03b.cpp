#include "lib/prelude.hpp"

int main(void) {
    long ans{0};
    string line;
    while (getline(cin, line)) {
        vector<int> digits(12);
        for (auto const [line_idx, c] : v::enumerate(line)) {
            int v = c - '0';
            for (auto && [digit_idx, d] : v::enumerate(digits)) {
                if (v > d && line_idx < line.length() - digits.size() + digit_idx + 1) {
                    d = v;
                    fill(digits.begin() + digit_idx + 1, digits.end(), 0);
                    break;
                }
            }
        }
        ans += r::fold_left(digits, 0, [](long acc, int d) { return acc * 10 + d; });
    }
    cout << ans << endl;
    return 0;
}
