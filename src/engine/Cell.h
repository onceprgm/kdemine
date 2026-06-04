#pragma once

#include <QObject>

class Cell : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int row READ row CONSTANT)
    Q_PROPERTY(int col READ col CONSTANT)
    Q_PROPERTY(bool isMine READ isMine CONSTANT)
    Q_PROPERTY(bool isRevealed READ isRevealed NOTIFY revealedChanged)
    Q_PROPERTY(bool isFlagged READ isFlagged NOTIFY flaggedChanged)
    Q_PROPERTY(int adjacentMines READ adjacentMines NOTIFY adjacentMinesChanged)

public:
    Cell(int row, int col, QObject *parent = nullptr);

    int row() const { return m_row; }
    int col() const { return m_col; }
    bool isMine() const { return m_isMine; }
    void setMine(bool hasMine) { m_isMine = hasMine; }

    bool isRevealed() const { return m_isRevealed; }
    void setRevealed(bool revealed);

    bool isFlagged() const { return m_isFlagged; }
    void setFlagged(bool flagged);

    int adjacentMines() const { return m_adjacentMines; }
    void setAdjacentMines(int count);

signals:
    void revealedChanged();
    void flaggedChanged();
    void adjacentMinesChanged();

private:
    int m_row;
    int m_col;
    bool m_isMine;
    bool m_isRevealed;
    bool m_isFlagged;
    int m_adjacentMines;
};