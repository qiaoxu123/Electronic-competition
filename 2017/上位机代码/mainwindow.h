#ifndef MAINWINDOW_H
#define MAINWINDOW_H
#include <QtCharts>
using namespace QtCharts;
#include<QChartView>
#include<QSplineSeries>
#include <QMainWindow>
#include<QDebug>
#include<QtMath>
#include<QUdpSocket>
#include<math.h>
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    void paintCurve();
    void processData(QByteArray vdata);
    ~MainWindow();
public slots:
    void recv();

private slots:
    void on_pushButton_clicked();

private:
    Ui::MainWindow *ui;
    QChartView *chartView;
    QChart *m_chart;
    QSplineSeries *m_series;
    int maxSize;
    QUdpSocket *receiver;
};

#endif // MAINWINDOW_H
