#ifndef ITEMPROXYMODEL_H
#define ITEMPROXYMODEL_H

#include <QSortFilterProxyModel>

#include "itemmodel.h"
#include "utils.h"

class ItemProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int filter READ getFilter WRITE setFilter NOTIFY filterChanged)
public:
    ItemProxyModel();
    ItemProxyModel(ItemModel* model);

    int getFilter() const;

signals:
    void filterChanged();

public slots:
    void setFilter(int filter);

private:
    ItemModel::Roles m_currentFilter;
};

#endif // ITEMPROXYMODEL_H
