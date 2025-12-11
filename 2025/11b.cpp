#include "lib/prelude.hpp"

long solve(const string& in, const auto& connections, char visits = {}, map<pair<string, char>, long>&& cache = {}) {
    if (auto cached_ans = cache.find({in, visits}); cached_ans != cache.end())
        return cached_ans->se;
    if (in == "out")
        return (visits == 0b11) ? 1 : 0;
    if (in == "dac")
        visits |= 0b01;
    if (in == "fft")
        visits |= 0b10;
    long sub_ans{0};
    for (const auto& out : connections.at(in)) {
        // std::forward looks so smart
        sub_ans += solve(out, connections, visits, std::forward<decltype(cache)>(cache));
    }
    cache[{in, visits}] = sub_ans;
    return sub_ans;
}

int main(void) {
    map<string, vector<string>> connections;
    for (string line; getline(cin, line);) {
        stringstream ss{line};
        string in; ss >> in; in.pop_back();
        vector<string> outs; string out;
        while (ss >> out) outs.eb(out);
        connections[in] = std::move(outs);
    }
    cout << solve("svr", connections) << endl;
    return 0;
}
