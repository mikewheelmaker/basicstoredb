#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QString>

static const QString CREATE_TABLE("CREATE TABLE IF NOT EXISTS %1 (%2)");

struct ItemDetails
{
    QString name;
    QString regNumber;
};

#endif // UTILS_H
