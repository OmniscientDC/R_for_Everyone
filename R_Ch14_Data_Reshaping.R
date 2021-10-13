### 14 資料整理 Data Reshaping

## 14-1 cbind和rbind資料合併

# 若要整理兩組擁有相同直行或相同列數的資料
# 可以使用rbind跟cbind對資料進行合併

# 建立兩個vector，將他們當作data.frame裡的欄位合併起來
sport <- c("Hockey", "Baseball", "Football")
league <- c("NHL", "MLB", "NFL")
trophy <- c("Stanley Cup", "Commissioner's Trophy", "Vince Lombardi Trophy")
trophiesl <- cbind(sport, league, trophy)

# 利用data.frame()建立另一個 data.frame
trophies2 <- data.frame(sport = c("Basketball", "Golf"), league=c("NBA", "PGA"), trophy=c("Larry O'Brien Championship Trophy", "Wanamaker Trophy"),stringsAsFactors = FALSE)

# 再利用rbind整合成一個data.frame
trophies <- rbind(trophiesl, trophies2)
head(trophies)

# 也可以利用cbind來指定直行的欄位名稱
cbind(Sport = sport, Association = league, Prize = trophy)

## 14-2 資料連結

# 未經處理的資料較為凌亂，無法直接使用cbind來合併，需透過一些索引鍵來進行
# 最常見的函數為merge函數、plyr套件的join函數和data.table的合併功能等

# 利用USAID的資料
# 下載他並命名，寫unzip他並存入data12資料夾
download.file(url = "https://www.jaredlander.com/data/US_Foreign_Aid.zip", destfile="ForeignAid.zip")
unzip("ForeignAid.zip", exdir = "data12")

# 共有8個檔案，利用for迴圈來載入
# 先用dir取得檔案的列表，然後對該列表進行迭代
# 並透過assign函數對每組資料指派名稱
# str_sub函數可以從一個character vector萃取出單獨的character

library(stringr)

theFiles <- dir("data12/", pattern = "\\.csv") #取的檔案的列表
for(a in theFiles){
  #建立適合名字指派到資料群，strsub(從哪個字元開始，第12~18個字留下)
  nameToUse <- str_sub(string = a, start = 12, end = 18) 
  #利用read.table讀取csv檔
  #用file.path來指定資料夾和檔名
  temp <- read.table(file = file.path("data12", a),
                     header = TRUE, sep = ",",
                     stringsAsFactors = FALSE)
  #再指派到工作空間
  assign(x=nameToUse, value = temp)
}

# 14-2-1 用merge合併兩個data.frame
Aid90s00s <- merge(x = Aid_90s, y = Aid_00s,
                   by.x = c("Country.Name", "Program.Name"),
                   by.y = c("Country.Name", "Program.Name"))
head(Aid90s00s)
# 其中 by.x 用來指定左邊data.frame裡要作為索引鍵的直行
#  by.y 用來指定右邊data.frame裡要作為索引鍵的直行
# merge的特點是可以對每個data.frame指定不同名稱的直行做為連結
# 但缺點是他的速度比其他連結方法來的慢


# 14-2-2 用 plyr 套件的 join 函數來合併 data.frame
# 優點是運行速度較快，缺點是在鎖鑰連結的每個列表中
# 索引鍵的直行名稱必須是一樣的
library(plyr)
Aid90s00sJoin <- join( x = Aid_90s, y = Aid_00s,
                       by = c("Country.Name", "Program.Name"))
head(Aid90s00sJoin)

# join的其中一個引數可以指定左連結、右連結；內部或完全(外部)連結

# 用剛剛所匯入的8個資料，全部合併成一個data.frame
# 可以先將所有data.frame放進一個list，再用Reduce陸續做連結
# Reduce()就是對一個向量循環執行函數

# 先找出data.frame的名稱
frameNames <- str_sub(string = theFiles, start = 12, end = 18)
# 建立一個空的list
frameList <- vector("list", length(frameNames))
names(frameList) <- frameNames
# 把每個data.frame放入list裡
for (a in frameNames) {
  frameList[[a]] <- eval(parse(text = a))
}
# data.frame的名字皆為字元，可用parse()解析該字元，使其轉換為變數(表達式)
# 再用eval()執行字串的表達式，並返回表達式的值
head(frameList[[1]])
head(frameList[[6]])
head(frameList[["Aid_50s"]])

# 將所有data.frame置入list後，可對所有list進行迭代
# 將所有元素連結在一起，可以用Reduce來加快速度
allAid <- Reduce(function(...){
  join(..., by = c("Country.Name", "Program.Name"))
}, frameList)
dim(allAid)

# 利用useful套件來觀看部分資料
install.packages("useful")
library(useful)
corner(allAid, 15)
bottomleft(allAid, c = 15)

# Reduce簡介，例如想要算vector 1~10的整數
# 可以使用Reduce(sum, 1:10)，他會先把1跟2加起來，接著再把3加到之前的計算結果
# 然後再把4加到計算結果，直到類推至將10加進計算結果
# 故Reduce會先將list中的前兩個data.frame做連結，接下來的data.frame會和該結果再作連結
# 直到所有data.frame被連結在一起


# 14-2-3 data.table中的資料合併

# data.table做資料連結需要比較不一樣的指令，甚至需要一些不一樣的想法
# 例如先將其中兩組資料從data.frame轉換成data.tables
library(data.table)
dt90 <- data.table(Aid_90s, key = c("Country.Name", "Program.Name"))
dt00 <- data.table(Aid_00s, key = c("Country.Name", "Program.Name"))
# 做連結的時候需要用到索引鍵
dt0090 <- dt90[dt00]
# 在上述例子裡，dt90為左邊，dt00為右邊，因此該指令所執行的是左連結


## 14-3 用reshape2 套件置換行、列資料

# 14-3-1 melt

# 例如將資料的每一列以"國家-援助計畫-年份"的形式呈現
# 以及所對應的援助金額(Dollar)會被新儲存在一個直行裡
head(Aid_00s)

install.packages("reshape2")
library(reshape2)
melt00 <- melt(Aid_00s, id.vars = c("Country.Name", "Program.Name"), variable.name = "Year", value.name = "Dollars")
tail(melt00, 10)
head(melt00, 10)
# id.vars引數是用來指定一些可以辨識不同列的直行
# variable.name引數為將列名稱改為直行的名稱
# value.name引數為之前每列的直行數值合併後的直行名稱

# 來繪圖
library(scales)
# 先將Year欄位名稱中的"FY"去除，並將它轉換成numeric
melt00$Year <- as.numeric(str_sub(melt00$Year, start = 3, 6))
# 再依照年份和援助計畫進行分群
meltAgg <- aggregate(Dollars ~ Program.Name + Year, data = melt00, FUN = "sum", na.rm = TRUE)
# 只保留援助計畫名稱的前十個字元
# 這樣名字才能恰到好處地被放入圖中
meltAgg$Program.Name <- str_sub(meltAgg$Program.Name, start = 1, end = 10)
library(ggplot2)
ggplot(meltAgg, aes(x = Year, y = Dollars)) + 
  geom_line(aes(group = Program.Name)) +
  facet_wrap(~ Program.Name) +
  scale_x_continuous(breaks = seq(from = 2000, to = 2009, by = 2)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 0)) +
  scale_y_continuous(labels = multiple_format(extra = dollar, multiple = "B"))

# 14-3-2 dcast

# 若需要將資料還原到原本的表格呈現方式，可以使用dcast函數
# dcast函數稍微複雜一些，第一個引數為欲還原的資料
# 第二引數為formula，左邊為要保留的直行，右邊是指定新直行的名稱
# 第三引數為欲分配到新直行李的值的直行名稱

cast00 <- dcast(melt00, Country.Name + Program.Name ~ Year,
                value.var = "Dollars")
head(cast00)
