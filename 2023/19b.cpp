#include "lib/prelude.hpp"

using part_t = map<char, array<int, 2>>;

struct rule_t {
    char cat;
    char op;
    int val;
    string target;
};

using workflow_t = vector<rule_t>;

long calc(const map<string, workflow_t>& workflows, const part_t& part, const string& src) {
    if (src == "A") {
        return (part.at('x')[1] - part.at('x')[0] + 1L) *
               (part.at('m')[1] - part.at('m')[0] + 1L) *
               (part.at('a')[1] - part.at('a')[0] + 1L) *
               (part.at('s')[1] - part.at('s')[0] + 1L);
    } else if (src == "R") {
        return 0;
    }

    part_t p1 = part, p2; // p2 = split off, p1 continues through the rules
    long ans = 0;
    for (const auto& [cat, op, val, target] : workflows.at(src)) {
        if (op == 't') {
            ans += calc(workflows, p1, target);
            break;
        } else if (op == '<') {
            if (p1.at(cat)[1] < val) {
                ans += calc(workflows, p1, target);
                break;
            } else if (p1.at(cat)[0] < val) {
                p2 = p1;
                p2.at(cat)[1] = val - 1;
                ans += calc(workflows, p2, target);
                p1.at(cat)[0] = val;
            }
        } else if (op == '>') {
            if (p1.at(cat)[0] > val) {
                ans += calc(workflows, p1, target);
                break;
            } else if (p1.at(cat)[1] > val) {
                p2 = p1;
                p2.at(cat)[0] = val + 1;
                ans += calc(workflows, p2, target);
                p1.at(cat)[1] = val;
            }
        } else throw;
    }

    return ans;
}

int main(void) {
    map<string, workflow_t> workflows;

    string line;
    while (true) {
        getline(cin, line);
        if (line == "") break;

        line.pop_back();
        stringstream ss(line);

        int pos = ss.str().find('{');
        string src = line.substr(0, pos);
        ss.ignore(pos + 1);

        string srule;
        while (getline(ss, srule, ',')) {
            stringstream ss(srule);
            auto& rule = workflows[src].eb();

            if (srule.find(':') != -1) {
                ss >> rule.cat;
                ss >> rule.op;
                ss >> rule.val;
                ss.ignore();
            } else {
                rule.op = 't';
            }

            ss >> rule.target;
        }
    }

    part_t part{{'x', {1, 4000}},
                {'m', {1, 4000}},
                {'a', {1, 4000}},
                {'s', {1, 4000}}};
    cout << calc(workflows, part, "in") << endl; 
}
