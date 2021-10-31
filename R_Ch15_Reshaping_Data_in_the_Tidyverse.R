### 15 Reshaping Data in the Tidyverse

## 15-1 合併橫列與直行

# dyplr中與rbind, cbind相似的函數為bind_rows, bind_cols

library(dplyr)
library(tibble)

# 建立一個擁有兩個直行的tibble
sportLeague <- tibble(sport = c("Hockey", "Baseball", "Football"),
                      league = c("NHL", "MLB", "NFL"))
# 再建立一個擁有一個直行的tibble
trophy <- tibble(trophy = c("Stanley Cup", "Commissioner's Trophy",
                            "Vince Lombardi Trophy"))
# 將其合併 bind_cols
trophiesl <- bind_cols(sportLeague, trophy)
# 使用tribble函數建立另一個tibble (逐列建立的捷徑)
trophies2 <- tribble(
  ~sport, ~league, ~trophy,
  "Basketball", "NBA", "Larry O'Brien Champion Trophy",
  "Golf", "PGA", "wanamaker Trophy"
)
# 將其合併 bind_rows
trophies <- bind_rows(trophiesl, trophies2)
trophies


## 15-2 使用dplyr於資料連結

# 可以使用dplyr中的left_join, right_join, inner_join, full_join, semi_join, anti_join
# 以下由diamonds資料為例

library(readr)
colorsURL <- 'http://www.jaredlander.com/data/DiamondColors.csv'
diamondColors <- read_csv(colorsURL)
diamondColors
length(diamondColors$Color)

# 載入diamonds資料，等等用來合併
library(ggplot2)
data(diamonds)
unique(diamonds$color)

# 執行左連結(left_join)，且將索引鍵(使用 by = c() )設定好
# 左連結代表，只有匹配到左手邊的橫列會被保留
# diamonds的索引鍵為color, diamondsColors的索引鍵為Color
library(dplyr)
left_join(diamonds, diamondColors, by = c("color" = "Color"))

# 可以使用select來選擇想要檢視的欄位
left_join(diamonds, diamondColors, by = c("color" = "Color")) %>% 
  select(carat, color, price, Description, Details)
# 可以觀常到右手邊的唯一資料比左邊的唯一資料還多，但只有匹配的會留下來
left_join(diamonds, diamondColors, by = c("color" = "Color")) %>%
  distinct(color, Description)

diamondColors %>% distinct(Color, Description) 

# 而右連結(right_join)保留右手邊表格的橫列
right_join(diamonds, diamondColors, by = c("color" = "Color")) %>% 
  nrow
# 可又看到右連結產生的橫列會比左手邊的資料來的多
diamonds %>% nrow

# 內部連結(inner_join)只會回傳兩個表格交集的橫列，若不匹配則不會回傳
# 在這個例子裏面，左連結=內部連結，右連結=外部連結(full_join)
all.equal(
  left_join(diamonds, diamondColors, by = c("color" = "Color")),
  inner_join(diamonds, diamondColors, by = c("color" = "Color"))
)

all.equal(
  right_join(diamonds, diamondColors, by = c("color" = "Color")),
  full_join(diamonds, diamondColors, by = c("color" = "Color"))
)

# 半連結(semi_join)則是不將兩個表格合併，而是回傳左邊表格第一個匹配到右邊表格的橫列
# 為橫列篩選，若左邊表格的橫列匹配到右邊表格的數列橫列
# 只有第一個匹配的橫列將會被回傳
semi_join(diamondColors, diamonds, by = c("Color" = "color"))

# 反連結(anti_join)則是半連結的相反，回傳無法匹配到右表格的左表格橫列
anti_join(diamondColors, diamonds, by = c("Color" = "color"))

# 雖然可以透過filter及unique達到與semi_join和anti_join同樣的結果
# 但若使用dplyr來操作資料庫時，後者將會是比較好的選擇

diamondColors %>% filter(Color %in% unique(diamonds$color))
diamondColors %>% filter(!Color %in% unique(diamonds$color))


## 15-3 轉換資料格式

# tidyr為reshape2的進階版，目的是要比reshape2更容易使用
# 以下以哥倫比亞大學的實驗資料為例
library(readr)
# 資料為文字檔(txt), 以tab做分隔
emotion <- read_tsv('http://www.jaredlander.com/data/reaction.txt')
emotion

# 使用gather函數，將Age, BMI, React, Regulate直行的值收入Measurement中
# 而Type直行則儲存原本的欄位名稱

# gather函數的首要引數為欲轉換的data.frame或tibble
# key 指定新建直行來儲存原本名稱
# value 指定新建直行用來儲存所收集的直行資料的值
library(tidyr)
emotion %>% 
  gather(key = Type, value = Measurement,
         Age, BMI, React, Regulate)

# 資料會依照新建的Type做排序，但很難觀察到資料有什麼變化
# 所以可以依資料ID來進行排序
emotionLong <- emotion %>% 
  gather(key = Type, value = Measurement,
         Age, BMI, React, Regulate) %>% 
  arrange(ID)

head(emotionLong, 20)

# 也可以指定我們要轉置的直行，並透過增加負號(-)來指定不想轉置的直行
emotion %>% 
  gather(key = Type, value = Measurement,
         -ID, -Test, -Gender)

# 會得到與上述同樣的結果
identical(
  emotionLong <- emotion %>% 
    gather(key = Type, value = Measurement,
           Age, BMI, React, Regulate),
  emotion %>% 
    gather(key = Type, value = Measurement,
           -ID, -Test, -Gender)
)

# 與gather相反的函數為spread，會將資料轉換成橫列導向
# 函數中的key引數指定含有新欄位名稱之直行
# value引數則用來指定儲存新欄位值的直行
emotionLong %>% 
  spread(key = Type, value = Measurement)