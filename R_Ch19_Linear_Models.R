### Ch.19 Linear Models 線性模型

## 19-1 簡單線性回歸模型 Simple Linear Regression

# 給定一個變數，去預測另一個變數

# 運用父親和兒子的身高資料當作示範
data(father.son, package = "UsingR")
library(ggplot2)
head(father.son, 2)

ggplot(data = father.son, mapping = aes(x = fheight, y = sheight)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) + # se可以選擇要不要產生灰帶
  labs(x = "Father", y = 'Son')

# 計算回歸結果，lm(), summary()
lm(sheight ~ fheight, data = father.son) #只能看到常數項
# 可用summary()來查看完整結果
summary(lm(sheight ~ fheight, data = father.son))

# 也可以用類別變項建立回歸模型，且不加入截距項，可以代替ANOVA
data(tips, package = "reshape2")
head(tips, 2)
summary(aov(tip ~ day - 1, data = tips)) # 將-1放進去是讓截距項不要涵蓋在模型裡
summary(lm(tip ~ day - 1, data = tips))
# 可以看到上述兩個檢定的結果是一樣的

# 繪製信賴區間
tipsInfo <- summary(lm(tip ~ day - 1, data = tips))
tipsCoef <- as.data.frame(tipsInfo$coefficients[, 1:2])
tipsCoef <- within(tipsCoef, {
  Lower <- Estimate - qt(p = .9, df = tipsInfo$df[2]) * `Std. Error`
  Upper <- Estimate + qt(p = .9, df = tipsInfo$df[2]) * `Std. Error`
  day <- rownames(tipsCoef)
})
# within函數可以直接透過直行的欄位名稱來套用某data.frame裡的直行欄位
# 且可以直接允許在該data.frame裡建立新的直行，也建立新的名稱
# 若要讀取一個名稱裡含有空格的變數，需要加上反引號(``)
tipsCoef

ggplot(data = tipsCoef, mapping = aes(x = Estimate, y = day)) +
  geom_point() +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = .2) +
  labs(title = "456") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

## 19-2 多元(複)迴歸模型 Multiple Regression
# 多元回歸代表有多個預測變數

# 使用紐約市開放資料取得公寓評價資料做示範
library(data.table)
housing <- fread("http://www.jaredlander.com/data/housing.csv")
names(housing) <- c("Neighborhood", "Class", "Units", "YearBuilt",
                    "SqFt", "Income", "IncomePerSqFt", "Expense",
                    "ExpensePerSqFt", "NetIncome", "Value",
                    "ValuePerSqFt", "Boro")
head(housing, 2)

# 先將資料圖表化(探索性分析)
ggplot(data = housing, mapping = aes(x = housing$ValuePerSqFt)) +
  geom_histogram(binwidth = 10) +
  labs(x = "Value per Square Foot")

ggplot(data = housing, mapping = aes(x = housing$ValuePerSqFt, fill = Boro)) +
  geom_histogram(binwidth = 10) +
  labs(x = "Value per Square Foot") +
  facet_wrap( ~ Boro)

ggplot(data = housing[housing$Units < 1000, ], mapping = aes(x = SqFt)) +
  geom_histogram(binwidth = 10) #排除Unit過多的單位
ggplot(data = housing[housing$Units < 1000, ], mapping = aes(x = Units)) +
  geom_histogram(binwidth = 10) #排除Unit過多的單位

ggplot(data = housing[housing$Units < 1000, ], mapping = aes(x = SqFt, y = ValuePerSqFt)) +
  geom_point() #排除Unit過多的單位
ggplot(data = housing[housing$Units < 1000, ], mapping = aes(x = Units, y = ValuePerSqFt)) +
  geom_point() #排除Unit過多的單位

# 有多少筆資料是要被移除的
sum(housing$Units >= 1000)
housing <- housing[housing$Units < 1000, ]

# 建立模型
house1 <- lm(ValuePerSqFt ~ Units + SqFt + Boro, data = housing)
summary(house1)
# 若是類別變項會以虛擬變數來處理，所以類別會少一個
# 這是因為是以其作為基準值(baseline level)，其他係數會將參照該基準

# 取得模型係數
house1$coefficients
coef(house1)
coefficients(house1) # 三種方式是一致的

# 畫出係數圖
install.packages("coefplot")
library(coefplot)
coefplot::coefplot(house1, color = "cornflowerblue") +
  theme(plot.title = element_text(hjust = 0.5))

# 交互作用 (*)
house2 <- lm(ValuePerSqFt ~ Units * SqFt + Boro, data = housing)

# 縮放係數圖
coefplot::coefplot(house1, sort = "mag") + scale_x_continuous(limits = c(-.25, .1))

# 將變數標準化
house1.n <- lm(ValuePerSqFt ~ scale(Units) + scale(SqFt) + Boro, data = housing)
coefplot::coefplot(house1.n)

# 若要增加一項用數學關係式所呈現的變數至lm裡
# 可使用I函數，避免函式使用formula的規則來解讀
house6 <- lm(ValuePerSqFt ~ I(SqFt/Units) + Boro, housing)
summary(house6)

# 評判哪個模型式最好的，可以比較每個係數圖
coefplot::multiplot(house1, house2, house6)

# 使用新資料進行對模型進行預測
housingNew <- fread("http://www.jaredlander.com/data/housingNew.csv")
str(housingNew)
housePredict <- predict(house1, newdata = housingNew, se.fit = TRUE,
                        interval = "prediction", level = .95)
# 顯示預測值和根據標準誤所建立的信賴區間上下界
head(housePredict$fit)
# 顯示預設值的標準誤
head(housePredict$se.fit)
