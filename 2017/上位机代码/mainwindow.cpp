#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    maxSize=40;
    this->paintCurve();
}

void MainWindow::paintCurve()
{
    m_chart=new QChart();
    chartView=new QChartView(m_chart);
    chartView->setRubberBand(QChartView::RectangleRubberBand);
    m_series=new QSplineSeries ;
    m_chart->addSeries(m_series);
    for(double i=0;i<maxSize;++i){
          m_series->append(log10(i),0);
      }
    m_series->setUseOpenGL(true);//openGl 加速
    qDebug()<<m_series->useOpenGL();
    QCategoryAxis *axisX = new QCategoryAxis;
    axisX->setGridLineVisible(false);
    axisX->setRange(0,2);
    axisX->setLabelsPosition(QCategoryAxis::AxisLabelsPositionOnValue);
    axisX->append("1",0);
    axisX->append("10",1);
    axisX->append("100",2);
    axisX->setGridLineVisible(true);
    //axisX->setLabelFormat("%g");
    axisX->setTitleText("频率(MHz)");
    QValueAxis *axisY = new QValueAxis;
    axisY->setRange(0,10);
    axisY->setTickCount(11);
    axisY->setTitleText("幅值(V)");
    QCategoryAxis *top=new QCategoryAxis;
    top->setRange(0,2);
    QPen pen;
    //pen.setColor(gray);
    pen.setStyle(Qt::DotLine);
    top->setShadesPen(pen);
    //top->setShadesBrush(QBrush(QColor(0x99, 0xcc, 0xcc, 0x55)));
    top->setShadesBrush(Qt::NoBrush);
    top->setShadesVisible(true);
    top->setLabelsVisible(false);
    top->setLineVisible(false);
    for(double i=2;i<=9;i++){
        top->append(QString::number(log10(i)),log10(i));
    }
    for(double i=2;i<=9;i++){
        top->append(QString::number(1+log10(i)),1+log10(i));
    }
    m_series->attachAxis(axisX);
    m_series->attachAxis(axisY);
    top->setGridLineVisible(false);
    m_chart->addAxis(top,Qt::AlignTop);
    m_chart->setAxisX(axisX,m_series);
    m_chart->setAxisY(axisY,m_series);
    m_chart->legend()->hide();
    m_chart->setTitle("幅频特性曲线展示");
   ui->verticalLayout->addWidget(chartView);
}

void MainWindow::processData(QByteArray vdata)
{  m_series->pointsVector();
   bool ok=true;
   qDebug()<<vdata;
   float x,y;
   QList<QByteArray> datalist=vdata.split(',');
   for(int i=0;i<datalist.length();i++){
       if(!datalist[i].isEmpty()){
           QList<QByteArray> littleList=datalist[i].split('.');
           m_series->remove(0);
           x=log10(littleList[0].toDouble(&ok));
           y=littleList[1].toDouble(&ok);
           m_series->append(x,y);
       }
   }
  // qDebug()<<vdata.length();

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::recv()
{
    while (receiver->hasPendingDatagrams()) {
       QByteArray data;
       data.resize(receiver->pendingDatagramSize());
       receiver->readDatagram(data.data(),data.size());
       this->processData(data);
    }
}



void MainWindow::on_pushButton_clicked()
{  if(ui->pushButton->text()=="连接"){
        ui->pushButton->setText("断开");
        int port;
        receiver=new QUdpSocket(this);
        int index=ui->comboBox->currentIndex();
         switch(index){
             case 0:port=80;break;
             case 1:port=8080;break;
             case 2:port=6660;break;
             case 3:port=6665;break;
             default:port=80;break;
         }
         QString str=ui->lineEdit->text();
         receiver->bind(QHostAddress::AnyIPv4,port,QUdpSocket::ShareAddress);
         connect(receiver,SIGNAL(readyRead()),this,SLOT(recv()));
    }else{
        ui->pushButton->setText("连接");
        disconnect(receiver,SIGNAL(readyRead()),this,SLOT(recv()));
        delete receiver;
    }



}
