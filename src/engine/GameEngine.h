#pragma once

#include <QObject>
#include <QString>
#include <QTimer>
#include "GameBoard.h"

class GameEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(GameBoard* board READ board CONSTANT)
    Q_PROPERTY(QString gameState READ gameState NOTIFY gameStateChanged)
    Q_PROPERTY(int elapsedTime READ elapsedTime NOTIFY elapsedTimeChanged)
    Q_PROPERTY(int minesRemaining READ minesRemaining NOTIFY minesRemainingChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);

    GameBoard* board() { return &m_board; }
    QString gameState() const { return m_gameState; }
    int elapsedTime() const { return m_elapsedTime; }
    int minesRemaining() const;

    Q_INVOKABLE void startNewGame(const QString &difficulty);
    Q_INVOKABLE void startCustomGame(int rows, int cols, int mines);
    Q_INVOKABLE void revealCell(int row, int col);
    Q_INVOKABLE void flagCell(int row, int col);

signals:
    void gameStateChanged();
    void elapsedTimeChanged();
    void minesRemainingChanged();

private slots:
    void onTimerTick();

private:
    void checkWinCondition();
    void revealCascade(int row, int col);

    GameBoard m_board;
    QString m_gameState;
    int m_elapsedTime;
    QTimer* m_timer;
    bool m_isFirstClick;
};