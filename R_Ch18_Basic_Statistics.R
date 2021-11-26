### Ch.18 Basic Statistics

## 18-1 摘要統計 Summary Statistics

# 隨機從1~100生成100個數字
x <- sample(1:100, size = 100, replace = TRUE)
x
mean(x)
var(x)
sqrt(var(x))
sd(x)
min(x)
max(x)
median(x)
summary(x)

# 用sample隨機挑選20%個元素為NA
y <- x
y[sample(x = 1:100, size = 20, replace = FALSE)] <- NA
y

mean(y) #會顯示NA
mean(y, na.rm = TRUE)

# 加權平均值 weighted mean
grades <- c(95, 72, 59, 32)
weights <- c(1/2, 1/4, 1/8, 1/8)
mean(grades)
weighted.mean(x = grades, w = weights)

# 四分位數 quantile
quantile(x) # 顯示0, 25, 50, 75, 100百分位數
quantile(x, probs = .25) #顯示25百分位數
quantile(x, probs = c(.25, .80)) #顯示25, 80百分位數

## 18-2 相關係數(correlation)、共變異數(covariance)

library(ggplot2)
head(economics, 3)

# 相關係數 cor
cor(economics$pce, economics$psavert)
cor(economics[, c(2, 4:6)]) # 同時比較好幾個變數

# 繪製GGally的ggpair圖，顯示兩兩變數的散佈圖
GGally::ggpairs(economics[, c(2, 4:6)]) # ::運算子代表直接呼叫函數，不需要載入套件即可使用

# 繪製熱力圖(heatmap)
library(reshape2) # 用來轉換資料
library(scales)  # 增添繪圖功能
econCor <- cor(economics[, c(2, 4:6)]) # 建立相關係數矩陣
econMelt <- melt(econCor, varnames = c("x", "y"), value.name = c("Correlation")) # 轉成直的格式

ggplot(data = econMelt, mapping = aes(x = x, y = y)) +
  geom_tile(aes(fill = Correlation)) + # 畫上磚塊(方塊)，並依據相關係數填上顏色
  scale_fill_gradient2(low = "lightseagreen", mid = "white",
                       high = "cornflowerblue", # 三層色彩漸層，紅為低，白為中，藍為高
                       guide = guide_colorbar(ticks = FALSE, barheight = 10), # 不設有刻度(ticks)的色帶(colorbar)
                       limits = c(-1, 1)) + # 尺度範圍為-1~1
  theme_minimal() + # 簡單主題
  labs(x = NULL, y = NULL) # 將X和Y標籤留空
  

m <- c(9, 9, NA, 3, NA, 5, 8, 1, 10, 4)
n <- c(2, NA, 1, 6, 6, 4, 1, 1, 6, 7)
p <- c(8, 4, 3, 9, 10, NA, 3, NA, 9, 9)
q <- c(10, 10, 7, 8, 4, 2, 8, 5, 5, 2)
r <- c(1, 9, 7, 6, 5, 6, 2, 7, 9, 10)
theMat <- cbind(m, n, p, q, r)
theMat

# 若有任何一行是NA，則該行的相關係數回傳NA
cor(theMat, use = "everything")
# 只要有NA在資料裡，整個資料回傳NA
cor(theMat, use = "all.obs")
# 只會保留不包含任何NA的橫列
cor(theMat, use = "complete.obs")
cor(theMat, use = "na.or.complete")
# 只保留「兩兩都無NA」的橫列
cor(theMat, use = "pairwise.complete.obs")

data(tips, package = "reshape2")
head(tips, 3)
GGally::ggpairs(tips)

# 共變異數(covariance)
cov(economics$pce, economics$psavert)

## 18-3 t test
head(tips, 3)
unique(tips$sex)
unique(tips$day)

# 單一樣本t檢定 One-sample T-Test
t.test(tips$tip, alternative = "two.sided", mu = 2.5)
# alternative = “two.sided”, “less”, “greater”
# mu = 平均值

# 繪製分布圖
library(ggplot2)
randT <- rt(30000, df = NROW(tips)-1)
tipTTest <- t.test(tips$tip, alternative = "two.sided", mu = 2.5)
ggplot(data = data.frame(x = randT)) +
  geom_density(aes(x = x), fill = "grey", color = "grey") +
  geom_vline(xintercept = tipTTest$statistic, color = "red") +
  geom_vline(xintercept = mean(randT) + c(-2, 2)*sd(randT), linetype = 2)

# Two-sample T-Test
# 進行檢定前須檢測兩組樣本是否變異數同質
# 先使用Shapiro-Wilk normality test檢測目前分布是否為常態
aggregate(tip~sex, data = tips, var)

shapiro.test(tips$tip)
shapiro.test(tips$tip[tips$sex == "Female"])
shapiro.test(tips$tip[tips$sex == "Male"])
# 皆p<.05 代表分布不為常態分布
# 故無法使用F檢定(var.test)或Bartlett檢定(bartlett.test)
# 可以使用無母數Ansari-Bradley檢定(ansari.test)來檢測變異數同質性
ansari.test(tip ~ sex, tips)
# p>.05 代表變異數同質，可以使用t test
# 若變異數不同質，則進行Welch test
t.test(tip ~ sex, data = tips, var.equal = TRUE)

# 觀察兩組樣本的平均數是否互相落在對方的兩個標準差之內
library(plyr)
tipSummary <- ddply(tips, "sex", summarise,
                    tip.mean=mean(tip), tip.sd=sd(tip),
                    Lower=tip.mean - 2*tip.sd/sqrt(NROW(tip)),
                    Upper=tip.mean + 2*tip.sd/sqrt(NROW(tip)))
tipSummary

ggplot(data = tipSummary, mapping = aes(x = tip.mean, y = sex)) +
  geom_point() +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = .1)

# Paired Two-sample T-Test
data(father.son, package="UsingR")
head(father.son, 3)

t.test(father.son$fheight, father.son$sheight, paired = TRUE)
heightDiff <- father.son$fheight - father.son$sheight
ggplot(father.son, aes(x=fheight - sheight)) +
  geom_density() +
  geom_vline(xintercept=mean(heightDiff), color = "red") +
  geom_vline(xintercept=mean(heightDiff) +
                  2*c(-1, 1)*sd(heightDiff)/sqrt(nrow(father.son)),
               linetype=2)

## 18-4 ANOVA
tipAnova <- aov(tip ~ day - 1, tips)
tipAnova
summary(tipAnova)
# day-1的作用是忽略截距項

tipsByDay <- ddply(tips, "day", plyr::summarize,
                   tip.mean=mean(tip), tip.sd=sd(tip),
                   Length=NROW(tip),
                   tfrac=qt(p=.90, df=Length-1),
                   Lower=tip.mean - tfrac*tip.sd/sqrt(Length),
                   Upper=tip.mean + tfrac*tip.sd/sqrt(Length))

ggplot(data = tipsByDay, mapping = aes(x = tip.mean, y = day)) +
  geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper, height = .3))

# NROW與nrow的差異
# NROW是確保它會進行運算，nrow只對data.frame和matrices起作用
# 而NROW可以回傳只有一維度物件的長度
