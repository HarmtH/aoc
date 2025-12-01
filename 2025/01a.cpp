#include "lib/prelude.hpp"

int main(void) {
    int dial{50}, password{0};
    string line;
    while (getline(cin, line)) {
        line[0] = (line[0] == 'R') ? '+' : '-';
        int clicks = stoi(line);

        dial = (dial + clicks) % 100;
        if (!dial) password++;
    }
    cout << password << endl;
    return 0;
}
