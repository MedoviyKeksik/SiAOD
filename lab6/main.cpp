#include <iostream>
#include <stack>
#include <map>
#include <string>

#define CONFIG_FILE "config.txt"

using namespace std;

void read_config(map<char, pair<int, int>> &priority) {
    priority['('] = make_pair(INT_MAX, INT_MAX);
    priority['+'] = make_pair(1, 2);
    priority['-'] = make_pair(1, 2);
    priority['*'] = make_pair(3, 4);
    priority['/'] = make_pair(3, 4);
    priority['^'] = make_pair(6, 5);
    for (int i = 'a'; i <= 'z'; i++)
        priority[i] = make_pair(7, 8);
    for (int i = 'A'; i <= 'Z'; i++)
        priority[i] = make_pair(7, 8);
}

string get_postfix(string &in, map<char, pair<int, int>> &priority) {
    string res;
    stack<char> q;
    for (int i = 0; i < (int) in.size(); i++) {
        if (in[i] == ')') {
            while (q.top() != ')') {
                res += q.top();
                q.pop();
            }
            continue;
        }
        while (!q.empty() && priority[in[i]].first <= priority[q.top()].second) {
            res += q.top();
            q.pop();
        }
        q.push(in[i]);
    }
    while (!q.empty()) {
        res += q.top();
        q.pop();
    }
    return res;
}

int main() {
    map<char, pair<int, int>> config;
    read_config(config);
    string in;
    cin >> in;
    string out = get_postfix(in, config);
    int rang = 0;
    for (int i = 0; i < (int) out.size(); i++) {
        if (out[i] >= 'a' && out[i] <= 'z' || out[i] >= 'A' && out[i] <= 'Z') rang++;
        else rang--;
    }
    cout << out << '\n' << "rang = " << rang;
    return 0;
}
