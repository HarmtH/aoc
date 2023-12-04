#include <iostream>
#include <string>
#include <utility>

int main (int argc, char *argv[]) {
    int sum{0};
    std::string line;
    while (std::getline(std::cin, line)) {
        auto first = line[line.find_first_of("0123456789")] - '0';
        auto last = line[line.find_last_of("0123456789")] - '0';
        sum += 10 * first + last;
    }
    std::cout << sum << std::endl;
    return 0;
}
