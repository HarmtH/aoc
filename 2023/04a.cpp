#include <iostream>
#include <set>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    int sum{0};

    std::string line;
    while (std::getline(std::cin, line)) {
        int matches{0};
        std::stringstream ss(line);

        std::string word; int id;
        ss >> word >> id >> word;
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
            if (winning.contains(val)) matches++;
        }

        if (matches) sum += 1 << (matches - 1);
    }

    std::cout << sum << std::endl;

    return 0;
}
