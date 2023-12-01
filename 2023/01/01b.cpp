#include <cctype>
#include <iostream>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        size_t maxpos{0}, pos, minpos{std::string::npos};
        int first{-1}, last{-1};
        if ((pos = line.find("one")) < minpos) { minpos = pos; first = 1; }
        if ((pos = line.find("two")) < minpos) { minpos = pos; first = 2; }
        if ((pos = line.find("three")) < minpos) { minpos = pos; first = 3; }
        if ((pos = line.find("four")) < minpos) { minpos = pos; first = 4; }
        if ((pos = line.find("five")) < minpos) { minpos = pos; first = 5; }
        if ((pos = line.find("six")) < minpos) { minpos = pos; first = 6; }
        if ((pos = line.find("seven")) < minpos) { minpos = pos; first = 7; }
        if ((pos = line.find("eight")) < minpos) { minpos = pos; first = 8; }
        if ((pos = line.find("nine")) < minpos) { minpos = pos; first = 9; }
        if ((pos = line.rfind("one")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 1; }
        if ((pos = line.rfind("two")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 2; }
        if ((pos = line.rfind("three")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 3; }
        if ((pos = line.rfind("four")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 4; }
        if ((pos = line.rfind("five")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 5; }
        if ((pos = line.rfind("six")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 6; }
        if ((pos = line.rfind("seven")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 7; }
        if ((pos = line.rfind("eight")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 8; }
        if ((pos = line.rfind("nine")) >= maxpos && pos != std::string::npos) { maxpos = pos; last = 9; }
        std::stringstream ss(line);
        size_t i = 0;
        while (!ss.eof()) {
            char c; ss >> c;
            if (std::isdigit(c)) {
                int val = c - '0';
                if (i < minpos) {
                    minpos = i;
                    first = val;
                }
                if (i >= maxpos) {
                    maxpos = i;
                    last = val;
                }
            }
            i++;
        }
        sum += first * 10 + last;
    }
    std::cout << sum << std::endl;
    return 0;
}
