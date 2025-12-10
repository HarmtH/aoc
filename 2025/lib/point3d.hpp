#include <climits>
#include <cmath>
#include <cstdlib>
#include <iostream>

struct Box3d {
    long zmin = 0, zmax = 0, ymin = 0, ymax = 0, xmin = 0, xmax = 0;

    static const Box3d inf;

    template<class T> static Box3d from(const T& grid) {
        return {
            .zmin = 0, .zmax = static_cast<long>(grid.size()) - 1,
            .ymin = 0, .ymax = static_cast<long>(grid[0].size()) - 1,
            .xmin = 0, .xmax = static_cast<long>(grid[0][0].size()) - 1};
    };
};

inline const Box3d Box3d::inf = Box3d{ .zmin = LONG_MIN, .zmax = LONG_MAX, .ymin = LONG_MIN, .ymax = LONG_MAX, .xmin = LONG_MIN, .xmax = LONG_MAX };

struct Point3d {
    long z, y, x;
    enum nb_dir_t { STRAIGHT, ALL };
    // static const std::map<std::string, const Point3d> dirs;
    // static const std::map<std::string, const Point3d> straight_dirs;

    Point3d() : z{0}, y{0}, x{0} {};
    Point3d(const long _z, const long _y, const long _x) : z{_z}, y{_y}, x{_x} {};
    Point3d(const Point3d& rhs) : z{rhs.z}, y{rhs.y}, x{rhs.x} {};

    // bool is_valid(const Box &box) const { return box.ymin <= y && y <= box.ymax && box.xmin <= x && x <= box.xmax; }
    long mdist(void) const { return labs(z) + labs(y) + labs(x); }
    double edist(void) const { return sqrt(z * z + y * y + x * x); }
    long mdist(const Point3d& rhs) const { return labs(z - rhs.z) + labs(y - rhs.y) + labs(x - rhs.x); }
    double edist(const Point3d& rhs) const {
        long _z = z - rhs.z, _y = y - rhs.y, _x = x - rhs.x;
        return sqrt(_z * _z + _y * _y + _x * _x);
    }
    // std::vector<Point3d> neighbours(const Box3d &box, nb_dir_t nb_dir = ALL) const {
    //     std::vector<Point3d> neighbours;
    //     for (const auto& [_, dir] : (nb_dir == STRAIGHT ? straight_dirs : dirs)) {
    //         auto new_point = *this + dir;
    //         if (new_point.is_valid(box)) neighbours.emplace_back(std::move(new_point));
    //     }
    //     return neighbours;
    // }

    // template <class T> bool is_valid_on(const T& grid) const { return is_valid(Box::from(grid)); }
    // template <class T> std::vector<Point3d> neighbours_on(const T& grid, nb_dir_t nb_dir = ALL) const {
    //     return neighbours(Box::from(grid), nb_dir);
    // }
    // template<class T> auto value_on(const T& grid) {
    //     return grid.at(y).at(x);
    // }

    Point3d operator=(const Point3d& rhs) { x=rhs.x; y=rhs.y; z=rhs.z; return *this; }
    Point3d operator+(const Point3d& rhs) const { return {z + rhs.z, y + rhs.y, x + rhs.x}; }
    Point3d operator+=(const Point3d& rhs) { *this = *this + rhs; return *this; }
    Point3d operator-(const Point3d& rhs) const { return {z - rhs.z, y - rhs.y, x - rhs.x}; }
    Point3d operator-=(const Point3d& rhs) { *this = *this - rhs; return *this; }
    // Point3d operator*(const char d) const { // rotate point
    //     if (d == 'R') return {x, -y};
    //     if (d == 'L') return {-x, y};
    //     if (d == 'Z') return {-y, -x};
    //     throw;
    // }
    Point3d operator*=(const char d) { *this = *this * d; return *this; }
    Point3d operator*(const long n) const { return {n * z, n * y, n * x}; } // scale point
    Point3d operator*=(const long n) { *this = *this * n; return *this; }

    bool operator==(const Point3d& rhs) const { return z == rhs.z && y == rhs.y && x == rhs.x; }
    bool operator<(const Point3d& rhs) const {
        return z < rhs.z || (z == rhs.z && y < rhs.y) || (z == rhs.z && y == rhs.y && x < rhs.x);
    }

    friend std::ostream& operator<<(std::ostream& os, const Point3d& rhs) {
        return os << "(" << rhs.z << ", " << rhs.y << ", " << rhs.x << ")";
    }
};

// inline const std::map<std::string , const Point3d>Point3d::dirs = {
//         {"E", {0,1}}, {"W", {0,-1}}, {"N", {-1,0}}, {"S", {1,0}},
//         {"NE", {-1,1}}, {"SE", {1,1}}, {"NW", {-1,-1}}, {"SW", {1,-1}} };

// inline const std::map<std::string, const Point3d>Point3d::straight_dirs =
//     {{"N", {-1,0}}, {"E", {0,1}}, {"S", {1,0}}, {"W", {0,-1}}};
