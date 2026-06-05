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

void GameBoard::initializeBoard(const QSize &size, int mines)
{
    clearBoard();
    m_rows = size.height();
    m_cols = size.width();
    m_totalMines = mines;

    for (int row = 0; row < m_rows; ++row) {
        QList<Cell*> rowList;
        for (int col = 0; col < m_cols; ++col) {
            rowList.append(new Cell(row, col, this));
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
            if (dr == 0 && dc == 0) {
                continue;
            }
            Cell* neighbor = getCell(row + dr, col + dc);
            if (neighbor != nullptr) {
                neighbors.append(neighbor);
            }
        }
    }
    return neighbors;
}

void GameBoard::placeRandomMines(int startRow, int startCol)
{
    for (int row = 0; row < m_rows; ++row) {
        for (int col = 0; col < m_cols; ++col) {
            m_cells[row][col]->setMine(false);
        }
    }

    int placed = 0;
    while (placed < m_totalMines) {
        int row = QRandomGenerator::global()->bounded(m_rows);
        int col = QRandomGenerator::global()->bounded(m_cols);

        if (qAbs(row - startRow) <= 1 && qAbs(col - startCol) <= 1) {
            continue;
        }

        if (!m_cells[row][col]->isMine()) {
            m_cells[row][col]->setMine(true);
            placed++;
        }
    }
}

void GameBoard::calculateAdjacentMines()
{
    for (int row = 0; row < m_rows; ++row) {
        for (int col = 0; col < m_cols; ++col) {
            Cell* cell = m_cells[row][col];
            if (cell->isMine()) {
                continue;
            }

            int count = 0;
            for (Cell* neighbor : getNeighbors(row, col)) {
                if (neighbor->isMine()) {
                    count++;
                }
            }
            cell->setAdjacentMines(count);
        }
    }
}

void GameBoard::cascadeReveal(QList<QList<bool>> &revealed, QList<QList<bool>> &flagged, int row, int col) const
{
    if (revealed[row][col] || flagged[row][col]) {
        return;
    }
    revealed[row][col] = true;
    Cell* cell = getCell(row, col);
    if (cell != nullptr && cell->adjacentMines() == 0) {
        for (Cell* neighbor : getNeighbors(row, col)) {
            cascadeReveal(revealed, flagged, neighbor->row(), neighbor->col());
        }
    }
}

bool GameBoard::checkAndApplyRules(QList<QList<bool>> &revealed, QList<QList<bool>> &flagged, int row, int col)
{
    if (!revealed[row][col] || m_cells[row][col]->adjacentMines() == 0) {
        return false;
    }

    Cell* cell = m_cells[row][col];
    QList<Cell*> neighbors = getNeighbors(row, col);

    int flagCount = 0;
    int unrevealedCount = 0;
    QList<Cell*> unrevealedNeighbors;

    for (Cell* neighbor : neighbors) {
        if (flagged[neighbor->row()][neighbor->col()]) {
            flagCount++;
        } else if (!revealed[neighbor->row()][neighbor->col()]) {
            unrevealedCount++;
            unrevealedNeighbors.append(neighbor);
        }
    }

    bool changed = false;

    if (cell->adjacentMines() == flagCount + unrevealedCount && unrevealedCount > 0) {
        for (Cell* neighbor : unrevealedNeighbors) {
            flagged[neighbor->row()][neighbor->col()] = true;
        }
        changed = true;
    }

    if (cell->adjacentMines() == flagCount && unrevealedCount > 0) {
        for (Cell* neighbor : unrevealedNeighbors) {
            cascadeReveal(revealed, flagged, neighbor->row(), neighbor->col());
        }
        changed = true;
    }

    return changed;
}

bool GameBoard::isBoardSolvable(int startRow, int startCol)
{
    QList<QList<bool>> solvedRevealed(m_rows, QList<bool>(m_cols, false));
    QList<QList<bool>> solvedFlagged(m_rows, QList<bool>(m_cols, false));

    cascadeReveal(solvedRevealed, solvedFlagged, startRow, startCol);

    bool changed = true;
    while (changed) {
        changed = false;

        for (int row = 0; row < m_rows; ++row) {
            for (int col = 0; col < m_cols; ++col) {
                if (checkAndApplyRules(solvedRevealed, solvedFlagged, row, col)) {
                    changed = true;
                }
            }
        }
    }

    for (int row = 0; row < m_rows; ++row) {
        for (int col = 0; col < m_cols; ++col) {
            if (!m_cells[row][col]->isMine() && !solvedRevealed[row][col]) {
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