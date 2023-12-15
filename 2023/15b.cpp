#include "lib/prelude.hpp"

struct entry_t {
    string name;
    int fl; // focal length
};

int main(void) {

    char c;
    vector<vector<entry_t>> hashmap(256);
    int hash = 0;
    string name;
    while (cin >> c) {
        if (c == ',') {
            hash = 0;
            name = "";
        } else if (c == '=') {
            int focal_length; cin >> focal_length;
            auto& bucket = hashmap[hash];
            const auto& it = r::find_if(bucket, [name](const auto& entry){
                return name == entry.name; });
            if (it != bucket.end()) {
                it->fl = focal_length;
            } else {
                bucket.pb({name, focal_length});
            }
        } else if (c == '-') { // add entry
            erase_if(hashmap[hash], [name](const auto& entry){
                return name == entry.name; });
        } else {
            name += c;
            hash += c;
            hash *= 17;
            hash %= 256;
        }
    }

    int ans = 0;
    for (int i = 0; i < hashmap.size(); i++) {
        for (int j = 0; j < hashmap[i].size(); j++) {
            ans += (i + 1) * (j + 1) * hashmap[i][j].fl;
        }
    }

    cout << ans << endl;

}
