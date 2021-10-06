#ifndef APPLICATIONMANAGER_H
#define APPLICATIONMANAGER_H

#include <QObject>

#include "itemmodel.h"
#include "itemproxymodel.h"
#include "databasemanager.h"

class ApplicationManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractListModel* itemModel READ model CONSTANT)
    Q_PROPERTY(QAbstractItemModel* itemProxyModel READ proxy CONSTANT)
public:
    explicit ApplicationManager(QObject* parent = nullptr);
    ~ApplicationManager();

    ItemModel* model() const;
    QAbstractItemModel* proxy() const;

    Q_INVOKABLE void addItem(const QString& name, const QString& regNumber);
    Q_INVOKABLE void removeItem(int index);
    Q_INVOKABLE void setProxyFilter(int filter);
    Q_INVOKABLE void sortProxy(int column, bool isAscendingOrder = true);
    Q_INVOKABLE void searchProxy(int role, const QString& string);
    Q_INVOKABLE void clearDB();
    Q_INVOKABLE void importDB();
    Q_INVOKABLE void exportDB();

private:
    ItemModel* m_model;
    ItemProxyModel* m_proxy;
    DatabaseManager* m_dbManager;
};

#endif // APPLICATIONMANAGER_H
