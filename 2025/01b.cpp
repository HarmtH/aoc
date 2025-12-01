#include "lib/prelude.hpp"

int main(void) {
    int dial{50}, password{0};
    string line;
    while (getline(cin, line)) {
        line[0] = (line[0] == 'R') ? '+' : '-';
        int clicks = stoi(line);

        if (dial && dial + clicks <= 0) password++;
        dial += clicks;
        password += abs(dial) / 100;
        dial = (dial % 100 + 100) % 100;
    }
    cout << password << endl;
    return 0;
}
