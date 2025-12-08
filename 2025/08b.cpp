#include "lib/prelude.hpp"
#include "lib/point3d.hpp"

int main (void) {
    vector<Point3d> coords;
    for (string line; getline(cin, line);) {
        stringstream ss{line}; char _;
        auto&& ref = coords.eb();
        ss >> ref.x >> _ >> ref.y >> _ >> ref.z;
    }
    vector<vector<Point3d>> circuits;
    vector<tuple<int, Point3d, Point3d>> distances;
    for (auto it = coords.begin(); it != coords.end() - 1; it++) {
        for (auto it2 = it + 1; it2 != coords.end(); it2++) {
            distances.eb(it->edist(*it2), *it, *it2);
        }
    }
    r::sort(distances);
    for (const auto& distance : distances) {
        const auto& [_, p1, p2] = distance;
        vector<Point3d> new_circuit;
        for (const auto& p : vector{p1, p2}) {
            // find circuit containg p
            auto circuit_it = r::find_if(circuits, [p](auto& circuit){ return r::find(circuit, p) != circuit.end();} );
            if (circuit_it != circuits.end()) {
                new_circuit.insert(new_circuit.end(), circuit_it->begin(), circuit_it->end());
                circuits.erase(circuit_it);
            } else if (r::find(new_circuit, p) == new_circuit.end()) {
                new_circuit.eb(p);
            }
        }
        circuits.eb(std::move(new_circuit));
        if (circuits.back().size() == coords.size()) {
            cout << p1.x * p2.x << endl;
            break;
        }
    }
    return 0;
}
