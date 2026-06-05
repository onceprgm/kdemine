#pragma once

#include <QObject>
#include <QList>
#include <QSize>
#include "Cell.h"

class GameBoard : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int rows READ rows NOTIFY boardReset)
    Q_PROPERTY(int cols READ cols NOTIFY boardReset)
    Q_PROPERTY(int totalMines READ totalMines NOTIFY boardReset)

public:
    explicit GameBoard(QObject *parent = nullptr);
    ~GameBoard();

    GameBoard(const GameBoard&) = delete;
    GameBoard& operator=(const GameBoard&) = delete;
    GameBoard(GameBoard&&) = delete;
    GameBoard& operator=(GameBoard&&) = delete;

    int rows() const { return m_rows; }
    int cols() const { return m_cols; }
    int totalMines() const { return m_totalMines; }

    void initializeBoard(const QSize &size, int mines);
    void generateGuessFreeBoard(int startRow, int startCol);
    
    Q_INVOKABLE Cell* getCell(int row, int col) const;

signals:
    void boardReset();

private:
    void clearBoard();
    void placeRandomMines(int startRow, int startCol);
    void calculateAdjacentMines();
    bool isBoardSolvable(int startRow, int startCol);
    void cascadeReveal(QList<QList<bool>> &revealed, QList<QList<bool>> &flagged, int row, int col) const;
    bool checkAndApplyRules(QList<QList<bool>> &revealed, QList<QList<bool>> &flagged, int row, int col);
    QList<Cell*> getNeighbors(int row, int col) const;

    int m_rows;
    int m_cols;
    int m_totalMines;
    QList<QList<Cell*>> m_cells;
};