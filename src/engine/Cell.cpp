#include "Cell.h"

Cell::Cell(int row, int col, QObject *parent)
    : QObject(parent)
    , m_row(row)
    , m_col(col)
    , m_isMine(false)
    , m_isRevealed(false)
    , m_isFlagged(false)
    , m_adjacentMines(0)
{
}

void Cell::setRevealed(bool revealed)
{
    if (m_isRevealed != revealed) {
        m_isRevealed = revealed;
        emit revealedChanged();
    }
}

void Cell::setFlagged(bool flagged)
{
    if (m_isFlagged != flagged) {
        m_isFlagged = flagged;
        emit flaggedChanged();
    }
}

void Cell::setAdjacentMines(int count)
{
    if (m_adjacentMines != count) {
        m_adjacentMines = count;
        emit adjacentMinesChanged();
    }
}