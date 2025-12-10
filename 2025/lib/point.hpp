#include <algorithm>
#include <climits>
#include <cmath>
#include <cstdlib>
#include <iostream>
#include <map>
#include <vector>

struct Point;

struct Box {
    long ymin = 0, ymax = 0, xmin = 0, xmax = 0;

    static const Box inf;

    template<class T> static Box from(const T& grid) {
        return { .ymin = 0, .ymax = static_cast<long>(grid.size()) - 1,
            .xmin = 0, .xmax = static_cast<long>(grid[0].size()) - 1 };
    };

    static Box from(const Point& p1, const Point& p2);

    bool is_overlaps(const Box& rhs) {
        return xmax >= rhs.xmin && xmin <= rhs.xmax && ymax >= rhs.ymin && ymin <= rhs.ymax;
    }

    void grow(long val = 1) {
        xmin -= val; xmax += val; ymin -= val; ymax += val;
    }

    void shrink(long val = 1) {
        grow(-val);
    }

    long area() {
        return (xmax - xmin + 1) * (ymax - ymin + 1);
    }
};

inline const Box Box::inf = Box{ .ymin = LONG_MIN, .ymax = LONG_MAX, .xmin = LONG_MIN, .xmax = LONG_MAX };

struct Point {
    long y, x;
    enum nb_dir_t { STRAIGHT, ALL };
    static const std::map<std::string, const Point> dirs;
    static const std::map<std::string, const Point> straight_dirs;

    Point() : y{0}, x{0} {};
    Point(const long _y, const long _x) : y{_y}, x{_x} {};
    Point(const Point& rhs) : y{rhs.y}, x{rhs.x} {};
    Point(const std::string& dir) { *this = dirs.at(dir); };
    Point(const char* dir) { *this = dirs.at(dir); };
    Point(const char dir) { *this = dirs.at(std::string{dir}); };

    bool is_valid(const Box &box) const { return box.ymin <= y && y <= box.ymax && box.xmin <= x && x <= box.xmax; }
    long mdist(void) const { return labs(y) + labs(x); }
    double edist(void) const { return sqrt(y * y + x * x); }
    long mdist(const Point& rhs) const { return labs(y - rhs.y) + labs(x - rhs.x); }
    double edist(const Point& rhs) const {
        long _y = y - rhs.y, _x = x - rhs.x;
        return sqrt(_y * _y + _x * _x);
    }
    std::vector<Point> neighbours(const Box &box, nb_dir_t nb_dir = ALL) const {
        std::vector<Point> neighbours;
        for (const auto& [_, dir] : (nb_dir == STRAIGHT ? straight_dirs : dirs)) {
            auto new_point = *this + dir;
            if (new_point.is_valid(box)) neighbours.emplace_back(std::move(new_point));
        }
        return neighbours;
    }

    template <class T> bool is_valid_on(const T& grid) const { return is_valid(Box::from(grid)); }
    template <class T> std::vector<Point> neighbours_on(const T& grid, nb_dir_t nb_dir = ALL) const {
        return neighbours(Box::from(grid), nb_dir);
    }
    template<class T> auto value_on(const T& grid) {
        return grid.at(y).at(x);
    }

    Point operator=(const Point& rhs) { y=rhs.y; x=rhs.x; return *this; }
    Point operator+(const Point& rhs) const { return {y + rhs.y, x + rhs.x}; }
    Point operator+=(const Point& rhs) { *this = *this + rhs; return *this; }
    Point operator-(const Point& rhs) const { return {y - rhs.y, x - rhs.x}; }
    Point operator-=(const Point& rhs) { *this = *this - rhs; return *this; }
    Point operator*(const char d) const { // rotate point
        if (d == 'R') return {x, -y};
        if (d == 'L') return {-x, y};
        if (d == 'Z') return {-y, -x};
        throw;
    }
    Point operator*=(const char d) { *this = *this * d; return *this; }
    Point operator*(const long n) const { return {n * y, n * x}; } // scale point
    Point operator*=(const long n) { *this = *this * n; return *this; }

    bool operator==(const Point& rhs) const { return y == rhs.y && x == rhs.x; }
    bool operator<(const Point& rhs) const {
        return y < rhs.y || (y == rhs.y && x < rhs.x);
    }

    friend std::ostream& operator<<(std::ostream& os, const Point& rhs) {
        return os << "(" << rhs.y << ", " << rhs.x << ")";
    }
};

inline const std::map<std::string , const Point>Point::dirs = {
        {"E", {0,1}}, {"W", {0,-1}}, {"N", {-1,0}}, {"S", {1,0}},
        {"NE", {-1,1}}, {"SE", {1,1}}, {"NW", {-1,-1}}, {"SW", {1,-1}} };

inline const std::map<std::string, const Point>Point::straight_dirs =
    {{"N", {-1,0}}, {"E", {0,1}}, {"S", {1,0}}, {"W", {0,-1}}};

Box Box::from(const Point& p1, const Point& p2) {
    return { .ymin = std::min(p1.y, p2.y), .ymax = std::max(p1.y, p2.y),
        .xmin = std::min(p1.x, p2.x), .xmax = std::max(p1.x, p2.x) };
};
