#include <QDate>
#include <QDebug>
#include <QFile>

#include "applicationmanager.h"

ApplicationManager::ApplicationManager(QObject* parent) :
    QObject(parent),
    m_model(new ItemModel),
    m_proxy(new ItemProxyModel),
    m_dbManager(new DatabaseManager("store.db"))
{
    m_dbManager->createTable();
    m_proxy->setSourceModel(m_model);

    QList<ItemDetails> dbContent = m_dbManager->getDbContent();

    if(dbContent.size() == 0)
    {
        importDB();
    }
    else
    {
        for(int i = 0; i < dbContent.size(); ++i)
        {
            m_model->addItem(dbContent[i].name, dbContent[i].regNumber);
        }
    }
}

ApplicationManager::~ApplicationManager()
{
    delete m_model;
    delete m_proxy;
    delete m_dbManager;
}

ItemModel* ApplicationManager::model() const
{
    return m_model;
}

QAbstractItemModel* ApplicationManager::proxy() const
{
    return m_proxy;
}

void ApplicationManager::addItem(const QString& name, const QString& regNumber)
{
    if(m_dbManager->insertItem(name, regNumber))
    {
        m_model->addItem(name, regNumber);
    }
}

void ApplicationManager::removeItem(int index)
{
    QModelIndex proxyIndex = m_proxy->index(index, 0);
    QModelIndex sourceIndex = m_proxy->mapToSource(proxyIndex);
    m_dbManager->deleteItem(m_model->data(sourceIndex, ItemModel::RoleName).toString(), DatabaseManager::Name);
    m_model->removeItem(sourceIndex.row());
}

void ApplicationManager::setProxyFilter(int filter)
{
    this->m_proxy->setFilter(filter);
}

void ApplicationManager::sortProxy(int column, bool isAscendingOrder)
{
    this->m_proxy->setSortRole(Qt::UserRole + 1 + column);
    if(isAscendingOrder)
        this->m_proxy->sort(0,  Qt::AscendingOrder);
    else
        this->m_proxy->sort(0, Qt::DescendingOrder);
}

void ApplicationManager::searchProxy(int role, const QString& string)
{
    this->m_proxy->setFilter(role);
    this->m_proxy->setFilterFixedString(string);
}

void ApplicationManager::clearDB()
{
    if(m_dbManager->dropTable("items"))
    {
        qDebug() << "table dropped succesfully";
        m_model->clearList();
        m_dbManager->createTable();
    }
    else
    {
        qDebug() << "error at table drop";
    }
}

void ApplicationManager::importDB()
{
    clearDB();
    QFile temporaryFile {"Produse.csv"};
    if(temporaryFile.open(QIODevice::ReadOnly))
    {
        int numberOfLines = 0;
        QTextStream line {&temporaryFile};
        while(!line.atEnd())
        {
            QString lineString = line.readLine();
            QStringList lineTokens = lineString.split(",");
            addItem(lineTokens.at(0), lineTokens.at(1));
            ++numberOfLines;
            //if(numberOfLines == 18)
                //break;
        }
    }
    else
    {
        qDebug() << "File not found or error when opening.";
    }
}

void ApplicationManager::exportDB()
{
    QFile temporaryFile {"Produse.csv"};
    if(temporaryFile.open(QIODevice::WriteOnly | QIODevice::Truncate))
    {
        QTextStream out(&temporaryFile);
        QList<ItemDetails> dbContent = m_dbManager->getDbContent();
        for(int i = 0; i < dbContent.size(); ++i)
        {
            out << dbContent[i].name << ',' << dbContent[i].regNumber << '\n';
        }
    }
    else
    {
        qDebug() << "File not found or error when opening.";
    }
}
