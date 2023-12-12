#include "lib/prelude.hpp"

using line_t = pair<string, vector<int>>;

map<line_t, long> lut;
long solve(line_t line) {
    if (lut.contains(line)) return lut[line];

    auto [record, groups] = line;
    long subans = 0;

    if (groups.empty()) return record.find('#') == -1;

    if (groups.back() > record.length()) return 0;

    if (record.back() == '.') {
        return solve({record.substr(0, record.length() - 1), groups});
    }

    if (record.back() == '?') {
        subans += solve({record.substr(0, record.length() - 1), groups});
    }

    if (record.find('.', record.length() - groups.back()) != -1) return subans;
    record.erase(record.length() - groups.back());
    if (!record.empty()) {
        if (record.back() == '#') return subans;
        record.pop_back();
    }
    groups.pop_back();

    return lut[line] = subans + solve({record, groups});
}

int main(void) {
    long ans = 0;

    for (string line; getline(cin, line);) {
        stringstream ss(line);
        string record; vector<int> groups;
        ss >> record;
        for (int num; ss >> num;) { groups.eb(num); ss.ignore(); }

        string new_record; vector<int> new_groups;
        for (int i = 0; i < 5; i++ ) {
            new_record += record + "?";
            new_groups.insert(new_groups.end(), groups.begin(), groups.end());
        }
        new_record.pop_back();
        record = new_record; groups = new_groups;

        lut.clear();
        ans += solve({record, groups});
    }

    cout << ans << endl;
}
