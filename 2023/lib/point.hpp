#include <climits>
#include <cstdlib>
#include <iostream>
#include <map>
#include <vector>

struct point_t {
    long y;
    long x;
    enum nb_dir_t { STRAIGHT, ALL };
    static const std::map<std::string, const point_t> dirs;
    static const std::map<std::string, const point_t> straight_dirs;

    point_t() : y{0}, x{0} {};
    point_t(const long _y, const long _x) : y{_y}, x{_x} {};
    point_t(const point_t& rhs) : y{rhs.y}, x{rhs.x} {};
    point_t(const std::string& dir) { *this = dirs.at(dir); };
    point_t(const char* dir) { *this = dirs.at(dir); };
    point_t(const char dir) { *this = dirs.at(std::string{dir}); };

    bool is_valid(long ys, long xs) const { return 0 <= y && y < ys && 0 <= x && x < xs; }
    template<class T> bool is_valid(const T& grid) const { return 0 <= y && y < grid.size() && 0 <= x && x < grid[0].size(); }
    long dist(void) const { return labs(y) + labs(x); }
    long dist(const point_t& rhs) const { return labs(y - rhs.y) + labs(x - rhs.x); }
    std::vector<point_t> get_valid_neighbours(long ys, long xs, nb_dir_t nb_dir = ALL) const {
        std::vector<point_t> neighbours;
        for (const auto& [_, dir] : (nb_dir == STRAIGHT ? straight_dirs : dirs)) {
            auto new_point = *this + dir;
            if (new_point.is_valid(ys, xs)) neighbours.emplace_back(std::move(new_point));
        }
        return neighbours;
    }
    template<class T> std::vector<point_t> get_valid_neighbours(const T& grid, nb_dir_t nb_dir = ALL) const {
        return get_valid_neighbours(grid.size(), grid[0].size(), nb_dir);
    }
    std::vector<point_t> get_neighbours(nb_dir_t nb_dir = ALL) const {
        return get_valid_neighbours(INT_MAX, INT_MAX, nb_dir);
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
    point_t operator*(const long n) const { return {n * x, n * y}; } // scale point
    point_t operator*=(const long n) { *this = *this * n; return *this; }

    bool operator==(const point_t& rhs) const { return x == rhs.x && y == rhs.y; }
    bool operator<(const point_t& rhs) const {
        return y < rhs.y || (y == rhs.y && x < rhs.x);
    }

    friend std::ostream& operator<<(std::ostream& os, const point_t& rhs) {
        return os << "(" << rhs.y << ", " << rhs.x << ")";
    }
};

inline const std::map<std::string , const point_t>point_t::dirs = {
        {"E", {0,1}}, {"W", {0,-1}}, {"N", {-1,0}}, {"S", {1,0}},
        {"NE", {-1,1}}, {"SE", {1,1}}, {"NW", {-1,-1}}, {"SW", {1,-1}} };

inline const std::map<std::string, const point_t>point_t::straight_dirs =
    {{"N", {-1,0}}, {"E", {0,1}}, {"S", {1,0}}, {"W", {0,-1}}};
