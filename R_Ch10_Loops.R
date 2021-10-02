###10 Loops迴圈

##10-1 for迴圈

#for是最常使用的迴圈，會根據索引(index)進行迭代
#用法為for(變數 in vector)

for(i in 1:10){
  print(i)
}

#上述方法也可以用print(1:10)來完成

#for迴圈裡的vector也可以是非連續性的

fruit <- c("apple", "banana", "pomegranate")
fruitLength <- rep(NA, length(fruit)) #建立變數來儲存水果名稱長度
#先從儲存NA值開始
fruitLength
names(fruitLength) <- fruit #取名
fruitLength
for(a in fruit){
  fruitLength[a] <- nchar(a)
}
#對水果名稱做出迭代，將名稱長度存入vector裡
fruitLength

##10-2 while迴圈

#在R裡，while極少被使用，只要通過所檢測的條件，他就會重複地執行所有命令

x <- 1
while(x <= 5){
  print(x)
  x <- x+1
}

##10-3迴圈的強制處理

#有時候需要跳過一些迭代過程，或者完全退出迴圈
#可以使用next和break來完成這件事

for(i in 1:10){
  if(i == 3){
    next
  }
      print(i)
}

for(i in 1:10){
  if(i == 4){
    break
  }
  print(i)
}

#10-4 小結

#若可以使用向量化計算或是矩陣代數來計算時，就盡量不要使用迴圈
#更重要的是盡量避免使用巢狀迴圈(nested loops)
#因為R在執行迴圈中的迴圈時是非常慢的