#include "lib/prelude.hpp"

map<string, vector<string>> connections;
map<pair<string, char>, long> cache;

long solve(const string& in, char visits = {}) {
    if (cache.contains({in, visits})) return cache[{in, visits}];
    if (in == "out") return (visits == 0b11);
    if (in == "dac") visits |= 0b01;
    if (in == "fft") visits |= 0b10;
    return cache[{in, visits}] = r::fold_left(connections.at(in) | v::transform(bind(solve, _1, visits)), 0, plus{});
}

int main(void) {
    for (string line; getline(cin, line);) {
        stringstream ss{line};
        string in; ss >> in; in.pop_back();
        vector<string> outs; string out;
        while (ss >> out) outs.eb(out);
        connections[in] = std::move(outs);
    }
    cout << solve("svr") << endl;
    return 0;
}
