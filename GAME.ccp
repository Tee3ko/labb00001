#include <iostream>
#include <vector>
#include <string>
#include <random>
#include <chrono>
#include <thread>
#include <cstdlib>
#include <ctime>

using namespace std;
void displayBoard(const vector<vector<char>>& board) {
    for (int i = 0; i < board.size(); i++) {
        for (int j = 0; j < board[i].size(); j++) {
            cout << board[i][j] << " ";
        }
        cout << endl;
    }
}

//function to update the game board with player and computer positions
void updateBoard(vector<vector<char>>& board, int playerX, int playerY, int comp1X, int comp1Y, int comp2X, int comp2Y, char healthItem, char hideItem) {
    //set the player and computer positions on the board
    board[playerY][playerX] = 'A';
    board[comp1Y][comp1X] = '1';
    board[comp2Y][comp2X] = '2';

    //set the health item and hide item on the board
    board[board.size()/2][board[0].size()/2] = healthItem;
    board[board.size()/4][board[0].size()/4] = hideItem;
}

int main() {
    //get the dimensions of the game board
    int size;
    do {
        cout << "Enter the size of the game board (odd number): ";
        cin >> size;
    } while (size % 2 == 0);

    //get the size of each cell on the game board
    int cellSize;
    cout << "Enter the size of each cell in pixels: ";
    cin >> cellSize;

    //create the game board
    vector<vector<char>> board(size, vector<char>(size, ' '));

    //set the health and hide items on the board
    char healthItem = 'h';
    char hideItem = 'r';
    updateBoard(board, size/2, size/2, -1, -1, -1, -1, healthItem, hideItem);

    //set the player and computer attributes
    int playerX = size/2;
    int playerY = size/2;
    int playerHealth = 200;
    int playerAttack = 10;
    int comp1X, comp1Y, comp1Health = 200, comp1Attack = 10;
    int comp2X, comp2Y, comp2Health = 200, comp2Attack = 10;

    //set the computer positions
    do {
        comp1X = rand() % size;
        comp1Y = rand() % size;
    } while (comp1X == playerX && comp1Y == playerY);
    do {
        comp2X = rand() % size;
        comp2Y = rand() % size;
    } while ((comp2X == playerX && comp2Y == playerY) || (comp2X == comp1X && comp2Y == comp1Y));

    //initialize the random number generator for computer movement
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    default_random_engine generator(seed);

    //game loop
    while (playerHealth > 0) {
        //clear the console and display the game board
        system("cls");
        displayBoard(board);

        //get the player command
        char command;
        cout << "Enter command (w/a/s/d): ";
        cin >> command;

        //update the player position
        switch (command) {
            case 'w':
                if (playerY > 0) {
                    playerY--;
                }
                break;
            case 'a':
                if (playerX > 0) {
                    playerX--;
                }
                break;
            case 's':
                if (playerY < size-1) {
                    playerY++;
                }
                break;
            case 'd':
                if (playerX < size-1) {
                    playerX++;
                }
                break;
            default:
                break;
        }

        //check if the player picked up the health item
        if (board[playerY][playerX] == healthItem) {
            playerHealth += 50;
            board[playerY][playerX] = ' ';
        }

        //check if the player picked up the hide item
        if (board[playerY][playerX] == hideItem) {
            playerAttack += 5;
            board[playerY][playerX] = ' ';
        }

        //update the computer positions
        //computer 1 movement
        int comp1Move = generator() % 4;
        switch (comp1Move) {
            case 0:
                if (comp1Y > 0) {
                    comp1Y--;
                }
                break;
            case 1:
                if (comp1X > 0) {
                    comp1X--;
                }
                break;
            case 2:
                if (comp1Y < size-1) {
                    comp1Y++;
                }
                break;
            case 3:
                if (comp1X < size-1) {
                    comp1X++;
                }
                break;
            default:
                break;
        }

        //computer 2 movement
        int comp2Move = generator() % 4;
        switch (comp2Move) {
            case 0:
                if (comp2Y > 0) {
                    comp2Y--;
                }
                break;
            case 1:
                if (comp2X > 0) {
                    comp2X--;
                }
                break;
            case 2:
                if (comp2Y < size-1) {
                    comp2Y++;
                }
                break;
            case 3:
                if (comp2X < size-1) {
                    comp2X++;
                }
                break;
            default:
                break;
        }

        //check if the player is within range of a computer and update the game
        if (abs(playerX-comp1X) + abs(playerY-comp1Y) <= 1) {
            comp1Health -= playerAttack;
        }
        if (abs(playerX-comp2X) + abs(playerY-comp2Y) <= 1) {
            comp2Health -= playerAttack;
        }
        if (abs(comp1X-comp2X) + abs(comp1Y-comp2Y) <= 1) {
            comp1Health -= comp2Attack;
            comp2Health -= comp1Attack;
        }

        //check if any computers have died and update the game
        if (comp1Health <= 0) {
            board[comp1Y][comp1X] = ' ';
            comp1X = -1;
            comp1Y = -1;
        }
        if (comp2Health <= 0) {
            board[comp2Y][comp2X] = ' ';
            comp2X = -1;
            comp2Y = -1;
        }

        //update the game board with new positions and items
        updateBoard(board, playerX, playerY, comp1X, comp1Y, comp2X, comp2Y, healthItem, hideItem);

        //check if the player has won or lost the game
        if (comp1X == -1 && comp2X == -1) {
            cout << "Congratulations, you win!" << endl;
            break;
        }
        if (playerHealth <= 0) {
            cout << "Game over, you lose." << endl;
            break;
        }
    }
    
    return 0;
}
