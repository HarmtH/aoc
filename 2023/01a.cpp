#include <cctype>
#include <iostream>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        std::stringstream ss(line);
        int num{-1};
        int last{-1};
        while (!ss.eof()) {
            char c; ss >> c;
            if (std::isdigit(c)) {
                last = c - '0';
                if (num == -1) num = last * 10;
            }
        }
        num += last;
        sum += num;
    }
    std::cout << sum << std::endl;
    return 0;
}
