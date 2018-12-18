#include <vector>
#include <iostream>
using namespace std;

int calculate(vector<int> input) {
    vector<int> data = {3,7};
    int elf0 = 0;
    int elf1 = 1;
    while (true) {
        int sum = data[elf0] + data[elf1];
        if (sum >= 10) {
            data.push_back(1);
            if (data.size() >= input.size() && equal(input.begin(), input.end(), data.end() - input.size()))
                return data.size() - input.size();
        }
        data.push_back(sum % 10);
        if (data.size() >= input.size() && equal(input.begin(), input.end(), data.end() - input.size()))
            return data.size() - input.size();
        elf0 = (elf0 + 1 + data[elf0]) % data.size();
        elf1 = (elf1 + 1 + data[elf1]) % data.size();
    }
}

int main(int argc, char *argv[])
{
    cout << calculate({8,2,4,5,0,1}) << endl;
    return 0;
}
