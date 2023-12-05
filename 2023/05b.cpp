#include <algorithm>
#include <climits>
#include <iostream>
#include <mutex>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

std::mutex lowest_mutex;
long lowest{LONG_MAX};

struct rule_t {
    long src, dst, length;
};

void calc(const std::vector<std::vector<rule_t>>& maps, long start, long length) {
    long thread_lowest;
    for (long seed = start; seed < start + length; seed++) {
        long res{seed};
        for (const auto& map : maps) {
            for (const auto& rule : map) {
                if (res >= rule.src && res < rule.src + rule.length) {
                    res += rule.dst - rule.src;
                    break;
                }
            }
        }
        thread_lowest = std::min(thread_lowest, res);
    }

    lowest_mutex.lock();
    lowest = std::min(lowest, thread_lowest);
    lowest_mutex.unlock();
}

int main (int argc, char *argv[]) {
    std::string line;
    std::vector<std::vector<rule_t>> maps;
    std::vector<long> seeds;

    while (std::getline(std::cin, line)) {
        std::stringstream ss(line);
        std::string word;

        if (!seeds.size()) {
            ss >> word;
            while (ss) {
                long num; ss >> num;
                seeds.push_back(num);
            }
        }

        else if (line == "");

        else if (!std::isdigit(ss.peek())) {
            maps.push_back(std::vector<rule_t>());
        }

        else {
            rule_t rule;
            ss >> rule.dst >> rule.src >> rule.length;
            maps.back().push_back(rule);
        }
    }

    std::vector<std::thread> threads;
    for (long i{0}; i < seeds.size() - 1; i += 2) {
        threads.emplace_back(std::thread(calc, std::ref(maps), seeds[i], seeds[i+1]));
    }
    for (auto& th : threads) 
        th.join();

    std::cout << lowest << std::endl;

    return 0;
}
