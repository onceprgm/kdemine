#include "GameEngine.h"
#include "../ConfigManager.h"
#include <QPoint>

GameEngine::GameEngine(QObject *parent)
    : QObject(parent)
    , m_gameState("idle")
    , m_elapsedTime(0)
    , m_timer(new QTimer(this))
    , m_isFirstClick(true)
    , m_isGuessFree(true)
{
    connect(m_timer, &QTimer::timeout, this, &GameEngine::onTimerTick);
}

int GameEngine::minesRemaining() const
{
    int flags = 0;
    for (int row = 0; row < m_board.rows(); ++row) {
        for (int col = 0; col < m_board.cols(); ++col) {
            Cell* cell = m_board.getCell(row, col);
            if (cell != nullptr && cell->isFlagged()) {
                flags++;
            }
        }
    }
    return m_board.totalMines() - flags;
}

void GameEngine::startNewGame(const QString &difficulty)
{
    m_timer->stop();
    m_elapsedTime = 0;
    emit elapsedTimeChanged();

    m_isFirstClick = true;
    m_gameState = "idle";
    emit gameStateChanged();

    int rows = 16;
    int cols = 16;
    int mines = 40;

    if (difficulty == "noobs") {
        rows = 9;
        cols = 9;
        mines = 10;
    } else if (difficulty == "hardcore") {
        rows = 30;
        cols = 16;
        mines = 99;
    }

    m_board.initializeBoard(QSize(cols, rows), mines);
    emit minesRemainingChanged();
}

void GameEngine::startCustomGame(int rows, int cols, int mines)
{
    if (rows < 1 || cols < 1 || mines < 1) {
        return;
    }

    m_timer->stop();
    m_elapsedTime = 0;
    emit elapsedTimeChanged();

    m_isFirstClick = true;
    m_gameState = "idle";
    emit gameStateChanged();

    m_board.initializeBoard(QSize(cols, rows), mines);
    emit minesRemainingChanged();
}

void GameEngine::revealCell(int row, int col)
{
    if (m_gameState != "idle" && m_gameState != "playing") {
        return;
    }

    Cell* cell = m_board.getCell(row, col);
    if (cell == nullptr || cell->isRevealed() || cell->isFlagged()) {
        return;
    }

    ConfigManager::playCustomSound("tick.wav");

    if (m_isFirstClick) {
        m_isFirstClick = false;
        bool guessFree = m_board.generateGuessFreeBoard(row, col);
        if (m_isGuessFree != guessFree) {
            m_isGuessFree = guessFree;
            emit isGuessFreeChanged();
        }
        m_gameState = "playing";
        emit gameStateChanged();
        m_timer->start(1000);
    }

    if (cell->isMine()) {
        m_timer->stop();
        m_gameState = "lost";
        emit gameStateChanged();
        cell->setRevealed(true);

        ConfigManager::playCustomSound("explosion.wav");
        return;
    }

    revealCascade(row, col);
    checkWinCondition();
}

void GameEngine::revealCascade(int row, int col)
{
    QList<QPoint> stack;
    stack.append(QPoint(row, col));

    while (!stack.isEmpty()) {
        QPoint pos = stack.takeLast();
        Cell* cell = m_board.getCell(pos.x(), pos.y());
        if (cell == nullptr || cell->isRevealed() || cell->isFlagged()) {
            continue;
        }

        cell->setRevealed(true);

        if (cell->adjacentMines() == 0) {
            for (int dr = -1; dr <= 1; ++dr) {
                for (int dc = -1; dc <= 1; ++dc) {
                    if (dr == 0 && dc == 0) {
                        continue;
                    }
                    stack.append(QPoint(pos.x() + dr, pos.y() + dc));
                }
            }
        }
    }
}

void GameEngine::flagCell(int row, int col)
{
    if (m_gameState != "playing" && m_gameState != "idle") {
        return;
    }

    Cell* cell = m_board.getCell(row, col);
    if (cell == nullptr || cell->isRevealed()) {
        return;
    }

    cell->setFlagged(!cell->isFlagged());
    emit minesRemainingChanged();
}

void GameEngine::checkWinCondition()
{
    int unrevealedCount = 0;
    for (int row = 0; row < m_board.rows(); ++row) {
        for (int col = 0; col < m_board.cols(); ++col) {
            Cell* cell = m_board.getCell(row, col);
            if (cell != nullptr && !cell->isRevealed()) {
                unrevealedCount++;
            }
        }
    }

    if (unrevealedCount == m_board.totalMines()) {
        m_timer->stop();
        m_gameState = "won";
        emit gameStateChanged();

        ConfigManager::playCustomSound("victory.wav");
    }
}

void GameEngine::onTimerTick()
{
    m_elapsedTime++;
    emit elapsedTimeChanged();
}