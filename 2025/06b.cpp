#include "lib/prelude.hpp"

int main(void) {
    long ans{0};
    vector<string> ws;
    for (string line; getline(cin, line);) ws.eb(line + " ");
    function<long(long, long)> op;
    long subans{-1}; // -1 = initialise new sum/product

    for (size_t i = 0; i < ws[0].size(); i++) {
        long num{0};
        for (size_t j = 0; j < ws.size() - 1; j++) {
            char d = ws[j][i];
            if (d == ' ') continue;
            num = 10 * num + (d - '0');
        }
        if (subans == -1) {
            if (ws.back()[i] == '+') {
              subans = 0;
              op = plus<long>();
            } else {
              subans = 1;
              op = multiplies<long>();
            }
        }
        if (num) {
            subans = op(subans, num);
        } else {
            ans += subans;
            subans = -1;
        }
    }
    cout << ans << endl;
    return 0;
}
