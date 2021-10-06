#include "itemmodel.h"

ItemModel::ItemModel()
{

}

void ItemModel::addItem(const QString& name, const QString& regNumber)
{
    beginResetModel();
    m_list.append({name, regNumber});
    endResetModel();
}

void ItemModel::removeItem(int index)
{
    beginResetModel();
    m_list.removeAt(index);
    endResetModel();
}

void ItemModel::clearList()
{
    beginResetModel();
    m_list.clear();
    endResetModel();
}

int ItemModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return m_list.size();
}

QVariant ItemModel::data(const QModelIndex& index, int role) const
{
    if(m_list.size() >= index.row())
    {
        if (role == RoleName)
        {
            return m_list[index.row()].name;
        }
        if (role == RoleRegNumber)
        {
            return m_list[index.row()].regNumber;
        }
    }
    return QVariant();
}

QHash<int, QByteArray> ItemModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(RoleName, "name");
    roles.insert(RoleRegNumber, "regNumber");
    return roles;
}
