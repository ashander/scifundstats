
## @knitr NA
prj.stats =read.csv('proj.txt')
prj.stats$percent.funded = with(prj.stats, fund_attained/fund_goal)
prj.stats$multiple.contributions = with(prj.stats, total_contributions/unique_contributions)
prj.stats$average.contribution = with(prj.stats, fund_attained/total_contributions)
prj.stats$multiple.contributions.bool = prj.stats$multiple.contributions > 1


## @knitr unnamed-chunk-1
lm.funded1 = lm(percent.funded~description_length+ total_contributions+ 
  fund_goal+ multiple.contributions+ average.contribution, data = prj.stats)


## @knitr NA
lm.funded = step(lm.funded1)


## @knitr NA
a = summary(lm.funded)
coef(a)


## @knitr NA
lm.avgive1 = lm(average.contribution~description_length+
  total_contributions+
  fund_goal+
  multiple.contributions, data = prj.stats)


## @knitr NA
lm.avgive = step(lm.avgive1)


## @knitr NA
b = summary(lm.avgive)
coef(b)


## @knitr NA
require(ggplot2)
prj.stats$description_length =cut_number(prj.stats$description_length, n=5)
prj.stats$av.contrib.factor = cut_number(prj.stats$average.contribution, n=3)
g = ggplot(prj.stats)


## @knitr percent-funded
g+theme_bw() + geom_point(aes(fund_goal, percent.funded, size=total_contributions, color=description_length))+ facet_grid(multiple.contributions.bool~av.contrib.factor)+scale_color_brewer(type='seq')


## @knitr average-contribution
g +theme_bw() + geom_point(aes(multiple.contributions, average.contribution, color=description_length, size=fund_goal))+scale_color_brewer(type='seq')

#g +theme_bw()+ geom_boxplot(aes(multiple.contributions.bool, average.contribution))+ geom_point(aes(multiple.contributions.bool, average.contribution, color=description_length, size=fund_goal))+scale_color_brewer(type='seq')


