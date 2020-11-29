
use "mypaneldata.dta", clear
//定义数据集的路径
xtset id year
//定义面板数据

*1)单位根检验
xtunitroot llc unemp, trend lags(aic 12)
xtunitroot llc transfer, trend lags(aic 12)
xtunitroot llc grgdp, trend lags(aic 12)
xtunitroot ips unemp, trend lags(aic 12)
xtunitroot ips transfer, trend lags(aic 12)
xtunitroot ips grgdp, trend lags(aic 12)
xtunitroot ht unemp,trend 
xtunitroot ht transfer, trend 
xtunitroot ht grgdp, trend
gen dunemp=d.unemp
gen dtransfer=d.transfer
gen dgrgdp=d.grgdp
xtunitroot ips dunemp, trend lags(aic 12)
xtunitroot ips dtransfer, trend  lags(aic 12)
xtunitroot ips dgrgdp, trend lags(aic 12)
xtunitroot ht dunemp,trend 
xtunitroot ht dtransfer, trend 
xtunitroot ht dgrgdp, trend
xtunitroot llc dunemp, trend lags(aic 12)
xtunitroot llc dtransfer, trend lags(aic 12)
xtunitroot llc dgrgdp, trend lags(aic 12)

//检验各个变量的平稳性,均是平稳的，可以做Granger检验

*2）确定滞后阶数
pvarsoc dtransfer dunemp dgrgdp, maxlag(3) pvaropts(instl(1/4))
//选择AIC,BIC或是QIC值最小的模型，lag=1时这三个值都是最小，因此选择滞后1阶

*3)在面板数据上用GMM估计VAR
pvar dtransfer dunemp dgrgdp,instlags(1/8) lag(1)fod level(95) gmmstyle
//滞后期为1
//fod消除面板的固定效应。fod指定使用正向正交偏差或Helmert变换来消除面板固定效应
//gmmstyle指定使用Douglas et.al(1988)提出的“GMM-style”工具。
pvarstable,graph
//所有特征值均在单位圆内，说明模型稳定

*4）脉冲响应Estimate impulse-response functions (IRF)
//pvarirf, step(6) impulse(dtransfer) response(dunemp) mc(1000)level(95) dots byopt(rescale)
//pvarirf, step(6) impulse(dtransfer) response(dgrgdp) mc(1000)level(95) dots byopt(rescale)
//子图像单独显示
pvarirf, step(6) mc(1000)level(95) dots byopt(rescale)
//延后6期，95%置信区间，蒙特卡罗模拟1000次，加入延时点显示，每一个子图像都含有横纵坐标

*5)方差分解forecast-error variance decompositions (FEVD)
pvarfevd, step(10) mc(1000) 
//3个差分内生变量分别作因变量时，其他变量对因变量的脉冲响应值

