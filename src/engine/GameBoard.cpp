#include "GameBoard.h"
#include <QRandomGenerator>

GameBoard::GameBoard(QObject *parent)
    : QObject(parent)
    , m_rows(0)
    , m_cols(0)
    , m_totalMines(0)
{
}

GameBoard::~GameBoard()
{
    clearBoard();
}

void GameBoard::clearBoard()
{
    for (auto &row : m_cells) {
        for (auto *cell : row) {
            delete cell;
        }
    }
    m_cells.clear();
}

void GameBoard::initializeBoard(int rows, int cols, int mines)
{
    clearBoard();
    m_rows = rows;
    m_cols = cols;
    m_totalMines = mines;

    for (int r = 0; r < m_rows; ++r) {
        QList<Cell*> rowList;
        for (int c = 0; c < m_cols; ++c) {
            rowList.append(new Cell(r, c, this));
        }
        m_cells.append(rowList);
    }
    emit boardReset();
}

Cell* GameBoard::getCell(int row, int col) const
{
    if (row < 0 || row >= m_rows || col < 0 || col >= m_cols) {
        return nullptr;
    }
    return m_cells[row][col];
}

QList<Cell*> GameBoard::getNeighbors(int row, int col) const
{
    QList<Cell*> neighbors;
    for (int dr = -1; dr <= 1; ++dr) {
        for (int dc = -1; dc <= 1; ++dc) {
            if (dr == 0 && dc == 0) continue;
            Cell* neighbor = getCell(row + dr, col + dc);
            if (neighbor) {
                neighbors.append(neighbor);
            }
        }
    }
    return neighbors;
}

void GameBoard::placeRandomMines(int startRow, int startCol)
{
    for (int r = 0; r < m_rows; ++r) {
        for (int c = 0; c < m_cols; ++c) {
            m_cells[r][c]->setMine(false);
        }
    }

    int placed = 0;
    while (placed < m_totalMines) {
        int r = QRandomGenerator::global()->bounded(m_rows);
        int c = QRandomGenerator::global()->bounded(m_cols);

        if (qAbs(r - startRow) <= 1 && qAbs(c - startCol) <= 1) {
            continue;
        }

        if (!m_cells[r][c]->isMine()) {
            m_cells[r][c]->setMine(true);
            placed++;
        }
    }
}

void GameBoard::calculateAdjacentMines()
{
    for (int r = 0; r < m_rows; ++r) {
        for (int c = 0; c < m_cols; ++c) {
            Cell* cell = m_cells[r][c];
            if (cell->isMine()) continue;

            int count = 0;
            for (Cell* neighbor : getNeighbors(r, c)) {
                if (neighbor->isMine()) {
                    count++;
                }
            }
            cell->setAdjacentMines(count);
        }
    }
}

bool GameBoard::isBoardSolvable(int startRow, int startCol)
{
    QList<QList<bool>> solvedRevealed(m_rows, QList<bool>(m_cols, false));
    QList<QList<bool>> solvedFlagged(m_rows, QList<bool>(m_cols, false));

    auto cascadeReveal = [&](auto& self, int r, int c) -> void {
        if (solvedRevealed[r][c] || solvedFlagged[r][c]) return;
        solvedRevealed[r][c] = true;
        if (m_cells[r][c]->adjacentMines() == 0) {
            for (Cell* neighbor : getNeighbors(r, c)) {
                self(self, neighbor->row(), neighbor->col());
            }
        }
    };

    cascadeReveal(cascadeReveal, startRow, startCol);

    bool changed = true;
    while (changed) {
        changed = false;

        for (int r = 0; r < m_rows; ++r) {
            for (int c = 0; c < m_cols; ++c) {
                if (!solvedRevealed[r][c] || m_cells[r][c]->adjacentMines() == 0) {
                    continue;
                }

                Cell* cell = m_cells[r][c];
                QList<Cell*> neighbors = getNeighbors(r, c);

                int flagCount = 0;
                int unrevealedCount = 0;
                QList<Cell*> unrevealedNeighbors;

                for (Cell* n : neighbors) {
                    if (solvedFlagged[n->row()][n->col()]) {
                        flagCount++;
                    } else if (!solvedRevealed[n->row()][n->col()]) {
                        unrevealedCount++;
                        unrevealedNeighbors.append(n);
                    }
                }

                if (cell->adjacentMines() == flagCount + unrevealedCount && unrevealedCount > 0) {
                    for (Cell* n : unrevealedNeighbors) {
                        solvedFlagged[n->row()][n->col()] = true;
                    }
                    changed = true;
                }

                if (cell->adjacentMines() == flagCount && unrevealedCount > 0) {
                    for (Cell* n : unrevealedNeighbors) {
                        cascadeReveal(cascadeReveal, n->row(), n->col());
                    }
                    changed = true;
                }
            }
        }
    }

    for (int r = 0; r < m_rows; ++r) {
        for (int c = 0; c < m_cols; ++c) {
            if (!m_cells[r][c]->isMine() && !solvedRevealed[r][c]) {
                return false;
            }
        }
    }

    return true;
}

void GameBoard::generateGuessFreeBoard(int startRow, int startCol)
{
    const int maxAttempts = 1000;
    for (int attempt = 0; attempt < maxAttempts; ++attempt) {
        placeRandomMines(startRow, startCol);
        calculateAdjacentMines();
        if (isBoardSolvable(startRow, startCol)) {
            return;
        }
    }
    
    placeRandomMines(startRow, startCol);
    calculateAdjacentMines();
}