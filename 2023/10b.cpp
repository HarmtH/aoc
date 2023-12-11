#include "lib/prelude.hpp"
#include "lib/point.hpp"

struct maze_t {
    vector<string> grid;
    point_t start, pos;
    // rhs will contain tiles to the right of the pipes walked passed,
    // but not crossing the main loop
    set<point_t> main, rhs;
    char last_dir;
    // keep track of the net amount of clockwise turns made
    int cw_turns = 0;

    maze_t(istream& in);

    bool dir_valid(const char);
    void find_start_pipe();
    void walk();
    void step();
    void update(const vector<point_t>&, const vector<point_t>, char, char, char);
    void expand();
    int get_enclosed_tiles();
    void print_grid();
};

maze_t::maze_t(istream& in) {
    string line;
    int y = 0;
    while (getline(in, line)) {
        int x = line.find('S');
        if (x != -1) { start = pos = {y, x}; }
        grid.eb(line);
        y++;
    }
}

// check if pipe at pos + dir can reach pos
bool maze_t::dir_valid(const char dir) {
    auto np = pos + dir;
    if (!np.is_valid(grid.size(), grid[0].size())) return false;
    if (dir == 'N') return "F|7"s.find(grid[np.y][np.x]) != -1;
    else if (dir == 'E') return "7-J"s.find(grid[np.y][np.x]) != -1;
    else if (dir == 'S') return "L|J"s.find(grid[np.y][np.x]) != -1;
    else if (dir == 'W') return "F-L"s.find(grid[np.y][np.x]) != -1;
    else throw;
}

// a pipe is a valid start pipe if it has connections to neighbours, and the
// neighbours have connections to it
void maze_t::find_start_pipe() {
    auto& start_pipe = grid[start.y][start.x];
    if (dir_valid('S') && dir_valid('N')) { last_dir = 'N'; start_pipe = '|'; }
    else if (dir_valid('S') && dir_valid('E')) { last_dir = 'N'; start_pipe = 'F'; }
    else if (dir_valid('S') && dir_valid('W')) { last_dir = 'W'; start_pipe = '7'; }
    else if (dir_valid('W') && dir_valid('N')) { last_dir = 'S'; start_pipe = 'J'; }
    else if (dir_valid('W') && dir_valid('E')) { last_dir = 'E'; start_pipe = '-'; }
    else if (dir_valid('N') && dir_valid('E')) { last_dir = 'S'; start_pipe = 'L'; }
    else throw;
}

void maze_t::walk() {
    do step(); while (pos != start);
}

void maze_t::step() {
    const auto pipe = grid[pos.y][pos.x];
    if (pipe == '|') update({'E'}, {'W'}, 'N', 'S', 'N');
    else if (pipe == '-') update({'S'}, {'N'}, 'E', 'W', 'E');
    else if (pipe == 'L') update({"NE"}, {'W', "SW", 'S'}, 'N', 'E', 'W');
    else if (pipe == 'J') update({"NW"}, {'E', "SE", 'S'}, 'W', 'N', 'S');
    else if (pipe == '7') update({"SW"}, {'N', "NE", 'E'}, 'S', 'W', 'E');
    else if (pipe == 'F') update({"SE"}, {'N', "NW", 'W'}, 'E', 'S', 'N');
    else throw;
}

// cw_dir does double duty to determine what's your rhs
// for example, if your pipe is |, and you're going S, E is lhs, and W is rhs.
// so either cw_dir needs to contain 'S' and cw_dirs contains {'W'}, or cw_dir
// needs to contain 'N' and ccw_dirs contains {'W'}
void maze_t::update(const vector<point_t>& cw_dirs, const vector<point_t> ccw_dirs,
                    char cw_next_dir, char ccw_next_dir, char cw_dir) {
    main.insert(pos);
    bool cw = last_dir == cw_dir;
    // add the tiles directly right of the pipe walked passed
    for (const auto& point : (cw ? cw_dirs : ccw_dirs))
        rhs.insert(pos + point);
    // if we go straight, cw_dirs == ccw_dirs, and we don't update cw_turns
    if (cw_dirs.size() != ccw_dirs.size())
        cw_turns += (cw ? 1 : -1);
    last_dir = cw ? cw_next_dir : ccw_next_dir;
    pos += last_dir;
}

// find other points to right of the pipes walked passed, while not crossing the
// main loop, by using dfs
void maze_t::expand() {
    vector<point_t> todo{rhs.begin(), rhs.end()};
    set<point_t> seen;
    while (!todo.empty()) {
        const auto point = todo.back();
        todo.pop_back();
        if (main.contains(point) || !point.is_valid(grid)) continue;
        const auto [_, inserted] = seen.insert(point);
        if (!inserted) continue;
        auto nbs = point.get_valid_neighbours(grid, point_t::STRAIGHT);
        todo.insert(todo.end(), nbs.begin(), nbs.end());
    }
    rhs = seen;
}

// if we made more cw than ccw turns, we ran the loop cw, and rhs contains the wanted tiles.
// otherwise, we calculated the tiles outside of the loop, and we need to invert it
int maze_t::get_enclosed_tiles() {
    return cw_turns > 0 ? rhs.size() : grid.size() * grid[0].size() - main.size() - rhs.size();
}

void maze_t::print_grid() {
    for (int y = 0; y < grid.size(); y++) {
        for (int x = 0; x < grid[0].size(); x++) {
            point_t p{y, x};
            if (main.contains(p)) cout << ".";
            else if (rhs.contains(p)) cout << "X";
            else cout << ".";
        }
        cout << endl;
    }
    cout << endl;
}

int main (void) {
    maze_t maze(cin);

    maze.find_start_pipe();
    maze.walk();
    maze.expand();

    cout << maze.get_enclosed_tiles() << endl;

    return 0;
}
