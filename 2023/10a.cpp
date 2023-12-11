#include "lib/prelude.hpp"
#include "lib/point.hpp"

struct maze_t {
    vector<string> grid;
    point_t start, pos;
    set<point_t> main;
    char last_dir;

    maze_t(istream& in);

    bool dir_valid(const char);
    void find_start_pipe();
    void walk();
    void step();
    void update(char, char, char);
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
    if (pipe == '|') update('N', 'S', 'N');
    else if (pipe == '-') update('E', 'W', 'E');
    else if (pipe == 'L') update('N', 'E', 'W');
    else if (pipe == 'J') update('W', 'N', 'S');
    else if (pipe == '7') update('S', 'W', 'E');
    else if (pipe == 'F') update('E', 'S', 'N');
    else throw;
}

void maze_t::update(char cw_next_dir, char ccw_next_dir, char cw_dir) {
    main.insert(pos);
    last_dir = cw_dir == last_dir ? cw_next_dir : ccw_next_dir;
    pos += last_dir;
}

int main (void) {
    maze_t maze(cin);

    maze.find_start_pipe();
    maze.walk();

    cout << (maze.main.size() + 1) / 2 << endl;

    return 0;
}
