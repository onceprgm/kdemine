#include "ConfigManager.h"
#include <QLocale>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QDesktopServices>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QCoreApplication>
#include <QProcess>
#include <iostream>

ConfigManager::ConfigManager(QObject *parent)
    : QObject(parent)
    , m_settings(QSettings::IniFormat, QSettings::UserScope, "KDEMineProject", "kdemine")
    , m_currentScreen("menu")
{
    loadSettings();
}

void ConfigManager::loadSettings()
{
    m_activeTheme = m_settings.value("theme", "breeze").toString();

    QString sysLang = QLocale::system().name().left(2);
    if (sysLang != "ru" && sysLang != "zh") {
        sysLang = "en";
    }
    m_activeLanguage = m_settings.value("language", sysLang).toString();

    loadTranslations();
}

void ConfigManager::saveSettings()
{
    m_settings.setValue("theme", m_activeTheme);
    m_settings.setValue("language", m_activeLanguage);
}

void ConfigManager::setActiveTheme(const QString &theme)
{
    if (m_activeTheme != theme) {
        m_activeTheme = theme;
        saveSettings();
        emit activeThemeChanged();
        emit themeChanged();
    }
}

void ConfigManager::setActiveLanguage(const QString &lang)
{
    if (m_activeLanguage != lang) {
        m_activeLanguage = lang;
        saveSettings();
        loadTranslations();
        emit activeLanguageChanged();
    }
}

void ConfigManager::setCurrentScreen(const QString &screen)
{
    if (m_currentScreen != screen) {
        m_currentScreen = screen;
        emit currentScreenChanged();
    }
}

void ConfigManager::loadTranslations()
{
    QFile file(QString(":/qt/qml/kdemine/qml/lang/%1.json").arg(m_activeLanguage));
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        m_translations = doc.object().toVariantMap();
        emit translationsChanged();
    }
}

void ConfigManager::openConfigFolder()
{
    QFileInfo info(m_settings.fileName());
    QDesktopServices::openUrl(QUrl::fromLocalFile(info.dir().absolutePath()));
}

void ConfigManager::playCustomSound(const QString &soundFile)
{
    if (soundFile.contains('/') || soundFile.contains('\\') || soundFile.contains("..")) {
        return;
    }

    QString path = QCoreApplication::applicationDirPath() + "/qml/assets/" + soundFile;
    if (QFileInfo::exists(path)) {
        QProcess::startDetached("paplay", QStringList() << path);
    } else {
        std::cout << "Warning: Sound file not found at " << path.toStdString() << "\n";
    }
}

void ConfigManager::playSound(const QString &soundName)
{
    if (m_activeTheme.isEmpty()) {
        return;
    }
    playCustomSound(soundName);
}