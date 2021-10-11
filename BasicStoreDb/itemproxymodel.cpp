#include "itemproxymodel.h"
#include "itemmodel.h"

ItemProxyModel::ItemProxyModel()
{

}

ItemProxyModel::ItemProxyModel(ItemModel* model) : QSortFilterProxyModel(), m_currentFilter(ItemModel::RoleName)
{
    Q_UNUSED(model);
}

int ItemProxyModel::getFilter() const
{
    return static_cast<int>(m_currentFilter);
}

void ItemProxyModel::setFilter(int filter)
{
    auto filterType = ItemModel::RoleName;
    if(filter == 1)
    {
        filterType = ItemModel::RoleRegNumber;
    }

    m_currentFilter = filterType;
    this->setFilterRole(m_currentFilter);
    emit filterChanged();
}
