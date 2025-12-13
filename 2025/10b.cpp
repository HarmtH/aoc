// compile with make LDLIBS=-lglpk 10b

#include "lib/prelude.hpp"
#include <glpk.h>

// we need to solve Ax = b, with
// b = column vector with joltage requirements,
// x = column vector with button presses,
// A = (binary) matrix, where each column represents a button, and each row a counter,
//     and a 1 means the counter increases by 1 on a button press
int glpk_solve(const vector<vector<int>>& schematic, const vector<int>& joltages) {
    glp_prob *lp = glp_create_prob();
    glp_set_obj_dir(lp, GLP_MIN);
    glp_add_cols(lp, schematic.size());
    glp_add_rows(lp, joltages.size());
    const vector<double> ones(joltages.size() + 1, 1); // each counter increases by 1 on a press

    for (auto i : v::iota(0u, schematic.size())) {
        glp_set_col_bnds(lp, i + 1, GLP_LO, 0, 0); // button presses are always positive
        glp_set_col_kind(lp, i + 1, GLP_IV); // mark columns as integer
        glp_set_obj_coef(lp, i + 1, 1); // each button has the same weight for minimisation
        vector<int> glp_schema{0}; // glpk start reading from element with index 1
        for (auto button : schematic[i]) glp_schema.eb(button + 1); // and also all button indices should be offset by 1
        glp_set_mat_col(lp, i + 1, schematic[i].size(), glp_schema.data(), ones.data()); // set the counters which increase on button press
    }

    for (auto i : v::iota(0u, joltages.size())) {
        glp_set_row_bnds(lp, i + 1, GLP_FX, joltages[i], 0); // set joltage requirement
    }

    // Only show error messages when solving
    glp_smcp smcp;
    glp_init_smcp(&smcp);
    smcp.msg_lev = GLP_MSG_ERR;
    glp_iocp iocp;
    glp_init_iocp(&iocp);
    iocp.msg_lev = GLP_MSG_ERR;

    // Solve the LP + INT problem
    glp_simplex(lp, &smcp);
    glp_intopt(lp, &iocp);

    auto res = glp_mip_obj_val(lp);

    // Cleanup
    glp_delete_prob(lp);

    return res;
}

int main (void) {
    long ans{0};
    for (string line; getline(cin, line);) {
        stringstream ss{line}; char tok; optional<int> num;
        vector<vector<int>> schematic;
        vector<int> joltages;
        vector<int> v;
        while (ss >> tok) {
            if (tok >= '0' && tok <= '9') {
                num = (num.value_or(0) * 10 + tok - '0');
            } else if (num) {
                v.eb(num.value());
                num.reset();
            }

            if (tok == ')') {
                schematic.eb(v);
                v.clear();
            } else if (tok == '}') {
                joltages = v;
                v.clear();
            }

        }
        ans += glpk_solve(schematic, joltages);
    }
    cout << ans << endl;
    return 0;
}
