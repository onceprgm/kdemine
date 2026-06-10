#include "GameBoard.h"
#include <QPoint>
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
    m_rows = qMax(1, size.height());
    m_cols = qMax(1, size.width());
    m_totalMines = qBound(1, mines, qMax(1, (m_rows * m_cols) - 9));

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
    QList<QPoint> stack;
    stack.append(QPoint(row, col));

    while (!stack.isEmpty()) {
        QPoint pos = stack.takeLast();
        Cell* cell = getCell(pos.x(), pos.y());
        if (cell == nullptr || revealed[pos.x()][pos.y()] || flagged[pos.x()][pos.y()]) {
            continue;
        }
        revealed[pos.x()][pos.y()] = true;
        if (cell->adjacentMines() == 0) {
            for (Cell* neighbor : getNeighbors(pos.x(), pos.y())) {
                stack.append(QPoint(neighbor->row(), neighbor->col()));
            }
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

bool GameBoard::generateGuessFreeBoard(int startRow, int startCol)
{
    const int maxAttempts = 1000;
    for (int attempt = 0; attempt < maxAttempts; ++attempt) {
        placeRandomMines(startRow, startCol);
        calculateAdjacentMines();
        if (isBoardSolvable(startRow, startCol)) {
            return true;
        }
    }

    placeRandomMines(startRow, startCol);
    calculateAdjacentMines();
    return false;
}