###9 流程控制Control Statement

##9-1 if和else

toCheck <- 1

if(toCheck == 1){
  print("hello")
}

if(toCheck == 0){
  print("hello")
}

#也可以寫成函數以便重複使用

check.bool <- function(x){
  if(x == 1){
    print("hello")
  } else{
    print("goodbye")
  }
}
check.bool(1)
check.bool(2)

#若要延續多個條件，可以使用else if

check.bool2 <- function(x){
  if(x == 1){
    print("hello")
  } else if(x == 0){
    print("goodbye")
  } else{
    print("confused")
  }
}
check.bool2(1)
check.bool2(0)
check.bool2(5)

#當我們有好幾個條件要檢測時，用switch函數會比較合適

use.switch <- function(x){
  switch(x,
         "a"="first",
         "b"="second",
         "c"="third",
         "z"="last",
         "other")
}
#最後一個值沒有=只有結果代表這引數為預設結果
use.switch("a")
use.switch("z")
use.switch("g")
use.switch(1)
use.switch(4)
use.switch(7)
#如果給函數的引數為數值的話，代表要對應到第幾個引數，這時候這些引數的名稱會完全被忽略
#若數值比引數的數量還大的話，將會回傳NULL
#可使用is.null()來檢測一個物件是否為NULL
is.null(use.switch(7))

#ifelse用法為ifelse(檢測條件, TURE時回傳值, FALSE時回傳值)

ifelse(1==1, "Yes", "No")
ifelse(1==0, "Yes", "No")

toTest <- c(1,1,0,1,0,1)
ifelse(toTest == 1, "Yes", "No")
ifelse(toTest == 1, toTest*3, toTest)

#若包含NA元素，檢測結果也會為NA
toTest[2] <- NA
toTest
ifelse(toTest == 1, "Yes", "No")
#將TRUE及FALSE的引數改變為vector時也不會改變

##9-4 復合的條件檢測

#單符號跟雙符號的邏輯運算子有些微的差異
#單符號包括&, | 用來比較兩邊的「每一個元素」，適合用在ifelse
#雙符號包括&&, ||用來比較兩邊的「單一元素」，適合用在if

a <- c(1,1,0,1)
b <- c(2,1,0,1)
ifelse(a == 1 && b == 1, "Yes", "No") #雙符號，只比一個
ifelse(a == 1 & b == 1, "Yes", "No") #單符號，每一個都比

