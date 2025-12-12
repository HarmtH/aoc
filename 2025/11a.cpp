#include "lib/prelude.hpp"

map<string, vector<string>> connections;

int solve(const string& in) {
    if (in == "out") return 1;
    return r::fold_left(connections.at(in) | v::transform(solve), 0, plus{});
}

int main(void) {
    for (string line; getline(cin, line);) {
        stringstream ss{line};
        string in; ss >> in; in.pop_back();
        vector<string> outs; string out;
        while (ss >> out) { outs.eb(out); }
        connections[in] = std::move(outs);
    }
    cout << solve("you") << endl;
    return 0;
}
