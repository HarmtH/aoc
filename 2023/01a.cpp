#include <cctype>
#include <iostream>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        auto first_pos = line.find_first_of("0123456789");
        auto last_pos = line.find_last_of("0123456789");
        sum += line[first_pos] * 10 + line[last_pos];
    }
    std::cout << sum << std::endl;
    return 0;
}
