#include "lib/prelude.hpp"

using part_t = map<char, int>;

struct rule_t {
    function<bool(const part_t&)> cond;
    string target;
};

using workflow_t = vector<rule_t>;

int main(void) {
    map<string, workflow_t> workflows;
    for (string line; getline(cin, line) && line != "";) {
        int pos = line.find('{');
        string src = line.substr(0, pos);
        
        string srules = line.substr(pos + 1);
        srules.pop_back();
        stringstream ssrules(srules);
        for (string srule; getline(ssrules, srule, ',');) {
            stringstream ssrule(srule);
            auto& rule = workflows[src].eb();

            if (srule.find(':') != -1) {
                char cat; ssrule >> cat;
                char op; ssrule >> op;
                int val; ssrule >> val;
                ssrule.ignore();

                if (op == '<')
                    rule.cond = [cat, val](const part_t& part) {
                        return part.at(cat) < val;
                    };
                else if (op == '>')
                    rule.cond = [cat, val](const part_t& part) {
                        return part.at(cat) > val;
                    };
                else throw;
            } else {
                rule.cond = [](auto) { return true; };
            }

            ssrule >> rule.target;
        }
    }

    vector<part_t> parts;
    for (string line; getline(cin, line);) {
        auto& part = parts.eb();

        stringstream ss(line);
        ss.ignore(3); ss >> part['x'];
        ss.ignore(3); ss >> part['m'];
        ss.ignore(3); ss >> part['a'];
        ss.ignore(3); ss >> part['s'];
    }

    int ans = 0;
    for (const auto& part: parts) {
        string target = "in";
        while (target != "A" && target != "R") {
            for (const auto& [cond, new_target] : workflows.at(target)) {
                target = new_target;
                if (cond(part)) break;
            }
        }
        if (target == "A") ans += part.at('x') +
                                  part.at('m') +
                                  part.at('a') +
                                  part.at('s');
    }
    cout << ans << endl;
}
