#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    std::map<int, int> sums;
    int id;

    std::string line;
    while (std::getline(std::cin, line)) {
        int matches{0};
        std::stringstream ss(line);

        std::string word;
        ss >> word >> id >> word;
        sums[id]++;

        std::set<int> winning;
        while (true) {
            int val; ss >> val;
            if (ss.fail()) break;
            winning.insert(val);
        }

        ss.clear();
        ss >> word;
        while (true) {
            int val; ss >> val;
            if (ss.fail()) break;
            if (winning.contains(val))
                sums[id + ++matches] += sums[id];
        }
    }

    int sum{0};
    for (int i{0}; i <= id; i++)
        sum += sums[i];

    std::cout << sum << std::endl;

    return 0;
}
