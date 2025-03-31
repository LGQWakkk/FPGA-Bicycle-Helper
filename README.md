## 数字系统课程设计-基于FPGA的GPS自行车辅助终端

source/bicycle: 自行车端Verilog

source/mobile: 移动端Verilog

​        大一的时候做的课程设计，现在已经基本不用FPGA了，这个仓库仅作为留念和参考

​        主要使用FPGA实现了用户交互，图形界面渲染与显示，传感器交互。所有模块Verilog全部手写，没有调用任何IP核，实现了UART SPI IIC总线驱动，以及在串口之上实现了GPS NMEA协议解析和LORA无线模块通信。

​        项目具体信息详见files文件夹。



图形界面：

![](images/img1.png)

Mobile端：

![](images/img2.png)

Bicycle端：

![](images/img5.png)