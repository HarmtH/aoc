#include "lib/prelude.hpp"
#include "lib/point.hpp"

int main (void) {
    vector<Point> coords;
    for (string line; getline(cin, line);) {
        stringstream ss{line}; char _;
        auto&& ref{coords.eb()};
        ss >> ref.x >> _ >> ref.y;
    }
    vector<tuple<long, Point, Point>> sizes;
    vector<Box> segments;
    for (auto it{coords.begin()}; it != coords.end() - 1; it++) {
        for (auto it2{it + 1}; it2 != coords.end(); it2++) {
            sizes.eb(Box::from(*it, *it2).area(), *it, *it2);
        }
        segments.eb(Box::from(*it, *(it + 1)));
    }
    segments.eb(Box::from(coords.back(), coords[0]));
    r::sort(sizes, greater());
    for (const auto& [size, p1, p2] : sizes) {
        Box box = Box::from(p1, p2);
        box.shrink();
        if (r::none_of(segments, [&box](const auto& segment){ return box.is_overlaps(segment); })) {
            cout << size << endl;
            break;
        }
    }
    return 0;
}
