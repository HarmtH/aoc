#include "lib/prelude.hpp"

using line_t = pair<int, int>;

long solve(line_t line, vector<long>& lut, const string& record, const vector<int>& groups) {
    auto [rl, gl] = line; // record length, group length
    int index = rl * 64 + gl;
    if (lut[index] != -1) return lut[index];
    long subans = 0;

    if (gl == 0) return record.find('#') >= rl;

    if (groups[gl - 1] > rl) return 0;

    if (record[rl - 1] == '.') {
        return solve({rl - 1, gl}, lut, record, groups);
    }

    if (record[rl - 1] == '?') {
        subans += solve({rl - 1, gl}, lut, record, groups);
    }

    if (record.find('.', rl - groups[gl - 1]) < rl) return subans;
    rl -= groups[gl - 1];
    if (rl != 0) {
        if (record[rl - 1] == '#') return subans;
        rl--;
    }
    gl--;

    return lut[index] = subans + solve({rl, gl}, lut, record, groups);
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

        vector<long> lut(128 * 64, -1);
        ans += solve({record.size(), groups.size()}, lut, record, groups);
    }

    cout << ans << endl;
}
