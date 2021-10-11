#ifndef ITEMMODEL_H
#define ITEMMODEL_H

#include <QAbstractListModel>

#include "utils.h"

class ItemModel : public QAbstractListModel
{
public:
    ItemModel();

    enum Roles
    {
        RoleName = Qt::UserRole + 1,
        RoleRegNumber
    };

    void addItem(const QString& name, const QString& regNumber);
    void removeItem(int index);
    void clearList();

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex& parent) const;
    QVariant data(const QModelIndex& index, int role) const;
    QHash<int, QByteArray> roleNames() const;

private:
    QList<ItemDetails> m_list;
};

#endif // ITEMMODEL_H
