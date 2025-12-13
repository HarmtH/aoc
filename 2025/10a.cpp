#include "lib/prelude.hpp"

// bit twiddling function which loops through all c-bits wide options with k bits set
template<int size> vector<bitset<size>> combo(int c, int k)
{
    vector<bitset<size>> ret;
    unsigned int combo = (1 << k) - 1;
    while (combo < 1<<c) {
        ret.eb(combo);
        unsigned int x = combo & -combo;
        unsigned int y = combo + x;
        unsigned int z = (combo & ~y);
        combo = z / x;
        combo >>= 1;
        combo |= y;
    }
    return ret;
}

int main (void) {
    long ans{0};
    for (string line; getline(cin, line);) {
        stringstream ss{line}; char tok; optional<int> num;
        vector<char> diagram;
        vector<vector<int>> schematic;
        vector<int> v;
        while (ss >> tok) {
            if (tok >= '0' && tok <= '9') {
                num = (num.value_or(0) * 10 + tok - '0');
            } else if (num) {
                v.eb(num.value());
                num.reset();
            }

            if (tok == '.' || tok == '#') {
                diagram.eb(tok);
            } else if (tok == ')') {
                schematic.eb(v);
                v.clear();
            }
        }
        for (auto i : v::iota(1u, schematic.size() + 1)) {
            for (auto option: combo<16>(schematic.size(), i)) {
                vector<char> state(diagram.size(), '.');

                for (auto j : v::iota(0u, schematic.size()))
                    if (option.test(j))
                        for (auto val: schematic[j])
                            state[val] = (state[val] == '.' ? '#' : '.');

                if (state == diagram) {
                    ans += i;
                    goto next;
                }
            }
        }
        throw("didn't find a solution");
    next:
    }
    cout << ans << endl;
    return 0;
}
