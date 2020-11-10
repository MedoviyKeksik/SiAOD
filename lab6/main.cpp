#include <iostream>
#include <stack>
#include <map>
#include <string>
#include <climits>

using namespace std;

template <typename T>
class Stack {
private:
    struct node {
        T data;
        node *next;
    };
    int size;
    node *head;
public:
    Stack();
    ~Stack();
    void push(const T);
    void pop();
    bool empty();
    T top();
};

template <typename T>
Stack<T>::Stack() {
    head = nullptr;
    size = 0;
}

template <typename T>
Stack<T>::~Stack() {
    while (!empty()) {
        pop();
    }
}

template <typename T>
void Stack<T>::push(const T data) {
    node* ptr = new node;
    ptr->next = head;
    ptr->data = data;
    size++;
    head = ptr;
}

template <typename T>
void Stack<T>::pop() {
    node* ptr = head;
    head = head->next;
    size--;
    delete ptr;
}

template <typename T>
bool Stack<T>::empty() {
    return size == 0;
}

template <typename T>
T Stack<T>::top() {
    return head->data;
}

void read_config(map<char, pair<int, int>> &priority) {
    priority['('] = make_pair(INT_MIN + 1, INT_MIN);
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
    Stack<char> q;
    for (int i = 0; i < (int) in.size(); i++) {
        if (in[i] == ')') {
            while (q.top() != '(') {
                res += q.top();
                q.pop();
            }
            q.pop();
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
