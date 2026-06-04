#pragma once

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QSettings>
#include <QColor>

class ConfigManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString activeTheme READ activeTheme WRITE setActiveTheme NOTIFY activeThemeChanged)
    Q_PROPERTY(QString activeLanguage READ activeLanguage WRITE setActiveLanguage NOTIFY activeLanguageChanged)
    Q_PROPERTY(QString currentScreen READ currentScreen WRITE setCurrentScreen NOTIFY currentScreenChanged)
    Q_PROPERTY(QVariantMap translations READ translations NOTIFY translationsChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor NOTIFY themeChanged)
    Q_PROPERTY(QColor panelColor READ panelColor NOTIFY themeChanged)
    Q_PROPERTY(QColor textColor READ textColor NOTIFY themeChanged)
    Q_PROPERTY(QColor accentColor READ accentColor NOTIFY themeChanged)
    Q_PROPERTY(int elementRadius READ elementRadius NOTIFY themeChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);

    QString activeTheme() const { return m_activeTheme; }
    void setActiveTheme(const QString &theme);

    QString activeLanguage() const { return m_activeLanguage; }
    void setActiveLanguage(const QString &lang);

    QString currentScreen() const { return m_currentScreen; }
    void setCurrentScreen(const QString &screen);

    QVariantMap translations() const { return m_translations; }

    QColor backgroundColor() const { return m_activeTheme == "classic" ? QColor("#c0c0c0") : QColor("#16161e"); }
    QColor panelColor() const { return m_activeTheme == "classic" ? QColor("#c0c0c0") : QColor("#1e1e2a"); }
    QColor textColor() const { return m_activeTheme == "classic" ? QColor("#000000") : QColor("#ffffff"); }
    QColor accentColor() const { return m_activeTheme == "classic" ? QColor("#000080") : QColor("#d9534f"); }
    int elementRadius() const { return m_activeTheme == "classic" ? 0 : 6; }

    Q_INVOKABLE void openConfigFolder();
    Q_INVOKABLE void playSound(const QString &soundName);

    static void playCustomSound(const QString &soundFile);

signals:
    void activeThemeChanged();
    void activeLanguageChanged();
    void currentScreenChanged();
    void translationsChanged();
    void themeChanged();

private:
    void loadSettings();
    void saveSettings();
    void loadTranslations();

    QString m_activeTheme;
    QString m_activeLanguage;
    QString m_currentScreen;
    QVariantMap m_translations;
    QSettings m_settings;
};