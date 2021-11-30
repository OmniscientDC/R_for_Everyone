### Ch.12 Group Manipulation with dplyr 更有效率的群組操作-使用dplyr

library(dplyr)

## 12-1 Pipe管線運算

data(diamonds, package = "ggplot2")
dim(head(diamonds, n=4))
diamonds %>% head(4) %>% dim

## 12-2 tbl物件

# 使用dplyr的話，資料會以tbl的形式顯示
diamonds

## 12-3 select

# select(data, data$, data$)
select(diamonds, cut, depth)
diamonds %>% select(cut, depth)
diamonds[, c("cut", "depth")]
select(diamonds, 2, 5)

# 若要搜尋部分匹配的結果，可以用starts_with, ends_with, contains
diamonds %>% select(starts_with("c")) # 起始為c的欄位名稱
diamonds %>% select(ends_with("e")) # 結束字母為e的欄位名稱
diamonds %>% select(contains("a")) # 包含字母為a的欄位名稱
diamonds %>% select(matches("r.+t"))
# match代表正規表示法 .代表搜尋任何文字 +代表指搜尋一次
diamonds %>% select(-carat, -price) # 取消選擇特定的直行，可用負號
diamonds %>% select(-1, -7)

## 12-4 filter

diamonds %>% filter(cut == "Very Good")
diamonds[diamonds$cut == "Ideal", ]

# 若橫列篩選條件是直行內的值等於其中幾個值時，可以使用%in%
diamonds %>% filter(cut %in% c("Ideal", "Very Good"))

diamonds %>% filter(carat > .1 & carat < .3)
diamonds %>% filter(carat > .1) %>% filter(carat < .3)
diamonds %>% filter(carat > .1, carat < .3)

## 12-5 slice
# slice是使用橫列索引來選取特定橫列

diamonds %>% slice(1:6)
diamonds %>% slice(1:7, 9, 15:23)
diamonds %>% slice(-1:-10)

## 12-6 mutate
# mutate可以用來新增直行，或對既有直行進行變更

diamonds %>% select(price, carat) %>% mutate(pricar = price/carat)
diamonds %>% select(price, carat) %>% mutate(prica = price/carat, ratio = prica*2)

# 如果想要同時儲存變更，可以使用magrittr套件的%<>%
# 就可以同時將左邊的物件送到右邊的函數，並將右邊函數結果指派回左邊
library(magrittr)
diamonds2 <- diamonds

diamonds2 %<>% select(price, carat) %>% mutate(prica = price/carat, ratio = prica*2)
identical(diamonds %>% select(price, carat) %>% mutate(prica = price/carat, ratio = prica*2),
          diamonds2)

## 12-7 summarize
# mutate會對直行套用向量化的函數，而summarize函數會回傳長度為1的結果

summarise(diamonds, mean(price))
diamonds %>% summarise(mean(price))

diamonds %>% summarise(Avg = mean(price),
                       Med = median(price),
                       AvgC = mean(carat))

## 12-8 group_by
# group_by 可將資料分割成幾個區塊，再將函數應用到每個區塊

diamonds %>% 
  group_by(cut, color) %>% 
  summarise(Avg = mean(price))

## 12-9 arrange
# arrange可以用來進行資料排序

diamonds %>% 
  group_by(cut) %>% 
  summarise(Avg = mean(price),
            Sum = sum(carat)) %>% 
  arrange(-Avg)

## 12-10 do
# do可以用在一般性的運算上，此函數可讓任意的函數套用在資料上

#可以先定義一個function
TopN <- function(x, N=3){
  x %>% arrange(-price) %>% head(N)
}

diamonds %>% group_by(cut) %>% do(TopN(.,N=3))

