#include "lib/prelude.hpp"

int solve(const string& in, const auto& connections) {
    if (in == "out") return 1;
    int sub_ans{0};
    for (const auto& out : connections.at(in)) {
        sub_ans += solve(out, connections);
    }
    return sub_ans;
}

int main(void) {
    map<string, vector<string>> connections;
    for (string line; getline(cin, line);) {
        stringstream ss{line};
        string in; ss >> in; in.pop_back();
        vector<string> outs; string out;
        while (ss >> out) { outs.eb(out); }
        connections[in] = std::move(outs);
    }
    cout << solve("you", connections) << endl;
    return 0;
}
