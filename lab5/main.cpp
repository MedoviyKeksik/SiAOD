#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <string>
#include <sstream>
#include <iomanip>

#define INPUTFILE "input.txt"
#define FILEOUT

using namespace std;

vector<int> parse(string &str) {
    vector<int> res;
    stringstream tmp;
    tmp << str;
    int a;
    while (tmp >> a) {
        res.push_back(a);
    }
    return res;
}

int getNextModA(int x, int a) {
    return ((x + a) / a) * a;
}

int getNextModB(int x, int b) {
    return ((x + b - 1) / b) * b;
}

pair<float, int> modulate(int input_time, int cycle_time, vector<vector<int>> processes, const vector<int> &priority, bool print = false, ostream &out = cout) {
    set<pair<pair<int, int>, int>>q;
    for (int i = 0; i < (int) priority.size(); i++) {
        q.insert(make_pair(make_pair(priority[i], 0), i));
    }
    enum state {down = 'I', wait = '0', work = '_'};

    int needed_time = 0;
    for (int i = 0; i < (int) processes.size(); i++) {
        for (int j = 0; j < (int) processes[i].size(); j++) {
            needed_time += processes[i][j];
        }
    }

    int num = priority.size();
    vector<vector<state>> state_map;
    vector<int> process_index(num);

    int time = 0;
    int all_done = 0;
    while (all_done < processes.size()) {
        while (state_map.size() < getNextModA(time, cycle_time)) state_map.emplace_back(num, wait);
        auto it = q.begin();
        while (it != q.end() && (state_map[time][it->second] != wait || process_index[it->second] == processes[it->second].size()))
            it++;
        if (it != q.end()) {
            int prior = it->first.first;
            int sz = state_map.size();
            int lsz = it->first.second;
            int pi = it->second;
            int pj = process_index[pi];
            q.erase(it);
            int todo;
            todo = min(cycle_time, processes[pi][pj]);
            for (int i = 0; i < todo; i++) {
                state_map[time + i][pi] = work;
            }
            bool kek = false;
            processes[pi][pj] -= todo;
            if (!processes[pi][pj]) {
                kek = true;
                process_index[pi]++;
                if (process_index[pi] == processes[pi].size()) all_done++;
                while (state_map.size() < getNextModB(time + todo + input_time, cycle_time))
                    state_map.emplace_back(num, wait);
                for (int i = todo; i < todo + input_time; i++) {
                    state_map[time + i][pi] = down;
                }
            }
            if (kek) q.insert(make_pair(make_pair(prior, sz), pi));
            else q.insert(make_pair(make_pair(prior, lsz), pi));
        }
        time += cycle_time;
    }
    vector<bool> dead_cycle(state_map.size());
    int dead_count = 0;
    for (int i = 0; i < (int) state_map.size(); i++) {
        dead_cycle[i] = true;
        for (int j = 0; j < (int) state_map[i].size(); j++) {
            if (state_map[i][j] == work) dead_cycle[i] = false;
        }
        dead_count += dead_cycle[i];
    }

    if (print) {
        for (int i = 0; i < (int) dead_cycle.size(); i++) {
            if (i && !(i % cycle_time)) out << ' ';
            out << (dead_cycle[i] ? 'X' : ' ');
        }
        out << '\n';
        for (int j = 0; j < (int) state_map[0].size(); j++) {
            for (int i = 0; i < (int) state_map.size(); i++) {
                if (i && !(i % cycle_time)) out << '|';
                out << (char)state_map[i][j];
            }
            out << '\n';
        }
    }
    return make_pair(1.0 * needed_time / state_map.size(), dead_count);
}

int main() {
    system("chcp 1251 > nul");
    ifstream fin(INPUTFILE);
    int num_users;
    fin >> num_users;
    vector<int> priority(num_users);
    for (int i = 0; i < num_users; i++) {
        fin >> priority[i];
    }
    vector<vector<int>> users(num_users);
    string tmp;
    getline(fin, tmp);
    for (int i = 0; i < num_users; i++) {
        getline(fin, tmp);
        users[i] = parse(tmp);
    }
    fin.close();

    cout << "in \\ cl";
    for (int i = 1; i <= 10; i++) {
        cout << setw(8) << i << "   ";
    }
    cout << '\n';
    for (int i = 0; i <= 10; i++) {
        cout << setw(4) << i << "   ";
        for (int j = 1; j <= 10; j++) {
            auto res = modulate(i, j, users, priority);
            cout << fixed << setprecision(2) << res.first << '|' << setw(3) << res.second << "   ";
        }
        cout << '\n';
    }

    int menu_item = 0, input_time, cycle_time;
    while (true) {
        cout << "Введите 0 - чтобы выйти\nЛюбое другое число - чтобы вывести лог процессора\n";
        cin >> menu_item;
        if (menu_item == 0) break;
        cout << "Введите время ввода: ";
        cin >> input_time;
        cout << "Введите время такта: ";
        cin >> cycle_time;
#ifdef FILEOUT
        ofstream os("out.txt");
        auto res = modulate(input_time, cycle_time, users, priority, true, os);
        os << "КПД = " << fixed << setprecision(3) << res.first << " Количество \"мертвых\" тактов = " << res.second << '\n';
        os.close();
        system("out.txt"    );
#else
        auto res = modulate(input_time, cycle_time, users, priority, true);
        cout << "КПД = " << fixed << setprecision(3) << res.first << " Количество \"мертвых\" тактов = " << res.second << '\n';
#endif
    }
    return 0;

}


