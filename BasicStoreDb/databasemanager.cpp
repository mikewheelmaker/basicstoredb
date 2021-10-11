#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDriver>
#include <QSqlRecord>

#include "databasemanager.h"

DatabaseManager::DatabaseManager(const QString& path)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(path);

    if (!m_db.open())
    {
        qDebug() << "Error: connection with database failed";
    }
    else
    {
        qDebug() << "Database: connection ok";
    }
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen())
    {
        m_db.close();
    }
}

bool DatabaseManager::createTable()
{
    QSqlQuery query;
    QString sql(CREATE_TABLE.arg("items", "ids integer primary key, name text, regNumber text"));

    if (!query.exec(sql))
    {
        qDebug() << "createTable: error on running" << query.lastError();
        return false;
    }
    else
    {
        qDebug() << "createTable: success";
    }

    return true;
}

bool DatabaseManager::insertItem(const QString& name, const QString& regNumber)
{
    bool success = false;

    QSqlQuery query;
    query.prepare("INSERT INTO items (name, regNumber) VALUES (:name, :regNumber)");
    query.bindValue(":name", name);
    query.bindValue(":regNumber", regNumber);

    if(!selectItem(name, Name))
    {
        if (query.exec())
        {
            qDebug() << "insertItem: item was inserted successfully";
            success = true;
        }
        else
        {
            qDebug() << "insertItem: error" << query.lastError();
        }
    }
    else
    {
        if(!selectItem(regNumber, RegNumber))
        {
            if (query.exec())
            {
                qDebug() << "insertItem: item was inserted successfully";
                success = true;
            }
            else
            {
                qDebug() << "insertItem: error" << query.lastError();
            }
        }
        else
        {
            qDebug() << "insertItem: item already exists";
        }
    }

    return success;
}

bool DatabaseManager::selectItem(const QString &string, SearchCategories category)
{
    QSqlQuery query;

    switch(category)
    {
        case Name:
        query.prepare("SELECT name FROM items WHERE name = (:name)");
        query.bindValue(":name", string);
        break;
    case RegNumber:
        query.prepare("SELECT regNumber FROM items WHERE regNumber = (:regNumber)");
        query.bindValue(":regNumber", string);
        break;
    default:
        query.prepare("SELECT name FROM items WHERE name = (:name)");
        query.bindValue(":name", string);
        break;
    }

    if (!query.exec())
    {
        qDebug() << "selectItem: error" << query.lastError();
    }
    else
    {
        if (query.first())
        {
            qDebug() << "selectItem: item found" << query.record();
            return true;
        }
        else
        {
            qDebug() << "selectItem: no such item found";
        }
    }

    return false;
}

bool DatabaseManager::deleteItem(const QString &string, SearchCategories category)
{
    QSqlQuery query;

    switch(category)
    {
        case Name:
        query.prepare("DELETE FROM items WHERE name = (:name)");
        query.bindValue(":name", string);
        break;
    case RegNumber:
        query.prepare("DELETE FROM items WHERE regNumber = (:regNumber)");
        query.bindValue(":regNumber", string);
        break;
    default:
        query.prepare("DELETE FROM items WHERE name = (:name)");
        query.bindValue(":name", string);
        break;
    }

    if (query.exec())
    {
        qDebug() << "deleteItem: item successfully removed";
        return true;
    }
    else
    {
        qDebug() << "deleteItem: error" << query.lastError();
        return false;
    }
}

bool DatabaseManager::dropTable(const QString &tableName)
{
    QSqlQuery query;
    Q_UNUSED(tableName);
    query.prepare("DROP TABLE items");

    if(query.exec())
    {
        qDebug() << "dropTable: successfully dropped table";
        return true;
    }
    else
    {
        qDebug() << "dropTable: error" << query.lastError();
        return false;
    }
}

QList<ItemDetails> DatabaseManager::getDbContent()
{
    QList<ItemDetails> result;
    QSqlQuery query;

    query.prepare("SELECT * FROM items");

    if(query.exec())
    {
        qDebug() << "getDbContent: success";
        while(query.next())
        {
            result.append({query.value(1).toString(), query.value(2).toString()});
        }
    }
    else
    {
        qDebug() << "getDbContent: failed; " << query.lastError();
    }

    return result;
}
