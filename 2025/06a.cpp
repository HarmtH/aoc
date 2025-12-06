#include "lib/prelude.hpp"

int main(void) {
    long ans{0};
    vector<vector<long>> matrix;
    vector<char> ops;
    string line;
    while (getline(cin, line)) {
        stringstream ss{line};
        if (cin.peek() == EOF) {
            for (char op; ss >> op;) ops.eb(op);
        } else {
            auto&& ref = matrix.eb();
            for (int num; ss >> num;) ref.eb(num);
        }
    }
    for (size_t i = 0; i < matrix[0].size(); i++) {
        ans += (ops[i] == '+')
            ? r::fold_left(matrix, 0, [i](long acc, auto&& m){ return acc + m[i]; })
            : r::fold_left(matrix, 1, [i](long acc, auto&& m){ return acc * m[i]; });
    }
    cout << ans << endl;
    return 0;
}
