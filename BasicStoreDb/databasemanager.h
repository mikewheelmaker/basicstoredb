#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QSqlDatabase>

#include "utils.h"

class DatabaseManager
{
public:
    enum SearchCategories
    {
        Name = 0,
        RegNumber
    };

public:
    DatabaseManager(const QString& path);
    ~DatabaseManager();

    bool createTable();
    bool insertItem(const QString& name, const QString& regNumber);
    bool selectItem(const QString& string, SearchCategories category);
    bool deleteItem(const QString& string, SearchCategories category);
    bool dropTable(const QString& tableName);
    QList<ItemDetails> getDbContent();

private:
    QSqlDatabase m_db;
};

#endif // DATABASEMANAGER_H
