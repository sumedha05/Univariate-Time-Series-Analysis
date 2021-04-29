
#*****************************************************************#
#**** Monthly Earnings from Foreign Exchange(INR mn) in India ****#
#*****************************************************************#

#
# "Time Series Analysis: Assignment"
# author: "Sumedha - DST-19/20-023"
# date: "July 14th, '20"
# ---

#**** Data Structure ****#
# Variable    : Foreign Exchange Earnings(INR mn)
# Region      : India
# Start Date  : Jan '11
# End Date    : Feb '20
# Frequency   : Monthly
# Source      : Ministry of Tourism, GOI
# Remarks     : COVID-19-Impact
# Total No of : 110
# Observations



library(urca)
library(forecast)
library(tseries)

Foreign_Ex = read.csv("Foreign Exchange Earnings.csv")
df = data.frame(Foreign_Ex[146:255,])
colnames(df) = c("MM/YYYY", "Earnings(INR mn)")
df
earnings = df$`Earnings(INR mn)`
Earnings = as.vector(earnings)


#*** Step I)
#*** Converting data into time series object and showing its time series plot

#Time Series Data
Forex_ts = ts(as.numeric(Earnings), frequency=12, start=c(2011,01),end = c(2020,02))
Forex_ts

#Plot
plot(Forex_ts, type = "l", main = "Foreign Exchange Earnings (INR mn)",
     xlab = "Years", ylab = "Earnings (INR mn)", col = "violetred")

#Comment :  From the plot we can find a probable presence of trend and seasonality in the data 


#*** Step II) 
#*** Removal Of Seasonality

#Decomposing it into additive type model of its trend, seasonalilty, and random error components.
dc_earning = decompose(Forex_ts, type = "additive")
plot(dc_earning,lwd="2",col="springgreen")


#Deseasonalisation of Series
#Extracting the seasonal component from series
seasonal_comp = dc_earning$seasonal

#Substracting the seasonal componenet from the actual series to get the deseasonalised series
des_xt = Forex_ts - seasonal_comp

#Plotting deseasonalised data
plot(des_xt, type='l', lwd = "2",main = "Deseasonalised Series",xlab = "Years",ylab = "Earnings (INR mn)",
     col = "darkslateblue")


#*** Step III)
#*** Checking stationarity using ADF test (Unit-root test)

#Ho: The series is non-stationary, |phi| = 1 
#Ha: The series is stationary, |phi| < 1

#if(!require(urca)){install.packages("urca")}
adf = ur.df(des_xt,type = c("none","drift","trend"), selectlags = "AIC")
summary(adf)

# Value of ADF test statistics(observed value) = 1.8391
# |Observed test statistics value| < |tabulated value| for 1% and 5% level of significance. 
# Comment: We fail to reject null hypothesis and can say that our series is not stationary.

#First differencing to proceed.
#xt= x(t)- x(t-1)
yt= diff(des_xt)
yt
length(yt)

#Checking stationarity again using ADF test (Unit-root test)
adf1 = ur.df(yt,type = c("none","drift","trend"), selectlags = "AIC")
summary(adf1)
ts.plot(yt, col = "darkgreen",lwd = "2", main = "Deseasonalized Earnings", ylab = "Earnings(INR mn)")

# Value of ADF test statistics(observed value) = -9.1092
# |observed test statistics value| > |tabulated value|. 
# Hence, we reject the null hypothesis in favour of the alternative hypothesis
# Our series yt is now stationary.
# Comment : Now, there an absence of stochastic trend (cancer) in the Time series


#Deterministic trend(fever) check!
#Using Deseasonlized series yt
#Our model yt= a + bt  + ut

#Ho: The series is stationary, b = 0 
#Ha: The series is non-stationary, b != 0

t = seq(1:109)
trend = summary(lm(yt~t))
trend

# Since the p value 0.4978 greater than 0.05 hence insignificant.
# We accept the null hypothesis and conclude that
# there is no trend present in the series and now  
# Comment: * yt is free from both Stochastic Trend(cancer), no unit root and Deterministic Trend (fever).
#          * We have performed First Order differencing


#*** Applying ACF and PACF to determine the type of process it is: AR(p)/ MA(q)/ ARMA(p,q) ***#


#*** Step IV)
#*** Test for the sample acf
#*** Ljung Box test
#*** Checking ACF Plots


#Plotting the ACF of differenced stationary series with 95 % confidence limits.
ACF = acf(yt,lag.max=20, plot = T)
summary(ACF)

#Formulating Ljung-Box test for finding q statistics and p-value for ACF Test

#Hypothesis
#Ho : rho1 = rho2 = .... = rho15 = 0 (all autocorrelation coefficients equals zero).
#Ha : none of them are 0

# calculating sample ACF
rho_hat=c()
yt_=yt-mean(yt)
for(i in c(1:15))
{
  k=(sum(yt_[(i+1):length(yt)]*yt_[1:(length(yt)-i)]))/(sum(yt_**2))
  rho_hat=append(rho_hat,k)
}
rho_hat

#calculating q-statistics,Q(K) and p-value
q_stats =c()
p_value =c()
for (i in 1:15) {
  q = Box.test(yt,lag = i, type = "Ljung-Box")
  q_stats[i] = as.numeric(q$statistic)
  p_value[i] = q$p.value
}

#ACF test Statistic,Q(K) follows chi-square distribution with k degrees of freedom.


#***Checking test statistics for conclusion
# if the obtained test statistic is more than the critical value, reject the Null hypothesis.

#Critical values follow chi-square distribution with k df at 5% significance level
chisq = qchisq(0.05, df = 1:15, lower.tail = F)
conclusion_acf = ifelse(q_stats>chisq,"Rejected","Accepted")


acf_tab = data.frame("k" = seq(1,15,1), "Rho k hat" = rho_hat, "Q(k)"= q_stats, 
                      "Critical Value" = chisq, "Conclusion" = conclusion_acf)
acf_tab

# From this ACF table, ACF is showing a diminishing behaviour as all the Ljung-Box tests are rejected, 
# This could be the behaviour of AR/ARMA model.


#*** Step V) 
#*** Checking for Partial autocorrelation


#Plotting the PACF of differenced stationary series
PACF = pacf(yt,lag.max=20,plot=T)
summary(PACF)

#Sample Pacf
PACF$acf[1:15]

#Hypothesis
#H0: phi_1 = phi_2=...... = phi_15 = 0 (all partial autocorrelation coefficients equal 0)
#Ha: none of the partial autocorrelation coefficients are 0.

#PACF test Statistics follows normal distribution
pacf_tstats = sqrt(length(yt))*as.numeric(PACF$acf[1:15])

#Critical region Normal distribution at 5% significance level
z = qnorm(0.05/2, lower.tail = F)
conclusion_pacf = ifelse(abs(pacf_tstats)> z,"Rejected","Accepted")

pacf_tab = data.frame("k"= seq(1,15,1),"Sample Pacf"= as.numeric(PACF$acf[1:15]),
                      "TS"= pacf_tstats,"C value"= 1.96, "Result" = conclusion_pacf)
pacf_tab

# From the PACF table, we can see that PACF cuts off after 3rd lag and becomes insignificant 4th onwards
# Hence, we can say that our series shows behaviour of AR(3) Model.


#*** Step VI)
#*** Estimation
#*** Fitting the AR model using arima function.

#Fitting a AR model to our series using arima function
AR = arima(yt, order = c(3,0,0))
AR


#*** Step VII) 
#*** Residual Diagnostics
#*** Box-Ljung test for residuals (White-Noise check!)

#Testing autocorrelations in residuals, 
qstat_err = c()
pval_err = c()
for (i in 1:15){
  q_err = Box.test(AR$residuals,lag=i,type="Ljung-Box", fitdf=1)
  qstat_err[i] = as.numeric(q_err$statistic)
  pval_err[i] = q_err$p.value
}

qstat_err

#Test Statistic
#As we have fitted AR(3) model, 
#Test statistics follows Chi-square distribution with k-p-q = k-3 degrees of freedom (p = 3, q = 0).

#Critical Value
chisqrp = c(NA,NA,NA, qchisq(0.1, df = 1:12, lower.tail = F))
res_error = ifelse(qstat_err > chisqrp, "Rejected","Accepted")
err_tab = data.frame("k"= seq(1,15,1),"Test Statistics" = qstat_err, 
                     "Critical Value"=chisqrp, "Conclusion" = res_error)
err_tab

# Since all the conclusions are accepted in the Ljung-Box test on residuals
# Hence, there's no significant correlations in the residuals. 
# So our specified model is correct according to Residual Diagnostics.


#*** Step VIII)
#*** Selected Model

# Our final selected model is AR(3) having first - order differencing

#Now, fitting the selected model (AR(3)) on Original Time series data for forecasting, 
#taking seasonal order and differencing into account.

AR_Model = arima(Forex_ts, order = c(3,1,0), seasonal = list(order = c(3,1,0),period = 12))
AR_Model


#*** Step IX)
#*** Forecasting
#*** Forecasting values for 1 future year based on the model with confidences of 85% and 90%

if(!require(forecast)){install.packages("forecast")}
prediction = forecast(AR_Model, 12)
prediction

#Plotting the forecasted value with original time series data
plot(prediction, xlab = "Years", ylab = "Foreign Exchange Earnings (INR MN)", 
     main = "Forecast of Foreign Exchange Earnings of Next 1 Year")



#plotting the actual data including the month of march
df1 = data.frame(Foreign_Ex[146:256,])
colnames(df1) = c("MM/YYYY", "Earnings(INR mn)")
df1
earnings1 = df$`Earnings(INR mn)`
Earnings1 = as.vector(earnings1)


#*** Step I)
#*** Converting data into time series object and showing its time series plot

#Time Series Data
Forex_ts1 = ts(as.numeric(Earnings1), frequency=12, start=c(2011,01),end = c(2020,03))
Forex_ts1

#Plot
plot(Forex_ts1, type = "l", main = "Foreign Exchange Earnings (INR mn)",
     xlab = "Years", ylab = "Earnings (INR mn)", col = "violetred")

### Hence from the plot we can predict that there is a huge decline in the earnings due to COVID-19

