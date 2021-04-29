# Univariate-Time-Series-Analysis
Impact of COVID-19 on Indian Foreign Exchange Earnings - A Time Series Analysis.

Introduction:
The foreign exchange market, often referred to as the Forex, is a market where one currency is traded against another currency. With the increasing globalization of the world economy and the international character of the commodity market, FX trading activity is continuously increasing.
This exchange is essential in commodity trade, due to the international nature of the currency market. The foreign exchange is however also a market on itself, where speculative traders trade different currencies with the intention of making a profit on price fluctuations between currencies.


Motivation:
The importance of Forex Reserves for a nation cannot be counted in numbers.
The foremost advantage of Forex is in meeting the international finance obligations including sovereign and commercial debts, financing of imports. It helps in boosting the confidence of the market in ability of a country to meet its external obligations and also acts as cushion for unforeseen external shocks.
RBI uses the forex to adjust foreign exchange rates. And in the case of sharp fall in the foreign exchange value of the Rupee, RBI sells the Dollar which appreciates the Rupee.
Moreover, India’s Foreign Exchange Reserves contributed 15.419 % to the GDP in Mar 2020 which was recorded to increase from its previous value of 15.053% in December 2019.


Objective:
The objective of this analysis is a comparison study of the following:
1. Forecasting the Foreign Exchange Earning if Covid-19 didn’t occur.
2. Concluding about the decline in the Forex using the plots of both the circumstances.
3. Use of various Time Series Analysis tools in the following Economic data to study about its Trend and Seasonality components



I) We have considered Univariate Time Series of Foreign Exchange Earnings data from January 2011 to February 2020. Hence, we define xt as the Foreign Exchange Earning and plot this Time Series data.

![image](https://user-images.githubusercontent.com/58327067/116501401-4d631300-a8ce-11eb-9220-33818b385b47.png)
We can infer from the plot that there can be a possibility of existence of Seasonality and Trend in the data. Let’s verify this in next steps..

II) In order to know about the presence of Seasonality and Trend we decompose the variable and get the following result.
![image](https://user-images.githubusercontent.com/58327067/116501532-a29f2480-a8ce-11eb-916f-0cfc018bf841.png)

After decomposition, we can see that there is a presence of both stochastic and deterministic trend in the data.

III) We will remove the seesonality component from our data and get the deseasonalized data and check whether it is stationary now using ADF test.
![image](https://user-images.githubusercontent.com/58327067/116501560-b77bb800-a8ce-11eb-8531-dec8e91043c2.png)

Ho: The series is non-stationary, |phi| = 1
Ha: The series is stationary, |phi| < 1
Value of our test statistics is : 1.8391
The critical values for test statistics

IV) We will use the procedure of differencing to remove the non-stationarity from the data. After first differencing (i.e. yt = xt - xt-1) we will plot the data and recheck the presence of non - stationarity in the data and further check using ADF test.
Ho: The series is non-stationary, |phi| = 1
Ha: The series is stationary, |phi| < 1
Value of our test statistics is : -9.1092
The critical values for test statistics:

Value of ADF test statistics(observed value) = -9.1092
|observed test statistics value| > |tabulated value|.
Hence, we reject the null hypothesis in favour of the alternative hypothesis
Our series yt is now stationary.

![image](https://user-images.githubusercontent.com/58327067/116501607-daa66780-a8ce-11eb-83e6-cfb69a02351f.png)

Comment : Now, there an absence of stochastic trend (cancer) in the Time series which can be seen from the plot also.

V) Now that we have removed the seasonality component, we will move our attention to check the presence of any deterministic trend (Fever). We will use lm() inbuilt R-function for this. Using De-seasonalized series, yt Our linear model will be yt = a + bt + ut Ho: The series is stationary, b = 0 Ha: The series is non-stationary, b! = 0

Residual standard error: 7243 on 107 degrees of freedom Multiple R-squared: 0.004307, Adjusted R-squared: -0.004999 F-statistic: 0.4628 on 1 and 107 DF, p-value: 0.4978 Since the p value 0.4978 greater than 0.05 hence insignificant. We accept the null hypothesis and conclude that there is no trend present in the series and now Comment: • yt is free from both Stochastic Trend(cancer), no unit root and Deterministic Trend (fever). • We have performed First Order differencing on the original series.

VI) Now that our data is free from all kinds non – stationarity, we can check the type of process it follows (AR/MA/ARMA). From the Correlogram, we can see that ACF shows a diminishing behaviour. This means our series follows AR or ARMA

![image](https://user-images.githubusercontent.com/58327067/116501665-03c6f800-a8cf-11eb-93f0-b12aacd593ab.png)

For this we will use Ljung-Box test.
Ho: rho1 = rho2 = .... = rho15 = 0 (all autocorrelation coefficients equals zero).
Ha : none of them are 0

From the calculations it is clear that our series follows AR or ARMA model.

VII) Checking Partial Autocorrelation
H0: phi1 = phi2=...... = phi15 = 0 (all partial autocorrelation coefficients equal 0)
Ha: none of the partial autocorrelation coefficients are 0.

From the PACF table we can see that it cuts off after 3rd lag which means that our series follows AR(3) model.

The correlogram for our series is: 
![image](https://user-images.githubusercontent.com/58327067/116501807-69b37f80-a8cf-11eb-9d54-a91e5fd041d2.png)

VIII) Estimation: Our model hence follows AR(3) model. Now we will make estimation and take out the residual to check if there is any correlation between the residual errors.

IX) Residual Diagnostics: We will check whether error terms follow White Noise or not. For this we will perform Ljung test on residuals. The residuals follow Chi-square distribution with k-p-q degrees of freedom, where p is the order of AR model and q is the order of MA model.

X) Model Fitting: Now, since we are sure that our data follows AR(3) model, we will now fit our original data using arima() function.

XI) Forecasting: Finally, we will use the inbuilt function forecast() to make forecasts

![image](https://user-images.githubusercontent.com/58327067/116501930-c4e57200-a8cf-11eb-8e5a-b8aa851bc381.png)

