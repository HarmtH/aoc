#include <iostream>
#include <sstream>
#include <string>
#include <vector>

int main (int argc, char *argv[]) {
    std::string line, word;
    std::stringstream ss;

    std::getline(std::cin, line);
    ss = std::stringstream(line);
    ss >> word;
    std::vector<long> times;
    while (!ss.eof()) {
        long time; ss >> time;
        times.push_back(time);
    }

    std::getline(std::cin, line);
    ss = std::stringstream(line);
    ss >> word;
    std::vector<long> dists;
    while (!ss.eof()) {
        long dist; ss >> dist;
        dists.push_back(dist);
    }

    long ans{1};
    for (long i{0}; i < times.size(); i++) {
        long sum{0};
        for (long v{1}; v < times[i]; v++) {
            long t = times[i] - v;
            if (v * t > dists[i]) sum++;
        }
        ans *= sum;
    }

    std::cout << ans << std::endl;

    return 0;
}
