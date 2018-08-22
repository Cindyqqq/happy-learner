install.packages("ggplot2")
data("iris",package = 'ggplot2')
head(iris)
plot(sepal.length~sepal.width,data = iris)


say.hello<-function()
+{print("hello,world")}
say.hello()

#substitution
sprintf("hello %s", "class")
sprintf("hello %s, today is %s", "class", "thursday")

hello.test1<-function(name)
+{print(sprintf("hello %s", "cindy"))}
hello.test1("cindy")

#3 dots absorb extra argument
# R automatically return the last line
test3<-function(x)
{x*2}
test3(2)

#do.call function
hello.person<-function(first,last)
+print(sprintf("Hello %s %s", first, last))
do.call("hello.person",args=list(first="Cindy",last="Qin"))


#control statements
tocheck <-function(x)
{
if(x==1)
  {print("hello")
  print("a")}
  else
    {print("empty")
      print("b")}
}

#switch: works in two distinct ways depending whether the first argument evaluates to a character string or a number
use.switch<-function(x)
{switch(x, "a"="first", "b"="second","z"="last","c"="third","other")}
use.switch("a")
use.switch("6")

#xor exclusive or
#&& different from & when used with vector

#linear programming
install.packages("lpSolveAPI")
library("lpSolveAPI")
#define variables
lptest<-make.lp(0,6)
#what we want to do with the objective function
lp.control(lptest,sense="min")
#objective function itself
set.objfn(lptest,c(50,83,130,61,97,145))

add.constraint(lptest,c(1,0,0,1,0,0),"=",3000)
add.constraint(lptest,c(0,1,0,0,1,0),"=",2000)
add.constraint(lptest,c(0,0,1,0,0,1),"=",900)
add.constraint(lptest,c(2,1.5,3,0,0,0),"<=",10000)
add.constraint(lptest,c(1,2,1,0,0,0),"<=",5000)

lptest
solve(lptest)
get.objective(lptest)
get.variables(lptest)


#example2

lptest2<-make.lp(0,2)
#what we want to do with the objective function
lp.control(lptest2,sense="max")
#objective function itself
set.objfn(lptest2,c(9,7))

add.constraint(lptest2,c(12,4),"<=",60)
add.constraint(lptest2,c(4,8),"<=",40)

#set.type(lptest2,1&2, type = c("integer"))
#set.bounds

lptest2
solve(lptest2)
get.objective(lptest2)
get.variables(lptest2)

plot.lpExtPtr(lptest2)


#example3
lptest3<-make.lp(0,2)
#what we want to do with the objective function
lp.control(lptest3,sense="max")
#objective function itself
set.objfn(lptest3,c(3,4))

add.constraint(lptest3,c(0.6,-0.4),">=",0)
add.constraint(lptest3,c(0,1),"<=",250)
add.constraint(lptest3,c(1,1),">=",400)
add.constraint(lptest3,c(1,-2),"=",0)
add.constraint(lptest3,c(1,1),"<=",500)

set.type(lptest3,1:2,"integer")

lptest3
solve(lptest3)
get.objective(lptest3)
get.variables(lptest3)



#Rglpk
install.packages("Rglpk")
