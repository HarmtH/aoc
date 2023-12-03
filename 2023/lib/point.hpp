#include <map>
#include <iostream>
#include <vector>
#include <climits>
#include <cstdlib>

struct point_t {
    int y = 0;
    int x = 0;

    static const std::map<const char*, const point_t> dirs;

    point_t(const int _y, const int _x) : y{_y}, x{_x} {};
    point_t(const point_t& rhs) : y{rhs.y}, x{rhs.x} {};
    point_t(const char* dir) { *this = dirs.at(dir); };

    int dist(void) const { return abs(y) + abs(x); }
    std::vector<point_t> get_valid_neighbours(int ys, int xs) const {
        std::vector<point_t> neighbours;
        for (const auto& [_, dir] : dirs) {
            auto new_point = *this + dir;
            if (0 <= new_point.y && new_point.y < ys &&
                0 <= new_point.x && new_point.x < xs)
                neighbours.push_back(new_point);
        }
        return neighbours;
    }
    std::vector<point_t> get_neighbours() const {
        return get_valid_neighbours(INT_MAX, INT_MAX);
    }

    point_t operator=(const point_t& rhs) { x=rhs.x; y=rhs.y; return *this; }
    point_t operator+(const point_t& rhs) const { return {y + rhs.y, x + rhs.x}; }
    point_t operator+=(const point_t& rhs) { *this = *this + rhs; return *this; }
    point_t operator-(const point_t& rhs) const { return {y - rhs.y, x - rhs.x}; }
    point_t operator-=(const point_t& rhs) { *this = *this - rhs; return *this; }
    point_t operator*(const char d) const { // rotate point
        if (d == 'R') return {x, -y};
        if (d == 'L') return {-x, y};
        if (d == 'Z') return {-y, -x};
        throw;
    }
    point_t operator*=(const char d) { *this = *this * d; return *this; }
    point_t operator*(const int n) const { return {n * x, n * y}; } // scale point
    point_t operator*=(const int n) { *this = *this * n; return *this; }

    bool operator==(const point_t& rhs) const { return x == rhs.x && y == rhs.y; }
    bool operator<(const point_t& rhs) const {
        return y < rhs.y || (y == rhs.y && x < rhs.x);
    }

    friend std::ostream& operator<<(std::ostream& os, const point_t& rhs) {
        return os << "(" << rhs.y << ", " << rhs.x << ")";
    }
};

inline const std::map<const char*, const point_t>point_t::dirs = {
        {"E", {0,1}}, {"W", {0,-1}}, {"N", {-1,0}}, {"S", {1,0}},
        {"NE", {-1,1}}, {"SE", {1,1}}, {"NW", {-1,-1}}, {"SW", {1,-1}} };
