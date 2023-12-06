#include <iostream>
#include <sstream>
#include <string>

int main (int argc, char *argv[]) {
    std::string line, word, stime, sdist;
    std::stringstream ss;

    std::getline(std::cin, line);
    ss = std::stringstream(line);
    ss >> word;
    while (!ss.eof()) {
        ss >> word;
        stime += word;
    }
    long time = std::stol(stime);

    std::getline(std::cin, line);
    ss = std::stringstream(line);
    ss >> word;
    while (!ss.eof()) {
        ss >> word;
        sdist += word;
    }
    long dist = std::stol(sdist);

    long sum{0};
    for (long v{1}; v < time; v++) {
        long t = time - v;
        if (v * t > dist) sum++;
    }

    std::cout << sum << std::endl;

    return 0;
}
